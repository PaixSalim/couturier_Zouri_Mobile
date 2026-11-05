import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Erreur renvoyée par l'API, au format `{"code", "detail", "errors"}`.
class ApiException implements Exception {
  ApiException(this.statusCode, this.message, {this.code, this.errors});

  final int statusCode;
  final String message;

  /// Identifiant machine (ex. `payment_exceeds_balance`, `validation_error`).
  final String? code;
  final Map<String, dynamic>? errors;

  /// Refus métier ou donnée invalide : rejouer la même requête ne changera rien.
  bool get estRefus => statusCode >= 400 && statusCode < 500 && statusCode != 401;

  @override
  String toString() => message;
}

/// Client de l'API Dev Couturier (`/api/v1`), authentification JWT.
class ApiClient {
  ApiClient(this.baseUrl, {http.Client? httpClient}) : _http = httpClient ?? http.Client();

  final String baseUrl;
  final http.Client _http;

  String? _access;
  String? _refresh;
  String? _workshopId;
  Future<void>? _renouvellement;

  static const _accessKey = 'api_access';
  static const _refreshKey = 'api_refresh';
  static const _workshopKey = 'api_workshop';

  // Render (free) peut mettre ~50 s a sortir de veille.
  static const _timeout = Duration(seconds: 60);

