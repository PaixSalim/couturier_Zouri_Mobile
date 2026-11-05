import 'dart:convert';

import 'package:dev_couturier/core/database/app_database.dart';
import 'package:dev_couturier/core/database/tables.dart';
import 'package:dev_couturier/core/sync/api_client.dart';
import 'package:dev_couturier/core/sync/sync_service.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Imitation minimale de l'API Dev Couturier (atelier `w1`).
class FauxServeur {
  final clients = <Map<String, dynamic>>[];
  final commandes = <Map<String, dynamic>>[];
  final paiements = <Map<String, dynamic>>[];
  final releves = <String, List<Map<String, dynamic>>>{};
  final modeles = <Map<String, dynamic>>[];
  final atelier = <String, dynamic>{
    'id': 'w1', 'name': 'Atelier Awa', 'phone': '', 'email': '', 'address': '', 'my_role': 'owner',
  };
  final requetes = <String>[];
  var renouvellements = 0;
  var expirerProchaineRequete = false;
  var _n = 0;

  static const w = '/api/v1/workshops/w1';

  http.Client get client => MockClient(_repondre);

  List<String> get ecritures => requetes.where((r) => !r.startsWith('GET')).toList();

  http.Response _json(Object corps, [int statut = 200]) => http.Response.bytes(
      utf8.encode(jsonEncode(corps)), statut,
      headers: {'content-type': 'application/json'});

  Map<String, dynamic> _page(List<Map<String, dynamic>> items) =>
      {'count': items.length, 'next': null, 'previous': null, 'results': items};

  String _id(String prefixe) => '$prefixe-${++_n}';

  Map<String, dynamic> _commande(String id) => commandes.firstWhere((c) => c['id'] == id);

