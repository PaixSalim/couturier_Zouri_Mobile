import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';
import '../database/tables.dart';
import 'api_client.dart';
import 'correspondances.dart';

/// Synchronisation avec l'API Dev Couturier, ressource par ressource.
///
/// 1. Envoi des modifications locales (`isSynced = false`), dans l'ordre des
///    dépendances : clients → mesures → modèles → commandes → paiements.
///    Commandes et paiements portent leur ID local en `client_request_id` :
///    un renvoi après coupure réseau ne crée pas de doublon.
/// 2. Récupération des données du serveur. Une ligne modifiée localement et pas
///    encore envoyée n'est jamais écrasée : elle partira à la prochaine sync.
///
/// L'appli ne stocke que ce que l'API connaît : atelier, membres, clients,
/// relevés de mesures, catalogue, commandes (un article) et paiements.
class SyncService {
  final AppDatabase _db;
  final ApiClient _api;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySub;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  SyncService(this._db, this._api);

  static const _lastSyncKey = 'last_sync_time';
  static const _dernierPullMesuresKey = 'last_measurements_pull';
  static const _moiKey = 'api_moi';

  /// Identifiant serveur de l'utilisateur connecté (null avant la première sync).
  Future<String?> moiId() async => (await SharedPreferences.getInstance()).getString(_moiKey);

  /// Les relevés de mesures se lisent client par client : relecture complète une fois par jour.
  static const _intervallePullMesures = Duration(hours: 24);