  // ─── Session ──────────────────────────────────────────────────

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('api_token'); // jeton de l'ancien serveur
    _access = prefs.getString(_accessKey);
    _refresh = prefs.getString(_refreshKey);
    _workshopId = prefs.getString(_workshopKey);
  }

  Future<void> _saveTokens(String access, String refresh) async {
    _access = access;
    _refresh = refresh;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessKey, access);
    await prefs.setString(_refreshKey, refresh);
  }

  Future<void> clearToken() async {
    _access = null;
    _refresh = null;
    _workshopId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
    await prefs.remove(_workshopKey);
  }

  /// Le jeton d'accès expire vite (15 min) : c'est le refresh qui dit si la session vit.
  bool get isAuthenticated => _refresh != null;

  /// Atelier courant : toutes les données métier lui appartiennent.
  String? get workshopId => _workshopId;

  Future<void> setWorkshop(String id) async {
    _workshopId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_workshopKey, id);
  }

  /// Chemin d'une ressource de l'atelier courant, ex. `atelier('/clients/')`.
  String atelier(String chemin) {
    final id = _workshopId;
    if (id == null) throw StateError('Aucun atelier sélectionné.');
    return '/api/v1/workshops/$id$chemin';
  }

  String catalogue(String chemin) {
    final id = _workshopId;
    if (id == null) throw StateError('Aucun atelier sélectionné.');
    return '/api/v1/catalog/workshops/$id$chemin';
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final res = await _http
        .post(
          Uri.parse('$baseUrl/api/v1/auth/token/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'username': username, 'password': password}),
        )
        .timeout(_timeout);
    final data = _decoder(res);
    if (res.statusCode != 200) {
      throw _erreur(res.statusCode, data, defaut: 'Identifiants incorrects.');
    }
    final map = data as Map<String, dynamic>;
    await _saveTokens(map['access'] as String, map['refresh'] as String);
    return map;
  }

  /// Invalide le refresh token côté serveur, puis oublie la session.
  Future<void> logout() async {
    final refresh = _refresh;
    try {
      if (refresh != null) await post('/api/v1/auth/logout/', {'refresh': refresh});
    } catch (_) {
      // Hors ligne ou jeton déjà invalide : on se déconnecte quand même localement.
    } finally {
      await clearToken();
    }
  }

  Future<void> _renouveler() async {
    final refresh = _refresh;
    if (refresh == null) throw ApiException(401, 'Session expirée : reconnectez-vous.');
    final res = await _http
        .post(
          Uri.parse('$baseUrl/api/v1/auth/token/refresh/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refresh': refresh}),
        )
        .timeout(_timeout);
    if (res.statusCode != 200) {
      await clearToken();
      throw ApiException(401, 'Session expirée : reconnectez-vous.');
    }
    final data = _decoder(res) as Map<String, dynamic>;
    // Rotation : le serveur renvoie un nouveau refresh, l'ancien est mis en liste noire.
    await _saveTokens(data['access'] as String, (data['refresh'] as String?) ?? refresh);
  }

  // ─── Requêtes ─────────────────────────────────────────────────

  Future<dynamic> get(String chemin, {Map<String, String>? query}) =>
      _envoyer('GET', _uri(chemin, query));

  Future<dynamic> post(String chemin, [Map<String, dynamic>? corps]) =>
      _envoyer('POST', _uri(chemin), corps ?? const {});

  Future<dynamic> patch(String chemin, Map<String, dynamic> corps) =>
      _envoyer('PATCH', _uri(chemin), corps);

  /// Toutes les pages d'une liste paginée (`{count, next, results}`).
  Future<List<Map<String, dynamic>>> getAll(String chemin, {Map<String, String>? query}) async {
    final resultats = <Map<String, dynamic>>[];
    Uri? page = _uri(chemin, {'page_size': '100', ...?query});
    while (page != null) {
      final data = await _envoyer('GET', page);
      if (data is List) {
        resultats.addAll(data.cast<Map<String, dynamic>>());
        break;
      }
      final map = data as Map<String, dynamic>;
      resultats.addAll((map['results'] as List).cast<Map<String, dynamic>>());
      final suivante = map['next'] as String?;
      page = suivante == null ? null : Uri.parse(suivante);
    }
    return resultats;
  }

  Uri _uri(String chemin, [Map<String, String>? query]) {
    final uri = Uri.parse('$baseUrl$chemin');
    return query == null || query.isEmpty ? uri : uri.replace(queryParameters: query);
  }

  Future<dynamic> _envoyer(String methode, Uri uri, [Map<String, dynamic>? corps]) async {
    var res = await _requete(methode, uri, corps);
    if (res.statusCode == 401 && _refresh != null) {
      // Un seul renouvellement à la fois, même si plusieurs requêtes expirent ensemble.
      await (_renouvellement ??= _renouveler().whenComplete(() => _renouvellement = null));
      res = await _requete(methode, uri, corps);
    }
    final data = _decoder(res);
    if (res.statusCode >= 200 && res.statusCode < 300) return data;
    throw _erreur(res.statusCode, data);
  }

  Future<http.Response> _requete(String methode, Uri uri, Map<String, dynamic>? corps) {
    final requete = http.Request(methode, uri)
      ..headers['Accept'] = 'application/json'
      ..headers['Content-Type'] = 'application/json';
    if (_access != null) requete.headers['Authorization'] = 'Bearer $_access';
    if (corps != null) requete.body = jsonEncode(corps);
    return _http.send(requete).then(http.Response.fromStream).timeout(_timeout);
  }

  static dynamic _decoder(http.Response res) {
    if (res.bodyBytes.isEmpty) return <String, dynamic>{};
    try {
      return jsonDecode(utf8.decode(res.bodyBytes));
    } on FormatException {
      return <String, dynamic>{'detail': 'Réponse inattendue du serveur (${res.statusCode}).'};
    }
  }

  static ApiException _erreur(int statut, dynamic data, {String? defaut}) {
    if (data is Map) {
      final errors = data['errors'] is Map ? Map<String, dynamic>.from(data['errors'] as Map) : null;
      var message = data['detail']?.toString() ?? defaut ?? 'Erreur serveur ($statut).';
      if (errors != null && errors.isNotEmpty) {
        final premier = errors.entries.first;
        final texte = premier.value is List ? (premier.value as List).join(' ') : premier.value.toString();
        message = '$message (${premier.key} : $texte)';
      }
      return ApiException(statut, message, code: data['code']?.toString(), errors: errors);
    }
    return ApiException(statut, defaut ?? 'Erreur serveur ($statut).');
  }

  // ─── Ateliers ─────────────────────────────────────────────────

  /// Profil de l'utilisateur connecté (id, username, email, first_name, last_name).
  Future<Map<String, dynamic>> moi() async => await get('/api/v1/auth/me/') as Map<String, dynamic>;

  Future<List<Map<String, dynamic>>> listerAteliers() => getAll('/api/v1/workshops/');

  Future<Map<String, dynamic>> creerAtelier(String nom) async =>
      await post('/api/v1/workshops/', {'name': nom, 'country': 'BF'}) as Map<String, dynamic>;

  // ─── Notifications ────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final data = await get('/api/v1/notifications/') as Map<String, dynamic>;
    return (data['results'] as List).cast<Map<String, dynamic>>();
  }

  Future<int> nonLues() async {
    try {
      final data = await get('/api/v1/notifications/unread-count/') as Map<String, dynamic>;
      return (data['unread'] as num?)?.toInt() ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<void> marquerLu(String id) => post('/api/v1/notifications/$id/read/');

  Future<void> marquerToutLu() => post('/api/v1/notifications/read-all/');
}