  Future<http.Response> _repondre(http.Request r) async {
    final chemin = r.url.path;
    requetes.add('${r.method} $chemin');
    if (chemin == '/api/v1/auth/token/refresh/') {
      renouvellements++;
      return _json({'access': 'a2', 'refresh': 'r2'});
    }
    if (expirerProchaineRequete) {
      expirerProchaineRequete = false;
      return _json({'code': 'token_not_valid', 'detail': 'Jeton expiré.'}, 401);
    }
    final corps = r.body.isEmpty ? <String, dynamic>{} : jsonDecode(r.body) as Map<String, dynamic>;
    final maintenant = DateTime.utc(2026, 11, 4, 10).toIso8601String();

    switch ((r.method, chemin)) {
      case ('GET', '/api/v1/workshops/'):
        return _json(_page([{'id': 'w1', 'name': 'Atelier Awa', 'my_role': 'owner'}]));
      case ('GET', '$w/'):
        return _json(atelier);
      case ('PATCH', '$w/'):
        atelier.addAll(corps);
        return _json(atelier);
      case ('GET', '/api/v1/auth/me/'):
        return _json({'id': 7, 'username': 'awa', 'email': 'awa@exemple.bf', 'first_name': 'Awa', 'last_name': 'Ouédraogo'});
      case ('GET', '$w/members/'):
        return _json({'code': 'permission_denied', 'detail': 'Interdit.'}, 403);
      case ('GET', '$w/clients/'):
        final actifs = r.url.queryParameters['is_active'] != 'false';
        return _json(_page(clients.where((c) => c['is_active'] == actifs).toList()));
      case ('POST', '$w/clients/'):
        if ((corps['phone'] as String? ?? '').isEmpty) {
          return _json({
            'code': 'validation_error',
            'detail': 'Les données envoyées sont invalides.',
            'errors': {'phone': ['Ce champ ne peut être vide.']},
          }, 400);
        }
        final c = {...corps, 'id': _id('cli'), 'created_at': maintenant, 'updated_at': maintenant};
        clients.add(c);
        return _json(c, 201);
      case ('GET', '/api/v1/catalog/workshops/w1/models/'):
        return _json(_page(modeles));
      case ('POST', '/api/v1/catalog/workshops/w1/models/'):
        final m = {...corps, 'id': _id('mod'), 'created_at': maintenant, 'updated_at': maintenant};
        modeles.add(m);
        return _json(m, 201);
      case ('GET', '$w/orders/'):
        return _json(_page(commandes));
      case ('POST', '$w/orders/'):
        final deja = commandes.where((c) => c['client_request_id'] == corps['client_request_id']);
        if (deja.isNotEmpty) return _json(deja.first);
        final items = (corps['items'] as List).cast<Map<String, dynamic>>();
        final total = items.fold<int>(
            0, (s, i) => s + (i['quantity'] as int) * double.parse('${i['unit_price']}').round());
        final c = {
          ...corps,
          'id': _id('cmd'),
          'status': 'draft',
          'reference': 'CMD-2026-${commandes.length + 1}',
          'total_amount': '$total.00',
          'created_at': maintenant,
          'updated_at': maintenant,
        };
        commandes.add(c);
        return _json(c, 201);
      case ('GET', '$w/payments/'):
        return _json(_page(paiements));
      case ('POST', '$w/payments/'):
        final especes = corps['method'] == 'cash';
        final p = {
          ...corps,
          'id': _id('pay'),
          'status': especes ? 'confirmed' : 'pending',
          'receipt_number': especes ? 'REC-2026-${paiements.length + 1}' : null,
          'paid_at': especes ? maintenant : null,
          'created_at': maintenant,
          'updated_at': maintenant,
        };
        paiements.add(p);
        return _json(p, 201);
    }

    final statutCommande = RegExp(r'^/api/v1/workshops/w1/orders/([^/]+)/status/$').firstMatch(chemin);
    if (statutCommande != null && r.method == 'POST') {
      final c = _commande(statutCommande.group(1)!);
      c['status'] = corps['status'];
      return _json(c);
    }
    final commande = RegExp(r'^/api/v1/workshops/w1/orders/([^/]+)/$').firstMatch(chemin);
    if (commande != null && r.method == 'PATCH') {
      final c = _commande(commande.group(1)!)..addAll(corps);
      return _json(c);
    }
    final mesures = RegExp(r'^/api/v1/workshops/w1/clients/([^/]+)/measurements/$').firstMatch(chemin);
    if (mesures != null) {
      final liste = releves.putIfAbsent(mesures.group(1)!, () => []);
      if (r.method == 'GET') return _json(_page(liste));
      final releve = {...corps, 'id': _id('rel'), 'taken_at': maintenant};
      liste.add(releve);
      return _json(releve, 201);
    }
    return _json({'code': 'not_found', 'detail': 'Introuvable : ${r.method} $chemin'}, 404);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late FauxServeur serveur;
  late ApiClient api;
  late SyncService sync;

  setUp(() async {
    SharedPreferences.setMockInitialValues({'api_access': 'a1', 'api_refresh': 'r1'});
    db = AppDatabase.forTesting(NativeDatabase.memory());
    serveur = FauxServeur();
    api = ApiClient('http://test', httpClient: serveur.client);
    await api.loadToken();
    sync = SyncService(db, api);
  });

  tearDown(() => db.close());

  Future<String> creerClient({String? telephone = '70123456'}) async => (await db
          .into(db.clients)
          .insertReturning(ClientsCompanion.insert(
            nom: 'Ouédraogo',
            prenom: const Value('Awa'),
            telephone: Value(telephone),
          )))
      .id;

  Future<String> creerCommande(String clientId) async => (await db
          .into(db.commandes)
          .insertReturning(CommandesCompanion.insert(
            clientId: clientId,
            description: const Value('Boubou bazin'),
            prixConvenu: 30000,
            dateEcheance: DateTime.now().add(const Duration(days: 7)),
          )))
      .id;

  test('envoie client, mesures, commande et paiement en espèces, sans doublon au second passage',
      () async {
    final clientId = await creerClient();
    final fiche = await db.into(db.fichesMesures).insertReturning(
        FichesMesuresCompanion.insert(clientId: clientId, libelle: 'Boubou homme'));
    await db.into(db.mesures).insert(
        MesuresCompanion.insert(ficheId: fiche.id, nomMesure: 'Épaule', valeur: 46));
    final commandeId = await creerCommande(clientId);
    await db.into(db.paiements).insert(PaiementsCompanion.insert(commandeId: commandeId, montant: 10000));

    await sync.executeSync();

    expect(sync.lastSyncError, isNull);
    expect(serveur.clients.single['first_name'], 'Awa');
    expect(serveur.releves.values.single.single['values'], {'Épaule': 46.0});
    final commande = serveur.commandes.single;
    expect(commande['client_request_id'], commandeId);
    expect(commande['status'], 'confirmed', reason: 'en attente côté appli = confirmée côté API');
    expect(serveur.paiements.single['method'], 'cash');
    expect(serveur.paiements.single['notes'], '');

    final local = await (db.select(db.commandes)..where((c) => c.id.equals(commandeId))).getSingle();
    expect(local.remoteId, commande['id']);
    expect(local.reference, 'CMD-2026-1');
    expect(local.statutDistant, 'confirmed');
    expect(local.isSynced, isTrue);
    final paiement = await db.select(db.paiements).getSingle();
    expect(paiement.numeroRecu, 'REC-2026-1');
    expect(await sync.pendingCount(), 0);

    serveur.requetes.clear();
    await sync.executeSync();
    expect(serveur.ecritures, isEmpty, reason: 'rien de neuf : aucune écriture');
    expect(await db.select(db.commandes).get(), hasLength(1), reason: "l'écho du serveur ne duplique rien");
  });

  test('un client refusé par le serveur est signalé et bloque seulement ses commandes', () async {
    final sansTelephone = await creerClient(telephone: null);
    await creerCommande(sansTelephone);
    await creerClient();

    await sync.executeSync();

    expect(sync.lastSyncError, contains('1 élément(s) refusé(s)'));
    expect(sync.lastSyncError, contains('phone'));
    expect(serveur.clients, hasLength(1));
    expect(serveur.commandes, isEmpty);
    expect(await sync.pendingCount(), 2, reason: 'le client refusé et sa commande restent à envoyer');
  });

  test('un jeton expiré est renouvelé une fois puis la requête est rejouée', () async {
    serveur.expirerProchaineRequete = true;

    await sync.executeSync();

    expect(sync.lastSyncError, isNull);
    expect(serveur.renouvellements, 1);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('api_refresh'), 'r2', reason: 'rotation du refresh token');
  });