  Future<void> loadLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_lastSyncKey);
    if (stored != null) {
      _lastSyncTime = DateTime.tryParse(stored);
    }
  }

  Future<void> _persistLastSyncTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncKey, time.toIso8601String());
  }

  void startListening() {
    loadLastSyncTime();
    _connectivitySub = _connectivity.onConnectivityChanged.listen((results) {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (hasConnection && _api.isAuthenticated && !_isSyncing) {
        executeSync();
      }
    });
  }

  void stopListening() {
    _connectivitySub?.cancel();
  }

  String? _lastSyncError;
  String? get lastSyncError => _lastSyncError;

  DateTime? _lastSyncTime;
  DateTime? get lastSyncTime => _lastSyncTime;

  /// Éléments refusés par le serveur lors de la dernière sync (donnée invalide, règle métier).
  final List<String> _rejets = [];
  List<String> get rejets => List.unmodifiable(_rejets);

  /// Nombre d'enregistrements locaux non synchronisés
  Future<int> pendingCount() async {
    Future<int> compter(TableInfo table, GeneratedColumn<bool> isSynced) async {
      final n = countAll();
      final row = await (_db.selectOnly(table)
            ..addColumns([n])
            ..where(isSynced.equals(false)))
          .getSingle();
      return row.read(n) ?? 0;
    }

    final comptes = await Future.wait([
      compter(_db.clients, _db.clients.isSynced),
      compter(_db.commandes, _db.commandes.isSynced),
      compter(_db.paiements, _db.paiements.isSynced),
      compter(_db.fichesMesures, _db.fichesMesures.isSynced),
      compter(_db.modeles, _db.modeles.isSynced),
    ]);
    return comptes.fold<int>(0, (s, n) => s + n);
  }

  VoidCallback? onSyncError;
  VoidCallback? onSyncComplete;

  Future<bool> login(String username, String password) async {
    try {
      await _api.login(username, password);
      await _choisirAtelier();
      executeSync();
      return true;
    } catch (e) {
      _lastSyncError = 'Échec de connexion : $e';
      debugPrint(_lastSyncError);
      return false;
    }
  }

  /// Premier atelier de l'utilisateur ; s'il n'en a aucun, il est créé (l'utilisateur en devient propriétaire).
  Future<void> _choisirAtelier() async {
    if (_api.workshopId != null) return;
    final ateliers = await _api.listerAteliers();
    if (ateliers.isNotEmpty) {
      await _api.setWorkshop(ateliers.first['id'] as String);
      return;
    }
    final salon = await (_db.select(_db.salons)..limit(1)).getSingleOrNull();
    final cree = await _api.creerAtelier(salon?.nom ?? 'Mon atelier');
    await _api.setWorkshop(cree['id'] as String);
  }

  Future<void> executeSync() async {
    if (_isSyncing) return;
    _isSyncing = true;
    _lastSyncError = null;
    _rejets.clear();

    try {
      await _choisirAtelier();
      await _pousserAtelier();
      await _pousserClients();
      await _pousserMesures();
      await _pousserModeles();
      await _pousserCommandes();
      await _pousserPaiements();

      final prefs = await SharedPreferences.getInstance();
      final dernierPull = DateTime.tryParse(prefs.getString(_dernierPullMesuresKey) ?? '');
      final mesuresCompletes =
          dernierPull == null || DateTime.now().difference(dernierPull) > _intervallePullMesures;
      await _tirer(mesuresCompletes: mesuresCompletes);
      if (mesuresCompletes) {
        await prefs.setString(_dernierPullMesuresKey, DateTime.now().toIso8601String());
      }

      _lastSyncTime = DateTime.now();
      await _persistLastSyncTime(_lastSyncTime!);
      if (_rejets.isNotEmpty) {
        _lastSyncError = '${_rejets.length} élément(s) refusé(s) par le serveur. ${_rejets.first}';
        debugPrint('Sync : ${_rejets.join('\n')}');
        onSyncError?.call();
      } else {
        onSyncComplete?.call();
      }
    } catch (e) {
      _lastSyncError = 'Sync échouée : $e';
      debugPrint(_lastSyncError);
      onSyncError?.call();
    } finally {
      _isSyncing = false;
    }
  }

  /// Un refus du serveur (400/403/404/409) ne bloque que l'élément concerné ;
  /// une panne réseau ou une session expirée interrompt toute la sync.
  Future<void> _essayer(String quoi, Future<void> Function() action) async {
    try {
      await action();
    } on ApiException catch (e) {
      if (!e.estRefus) rethrow;
      _rejets.add('$quoi : ${e.message}');
    }
  }

  // ─── Écriture locale des résultats ────────────────────────────

  /// Écrit des colonnes sans condition (ex. l'UUID serveur, qui ne doit jamais être perdu).
  Future<void> _ecrire(TableInfo table, String id, Map<String, String?> colonnes) async {
    if (colonnes.isEmpty) return;
    await _db.customUpdate(
      'UPDATE ${table.actualTableName} SET ${colonnes.keys.map((c) => '$c = ?').join(', ')} WHERE id = ?',
      variables: [for (final v in colonnes.values) Variable<String>(v), Variable<String>(id)],
      updates: {table},
      updateKind: UpdateKind.update,
    );
  }

  /// Marque la ligne envoyée, sauf si elle a été modifiée depuis (updatedAt différent).
  Future<void> _marquer(TableInfo table, String id, DateTime updatedAt,
      [Map<String, String?> colonnes = const {}]) async {
    await _ecrire(table, id, colonnes);
    await _db.customUpdate(
      'UPDATE ${table.actualTableName} SET is_synced = 1 WHERE id = ? AND updated_at = ?',
      variables: [Variable<String>(id), Variable<DateTime>(updatedAt)],
      updates: {table},
      updateKind: UpdateKind.update,
    );
  }

  Future<Client?> _client(String id) =>
      (_db.select(_db.clients)..where((c) => c.id.equals(id))).getSingleOrNull();

  // ─── 1. Envoi ─────────────────────────────────────────────────

  /// Fiche atelier modifiée dans Réglages → PATCH de l'atelier
  /// (refusé si l'utilisateur n'est pas responsable : l'atelier reprend alors les valeurs du serveur).
  Future<void> _pousserAtelier() async {
    final salon = await (_db.select(_db.salons)..where((s) => s.isSynced.equals(false))..limit(1))
        .getSingleOrNull();
    if (salon == null) return;
    try {
      await _api.patch('/api/v1/workshops/${_api.workshopId}/', {
        'name': _tronquer(salon.nom, 160),
        'phone': _tronquer(salon.telephone ?? '', 32),
        'email': salon.email ?? '',
        'address': _tronquer(salon.adresse ?? '', 255),
      });
      await _marquer(_db.salons, salon.id, salon.updatedAt);
    } on ApiException catch (e) {
      if (!e.estRefus) rethrow;
      await (_db.update(_db.salons)..where((s) => s.id.equals(salon.id)))
          .write(const SalonsCompanion(isSynced: Value(true)));
      _rejets.add('Atelier : ${e.message}');
    }
  }

  Future<void> _pousserClients() async {
    final lignes = await (_db.select(_db.clients)..where((c) => c.isSynced.equals(false))).get();
    for (final c in lignes) {
      await _essayer('Client ${c.nom}', () async {
        if (c.remoteId == null && c.deletedAt != null) {
          await _marquer(_db.clients, c.id, c.updatedAt);
          return;
        }
        final nom = nomVersApi(c.nom, c.prenom);
        final corps = {
          'first_name': nom.firstName,
          'last_name': nom.lastName,
          'phone': c.telephone ?? '',
          'email': c.email ?? '',
          'address': _tronquer(c.adresse ?? '', 255),
          'notes': c.note ?? '',
          'is_active': c.deletedAt == null,
        };
        var remoteId = c.remoteId;
        if (remoteId == null) {
          final r = await _api.post(_api.atelier('/clients/'), corps) as Map<String, dynamic>;
          remoteId = r['id'] as String;
        } else {
          await _api.patch(_api.atelier('/clients/$remoteId/'), corps);
        }
        await _marquer(_db.clients, c.id, c.updatedAt, {'remote_id': remoteId});
      });
    }
  }

  /// Une fiche + ses mesures = un relevé côté API. Un relevé est immuable :
  /// une fiche modifiée après envoi part comme un nouveau relevé.
  Future<void> _pousserMesures() async {
    final mesuresModifiees =
        await (_db.select(_db.mesures)..where((m) => m.isSynced.equals(false))).get();
    final fichesTouchees = mesuresModifiees.map((m) => m.ficheId).toSet();
    final fiches = await (_db.select(_db.fichesMesures)
          ..where((f) => f.isSynced.equals(false) | f.id.isIn(fichesTouchees)))
        .get();
    for (final f in fiches) {
      await _essayer('Mesures « ${f.libelle} »', () async {
        final mesures = await (_db.select(_db.mesures)
              ..where((m) => m.ficheId.equals(f.id) & m.deletedAt.isNull())
              ..orderBy([(m) => OrderingTerm.asc(m.ordre)]))
            .get();
        Future<void> marquerTout([Map<String, String?> colonnes = const {}]) async {
          await _marquer(_db.fichesMesures, f.id, f.updatedAt, colonnes);
          for (final m in mesuresModifiees.where((m) => m.ficheId == f.id)) {
            await _marquer(_db.mesures, m.id, m.updatedAt);
          }
        }

        if (f.deletedAt != null || mesures.isEmpty) {
          await marquerTout(); // pas de suppression côté API
          return;
        }
        final client = await _client(f.clientId);
        if (client?.remoteId == null) return; // le client doit d'abord exister sur le serveur
        final r = await _api.post(_api.atelier('/clients/${client!.remoteId}/measurements/'), {
          'values': {for (final m in mesures) m.nomMesure: m.valeur},
          'unit': uniteReleve(mesures.map((m) => m.unite)),
          'notes': f.libelle,
        }) as Map<String, dynamic>;
        await marquerTout({'remote_id': r['id'] as String});
      });
    }
  }

  Future<void> _pousserModeles() async {
    final lignes = await (_db.select(_db.modeles)..where((m) => m.isSynced.equals(false))).get();
    for (final m in lignes) {
      await _essayer('Modèle ${m.nom}', () async {
        if (m.remoteId == null && m.deletedAt != null) {
          await _marquer(_db.modeles, m.id, m.updatedAt);
          return;
        }
        final corps = {
          'name': m.nom,
          'description': m.description ?? '',
          'category': _tronquer(m.typeVetement ?? '', 80),
          'base_price': '${m.prixIndicatif ?? 0}',
          'image_url': m.imageUrl ?? '',
          // L'API ne supprime pas un modèle : il est retiré du catalogue client.
          'is_published': m.deletedAt == null && m.estPublie,
        };
        var remoteId = m.remoteId;
        if (remoteId == null) {
          final r = await _api.post(_api.catalogue('/models/'), corps) as Map<String, dynamic>;
          remoteId = r['id'] as String;
        } else {
          await _api.patch(_api.catalogue('/models/$remoteId/'), corps);
        }
        await _marquer(_db.modeles, m.id, m.updatedAt, {'remote_id': remoteId});
      });
    }
  }

  Future<void> _pousserCommandes() async {
    final lignes = await (_db.select(_db.commandes)..where((c) => c.isSynced.equals(false))).get();
    for (final c in lignes) {
      await _essayer(_nomCommande(c), () => _pousserCommande(c));
    }
  }

  Future<void> _pousserCommande(Commande c) async {
    if (c.remoteId == null && c.deletedAt != null) {
      await _marquer(_db.commandes, c.id, c.updatedAt);
      return;
    }
    final client = await _client(c.clientId);
    if (client?.remoteId == null) return;
    final modele = c.modeleId == null
        ? null
        : await (_db.select(_db.modeles)..where((m) => m.id.equals(c.modeleId!))).getSingleOrNull();
    // Le modèle doit exister sur le serveur pour être rattaché.
    if (modele != null && modele.remoteId == null) return;

    final echeanceOk = echeanceAcceptee(c.dateEcheance);
    final description = _tronquer(c.description ?? '', 255);
    final article = {
      'name': _tronquer(description.trim().isEmpty ? 'Confection' : description.trim(), 160),
      'description': '',
      'quantity': 1,
      'unit_price': '${c.prixConvenu}',
    };

    var remoteId = c.remoteId;
    var statut = c.statutDistant ?? 'draft';
    if (remoteId == null) {
      final r = await _api.post(_api.atelier('/orders/'), {
        'client': client!.remoteId,
        'catalog_model': modele?.remoteId,
        'description': description,
        'due_date': echeanceOk ? dateApi(c.dateEcheance) : null,
        'notes': c.notes ?? '',
        'items': [article],
        'client_request_id': c.id,
      }) as Map<String, dynamic>;
      remoteId = r['id'] as String;
      statut = r['status'] as String;
      // Le lien est enregistré tout de suite : un échec plus loin ne doit pas recréer la commande.
      await _ecrire(_db.commandes, c.id,
          {'remote_id': remoteId, 'statut_distant': statut, 'reference': r['reference'] as String?});
    } else if (statut != 'delivered' && statut != 'cancelled') {
      final r = await _api.patch(_api.atelier('/orders/$remoteId/'), {
        'catalog_model': modele?.remoteId,
        'description': description,
        if (echeanceOk) 'due_date': dateApi(c.dateEcheance),
        'notes': c.notes ?? '',
        if (articlesModifiables(statut)) 'items': [article],
      }) as Map<String, dynamic>;
      statut = r['status'] as String;
    }

    final cible = c.deletedAt != null ? 'cancelled' : statutCommandeVersApi(c.statut);
    final chemin = cheminStatuts(statut, cible);
    if (chemin == null) {
      await _revenirAuStatutServeur(c, statut);
      _rejets.add('${_nomCommande(c)} : le serveur est déjà au statut '
          '« $statut », retour en arrière impossible.');
      return;
    }
    for (final etape in chemin) {
      try {
        final r = await _api.post(_api.atelier('/orders/$remoteId/status/'), {'status': etape})
            as Map<String, dynamic>;
        statut = r['status'] as String;
        await _ecrire(_db.commandes, c.id, {'statut_distant': statut});
      } on ApiException catch (e) {
        if (!e.estRefus) rethrow;
        await _revenirAuStatutServeur(c, statut);
        _rejets.add('${_nomCommande(c)} : ${e.message}');
        return;
      }
    }
    await _marquer(_db.commandes, c.id, c.updatedAt, {'statut_distant': statut});
  }

  /// Transition refusée : la commande locale reprend le statut du serveur.
  Future<void> _revenirAuStatutServeur(Commande c, String statutApi) =>
      (_db.update(_db.commandes)..where((t) => t.id.equals(c.id))).write(CommandesCompanion(
        statut: Value(statutCommandeDepuisApi(statutApi)),
        statutDistant: Value(statutApi),
        deletedAt: const Value(null),
        isSynced: const Value(true),
      ));

  String _nomCommande(Commande c) =>
      'Commande ${c.reference ?? (c.description?.trim().isNotEmpty == true ? c.description!.trim() : '')}'
          .trim();

  Future<void> _pousserPaiements() async {
    final lignes = await (_db.select(_db.paiements)..where((p) => p.isSynced.equals(false))).get();
    for (final p in lignes) {
      await _essayer('Paiement de ${p.montant} FCFA', () => _pousserPaiement(p));
    }
  }

  Future<void> _pousserPaiement(Paiement p) async {
    var remoteId = p.remoteId;
    var statut = p.statutDistant ?? 'pending';
    String? recu = p.numeroRecu;
    if (remoteId == null) {
      if (p.deletedAt != null || p.statut == StatutPaiement.echoue) {
        await _marquer(_db.paiements, p.id, p.updatedAt); // jamais encaissé : rien à déclarer
        return;
      }
      final commande =
          await (_db.select(_db.commandes)..where((c) => c.id.equals(p.commandeId))).getSingleOrNull();
      if (commande?.remoteId == null) return;
      final r = await _api.post(_api.atelier('/payments/'), {
        'order': commande!.remoteId,
        'amount': '${p.montant}',
        'method': methodeVersApi(p.mode),
        'transaction_reference': p.reference ?? '',
        'notes': _tronquer(p.note ?? '', 500),
        'client_request_id': p.id,
      }) as Map<String, dynamic>;
      remoteId = r['id'] as String;
      statut = r['status'] as String;
      recu = r['receipt_number'] as String?;
      await _ecrire(_db.paiements, p.id, {'remote_id': remoteId, 'statut_distant': statut, 'numero_recu': recu});
    }

    final cible = p.deletedAt != null
        ? 'cancelled'
        : switch (p.statut) {
            StatutPaiement.reussi => 'confirmed',
            StatutPaiement.echoue => 'failed',
            _ => 'pending',
          };
    if (cible != statut) {
      if (statut != 'pending') {
        // Seul un paiement en attente change de statut ici (remboursement : depuis le tableau de bord).
        await _revenirAuPaiementServeur(p, statut);
        _rejets.add('Paiement de ${p.montant} FCFA : déjà « $statut » sur le serveur, '
            'modification impossible depuis l\'appli.');
        return;
      }
      try {
        final r = await _api.post(_api.atelier('/payments/$remoteId/status/'), {'status': cible})
            as Map<String, dynamic>;
        statut = r['status'] as String;
        recu = r['receipt_number'] as String?;
      } on ApiException catch (e) {
        if (!e.estRefus) rethrow;
        await _revenirAuPaiementServeur(p, statut);
        _rejets.add('Paiement de ${p.montant} FCFA : ${e.message}');
        return;
      }
    }
    await _marquer(_db.paiements, p.id, p.updatedAt, {'statut_distant': statut, 'numero_recu': recu});
  }

  Future<void> _revenirAuPaiementServeur(Paiement p, String statutApi) =>
      (_db.update(_db.paiements)..where((t) => t.id.equals(p.id))).write(PaiementsCompanion(
        statut: Value(statutPaiementDepuisApi(statutApi)),
        statutDistant: Value(statutApi),
        deletedAt: Value(statutApi == 'cancelled' ? (p.deletedAt ?? DateTime.now()) : null),
        isSynced: const Value(true),
      ));

  // ─── 2. Récupération ──────────────────────────────────────────

  Future<void> _tirer({required bool mesuresCompletes}) async {
    await _tirerSalon();
    await _tirerMoi();
    await _tirerMembres();
    final nouveauxClients = await _tirerClients();
    await _tirerMesures(mesuresCompletes ? null : nouveauxClients);
    await _tirerModeles();
    await _tirerCommandes();
    await _tirerPaiements();
  }

  /// Rôle de l'utilisateur dans l'atelier courant (`my_role`), lu avec l'atelier.
  String? _monRole;

  /// La fiche atelier reflète le serveur, sauf modification locale pas encore envoyée.
  Future<void> _tirerSalon() async {
    final w = await _api.get('/api/v1/workshops/${_api.workshopId}/') as Map<String, dynamic>;
    _monRole = w['my_role'] as String?;
    final local = await (_db.select(_db.salons)..limit(1)).getSingleOrNull();
    if (local != null && !local.isSynced) return;
    final donnees = SalonsCompanion(
      nom: Value(_tronquer(w['name'] as String, 200)),
      email: Value(_vide(w['email'])),
      telephone: Value(_vide(w['phone'])),
      adresse: Value(_vide(w['address'])),
      isSynced: const Value(true),
    );
    if (local == null) {
      await _db.into(_db.salons).insert(donnees.copyWith(id: Value(w['id'] as String)));
    } else {
      await (_db.update(_db.salons)..where((s) => s.id.equals(local.id))).write(donnees);
    }
  }

  /// Profil connecté (GET /auth/me/), enregistré parmi les membres avec son rôle dans l'atelier.
  Future<void> _tirerMoi() async {
    final m = await _api.moi();
    final id = '${m['id']}';
    await _db.into(_db.users).insertOnConflictUpdate(UsersCompanion.insert(
          id: Value(id),
          username: m['username'] as String,
          email: Value(_vide(m['email'])),
          firstName: Value(_vide(m['first_name'])),
          lastName: Value(_vide(m['last_name'])),
          role: Value(_role(_monRole)),
          isSynced: const Value(true),
        ));
    await (await SharedPreferences.getInstance()).setString(_moiKey, id);
  }

  static RoleMembre _role(String? r) =>
      RoleMembre.values.firstWhere((x) => x.name == r, orElse: () => RoleMembre.member);

  /// Liste des membres (réservée aux responsables) : ignorée si l'utilisateur n'y a pas droit.
  Future<void> _tirerMembres() async {
    final List<Map<String, dynamic>> membres;
    try {
      membres = await _api.getAll(_api.atelier('/members/'));
    } on ApiException catch (e) {
      if (e.statusCode == 403) return;
      rethrow;
    }
    final moi = await moiId();
    for (final m in membres) {
      if ('${m['user_id']}' == moi) continue; // déjà complet via /auth/me/
      await _db.into(_db.users).insertOnConflictUpdate(UsersCompanion.insert(
            id: Value('${m['user_id']}'),
            username: m['username'] as String,
            firstName: Value(_vide(m['full_name'])),
            role: Value(_role(m['role'] as String?)),
            estActif: Value(m['is_active'] as bool? ?? true),
            isSynced: const Value(true),
          ));
    }
  }

  /// Renvoie les UUID serveur des clients nouvellement arrivés sur le téléphone.
  Future<Set<String>> _tirerClients() async {
    final actifs = await _api.getAll(_api.atelier('/clients/'));
    final inactifs = await _api.getAll(_api.atelier('/clients/'), query: {'is_active': 'false'});
    final nouveaux = <String>{};
    for (final r in [...actifs, ...inactifs]) {
      final rid = r['id'] as String;
      final local = await (_db.select(_db.clients)
            ..where((c) => c.remoteId.equals(rid) | c.id.equals(rid))
            ..limit(1))
          .getSingleOrNull();
      if (local != null && !local.isSynced) continue;
      final nom = nomDepuisApi(r['first_name'] as String? ?? '', r['last_name'] as String? ?? '');
      final actif = r['is_active'] as bool? ?? true;
      final donnees = ClientsCompanion(
        nom: Value(_tronquer(nom.nom, 100)),
        prenom: Value(nom.prenom),
        telephone: Value(_vide(r['phone'])),
        email: Value(_vide(r['email'])),
        adresse: Value(_vide(r['address'])),
        note: Value(_vide(r['notes'])),
        deletedAt: Value(actif ? null : (local?.deletedAt ?? DateTime.now())),
        remoteId: Value(rid),
        updatedAt: Value(_date(r['updated_at']) ?? DateTime.now()),
        isSynced: const Value(true),
      );
      if (local == null) {
        await _db.into(_db.clients).insert(donnees.copyWith(
              id: Value(rid),
              createdAt: Value(_date(r['created_at']) ?? DateTime.now()),
            ));
        nouveaux.add(rid);
      } else {
        await (_db.update(_db.clients)..where((c) => c.id.equals(local.id))).write(donnees);
      }
    }
    return nouveaux;
  }

  /// [seulement] = UUID serveur des clients à lire ; `null` = tous.
  Future<void> _tirerMesures(Set<String>? seulement) async {
    final clients =
        await (_db.select(_db.clients)..where((c) => c.remoteId.isNotNull())).get();
    for (final c in clients) {
      if (seulement != null && !seulement.contains(c.remoteId)) continue;
      final releves = await _api.getAll(_api.atelier('/clients/${c.remoteId}/measurements/'));
      for (final r in releves) {
        final rid = r['id'] as String;
        final existe = await (_db.select(_db.fichesMesures)
              ..where((f) => f.remoteId.equals(rid) | f.id.equals(rid))
              ..limit(1))
            .getSingleOrNull();
        if (existe != null) continue; // relevé immuable : rien à mettre à jour
        final prise = _date(r['taken_at']) ?? DateTime.now();
        final notes = (r['notes'] as String? ?? '').trim();
        final valeurs = Map<String, dynamic>.from(r['values'] as Map);
        await _db.transaction(() async {
          await _db.into(_db.fichesMesures).insert(FichesMesuresCompanion.insert(
                id: Value(rid),
                remoteId: Value(rid),
                clientId: c.id,
                libelle: notes.isEmpty
                    ? 'Relevé du ${DateFormat('dd/MM/yyyy').format(prise)}'
                    : _tronquer(notes.split('\n').first, 100),
                datePrise: Value(prise),
                isSynced: const Value(true),
              ));
          var ordre = 0;
          for (final e in valeurs.entries) {
            await _db.into(_db.mesures).insert(MesuresCompanion.insert(
                  ficheId: rid,
                  nomMesure: _tronquer(e.key, 100),
                  valeur: (e.value as num).toDouble(),
                  unite: Value(r['unit'] as String? ?? 'cm'),
                  ordre: Value(ordre++),
                  isSynced: const Value(true),
                ));
          }
        });
      }
    }
  }

  Future<void> _tirerModeles() async {
    final modeles = await _api.getAll(_api.catalogue('/models/'));
    for (final r in modeles) {
      final rid = r['id'] as String;
      final local = await (_db.select(_db.modeles)
            ..where((m) => m.remoteId.equals(rid) | m.id.equals(rid))
            ..limit(1))
          .getSingleOrNull();
      if (local != null && !local.isSynced) continue;
      final donnees = ModelesCompanion(
        nom: Value(_tronquer(r['name'] as String, 150)),
        description: Value(_vide(r['description'])),
        prixIndicatif: Value(montantDepuisApi(r['base_price'])),
        typeVetement: Value(_vide(r['category'])),
        imageUrl: Value(_vide(r['image_url'])),
        estPublie: Value(r['is_published'] as bool? ?? false),
        remoteId: Value(rid),
        updatedAt: Value(_date(r['updated_at']) ?? DateTime.now()),
        isSynced: const Value(true),
      );
      if (local == null) {
        await _db.into(_db.modeles).insert(donnees.copyWith(
              id: Value(rid),
              createdAt: Value(_date(r['created_at']) ?? DateTime.now()),
            ));
      } else {
        await (_db.update(_db.modeles)..where((m) => m.id.equals(local.id))).write(donnees);
      }
    }
  }

  Future<void> _tirerCommandes() async {
    final commandes = await _api.getAll(_api.atelier('/orders/'));
    for (final r in commandes) {
      final rid = r['id'] as String;
      final local = await (_db.select(_db.commandes)
            ..where((c) => c.remoteId.equals(rid) | c.id.equals(rid))
            ..limit(1))
          .getSingleOrNull();
      if (local != null && !local.isSynced) continue;
      final client = await (_db.select(_db.clients)
            ..where((c) => c.remoteId.equals(r['client'] as String))
            ..limit(1))
          .getSingleOrNull();
      if (client == null) continue;
      final modeleRid = r['catalog_model'] as String?;
      final modele = modeleRid == null
          ? null
          : await (_db.select(_db.modeles)
                ..where((m) => m.remoteId.equals(modeleRid))
                ..limit(1))
              .getSingleOrNull();
      final statutApi = r['status'] as String;
      final echeance = _date(r['due_date']);
      final creeLe = _date(r['created_at']) ?? DateTime.now();
      final donnees = CommandesCompanion(
        clientId: Value(client.id),
        modeleId: Value(modele?.id),
        description: Value(_vide(r['description'])),
        notes: Value(_vide(r['notes'])),
        prixConvenu: Value(montantDepuisApi(r['total_amount'])),
        statut: Value(statutCommandeDepuisApi(statutApi)),
        statutDistant: Value(statutApi),
        reference: Value(_vide(r['reference'])),
        dateEcheance: echeance == null ? const Value.absent() : Value(echeance),
        remoteId: Value(rid),
        updatedAt: Value(_date(r['updated_at']) ?? DateTime.now()),
        isSynced: const Value(true),
      );
      if (local == null) {
        await _db.into(_db.commandes).insert(donnees.copyWith(
              id: Value(rid),
              createdAt: Value(creeLe),
              dateCommande: Value(creeLe),
              dateEcheance: Value(echeance ?? creeLe),
            ));
      } else {
        await (_db.update(_db.commandes)..where((c) => c.id.equals(local.id))).write(donnees);
      }
    }
  }

  Future<void> _tirerPaiements() async {
    final paiements = await _api.getAll(_api.atelier('/payments/'));
    for (final r in paiements) {
      final rid = r['id'] as String;
      final local = await (_db.select(_db.paiements)
            ..where((p) => p.remoteId.equals(rid) | p.id.equals(rid))
            ..limit(1))
          .getSingleOrNull();
      if (local != null && !local.isSynced) continue;
      final commande = await (_db.select(_db.commandes)
            ..where((c) => c.remoteId.equals(r['order'] as String))
            ..limit(1))
          .getSingleOrNull();
      if (commande == null) continue;
      final statutApi = r['status'] as String;
      final donnees = PaiementsCompanion(
        commandeId: Value(commande.id),
        montant: Value(montantDepuisApi(r['amount'])),
        datePaiement: Value(_date(r['paid_at']) ?? _date(r['created_at']) ?? DateTime.now()),
        mode: Value(methodeDepuisApi(r['method'] as String?)),
        note: Value(_vide(r['notes'])),
        statut: Value(statutPaiementDepuisApi(statutApi)),
        statutDistant: Value(statutApi),
        reference: Value(_vide(r['transaction_reference'])),
        numeroRecu: Value(_vide(r['receipt_number'])),
        deletedAt: Value(statutApi == 'cancelled' ? (local?.deletedAt ?? DateTime.now()) : null),
        remoteId: Value(rid),
        updatedAt: Value(_date(r['updated_at']) ?? DateTime.now()),
        isSynced: const Value(true),
      );
      if (local == null) {
        await _db.into(_db.paiements).insert(donnees.copyWith(
              id: Value(rid),
              createdAt: Value(_date(r['created_at']) ?? DateTime.now()),
            ));
      } else {
        await (_db.update(_db.paiements)..where((p) => p.id.equals(local.id))).write(donnees);
      }
    }
  }

  // ─── Utilitaires ──────────────────────────────────────────────

  static String? _vide(dynamic v) => (v is String && v.trim().isNotEmpty) ? v : null;

  static DateTime? _date(dynamic v) =>
      v is String && v.isNotEmpty ? DateTime.tryParse(v)?.toLocal() : null;

  static String _tronquer(String texte, int max) =>
      texte.length <= max ? texte : texte.substring(0, max);
}