  test('modèle du catalogue, notes de commande et fiche atelier partent vers l’API', () async {
    final modele = await db.into(db.modeles).insertReturning(ModelesCompanion.insert(
          nom: 'Boubou brodé',
          prixIndicatif: const Value(25000),
          typeVetement: const Value('Homme'),
          imageUrl: const Value('https://exemple.bf/boubou.jpg'),
          estPublie: const Value(true),
        ));
    final commande = await db.into(db.commandes).insertReturning(CommandesCompanion.insert(
          clientId: await creerClient(),
          modeleId: Value(modele.id),
          notes: const Value('Broderie dorée'),
          prixConvenu: 25000,
          dateEcheance: DateTime.now().add(const Duration(days: 10)),
        ));
    await sync.executeSync(); // crée la fiche atelier depuis le serveur
    final salon = await db.select(db.salons).getSingle();
    await (db.update(db.salons)..where((s) => s.id.equals(salon.id))).write(SalonsCompanion(
      telephone: const Value('+22670111111'),
      updatedAt: Value(DateTime.now().add(const Duration(seconds: 2))),
      isSynced: const Value(false),
    ));

    await sync.executeSync();

    expect(sync.lastSyncError, isNull);
    final m = serveur.modeles.single;
    expect((m['category'], m['base_price'], m['image_url'], m['is_published']),
        ('Homme', '25000', 'https://exemple.bf/boubou.jpg', true));
    final c = serveur.commandes.single;
    expect(c['catalog_model'], m['id']);
    expect(c['notes'], 'Broderie dorée');
    expect(c['client_request_id'], commande.id);
    expect(serveur.atelier['phone'], '+22670111111');
    expect(await sync.pendingCount(), 0);
  });

  test('les statuts avancent étape par étape jusqu’à la livraison', () async {
    final commandeId = await creerCommande(await creerClient());
    await sync.executeSync();
    serveur.requetes.clear();

    await (db.update(db.commandes)..where((c) => c.id.equals(commandeId))).write(CommandesCompanion(
      statut: const Value(StatutCommande.livree),
      updatedAt: Value(DateTime.now().add(const Duration(seconds: 2))),
      isSynced: const Value(false),
    ));
    await sync.executeSync();

    expect(
      serveur.ecritures.where((r) => r.endsWith('/status/')).length,
      3,
      reason: 'confirmed → in_progress → ready → delivered',
    );
    expect(serveur.commandes.single['status'], 'delivered');
  });

  test('récupère ce qui a été saisi sur le tableau de bord', () async {
    final maintenant = DateTime.utc(2026, 11, 1).toIso8601String();
    serveur.clients.add({
      'id': 'cli-web', 'first_name': 'Issa', 'last_name': 'Kaboré', 'phone': '+22670000000',
      'email': 'issa@exemple.bf', 'address': 'Ouaga 2000',
      'notes': '', 'is_active': true, 'created_at': maintenant, 'updated_at': maintenant,
    });
    serveur.modeles.add({
      'id': 'mod-web', 'name': 'Complet veste', 'category': 'Homme', 'description': '',
      'base_price': '45000.00', 'image_url': '', 'is_published': false,
      'created_at': maintenant, 'updated_at': maintenant,
    });
    serveur.commandes.add({
      'id': 'cmd-web', 'client': 'cli-web', 'catalog_model': 'mod-web', 'notes': 'Doublure satin',
      'description': 'Complet', 'status': 'in_progress',
      'reference': 'CMD-2026-0042', 'total_amount': '45000.00', 'due_date': '2026-11-20',
      'created_at': maintenant, 'updated_at': maintenant,
    });
    serveur.paiements.add({
      'id': 'pay-web', 'order': 'cmd-web', 'amount': '20000.00', 'method': 'orange_money',
      'status': 'confirmed', 'notes': 'Avance', 'transaction_reference': 'OM123',
      'receipt_number': 'REC-2026-00007', 'paid_at': maintenant, 'created_at': maintenant,
      'updated_at': maintenant,
    });

    await sync.executeSync();

    final client = await db.select(db.clients).getSingle();
    expect((client.nom, client.prenom), ('Kaboré', 'Issa'));
    expect((client.email, client.adresse), ('issa@exemple.bf', 'Ouaga 2000'));
    final modele = await db.select(db.modeles).getSingle();
    expect((modele.prixIndicatif, modele.estPublie, modele.imageUrl), (45000, false, null));
    final commande = await db.select(db.commandes).getSingle();
    expect(commande.modeleId, modele.id);
    expect(commande.notes, 'Doublure satin');
    expect(commande.statut, StatutCommande.enCours);
    expect(commande.prixConvenu, 45000);
    expect(commande.reference, 'CMD-2026-0042');
    final paiement = await db.select(db.paiements).getSingle();
    expect(paiement.mode, ModePaiement.orangeMoney);
    expect(paiement.note, 'Avance');
    expect(paiement.statut, StatutPaiement.reussi);
    expect(await sync.pendingCount(), 0);
    expect(await db.select(db.salons).getSingle().then((s) => s.nom), 'Atelier Awa');
    final moi = await (db.select(db.users)..where((u) => u.id.equals('7'))).getSingle();
    expect((await sync.moiId(), moi.firstName, moi.role), ('7', 'Awa', RoleMembre.owner));
  });
}
