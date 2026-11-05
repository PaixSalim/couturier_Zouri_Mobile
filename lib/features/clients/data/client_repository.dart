import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

class ClientRepository {
  ClientRepository(this._db);

  final AppDatabase _db;

  /// Liste des clients actifs, avec recherche sur nom/prénom/téléphone.
  Stream<List<Client>> watchTous({String recherche = ''}) {
    final query = _db.select(_db.clients)
      ..where((c) => c.deletedAt.isNull())
      ..orderBy([(c) => OrderingTerm.asc(c.nom)]);

    if (recherche.trim().isNotEmpty) {
      final r = recherche.trim().toLowerCase();
      query.where((c) =>
          c.nom.lower().contains(r) |
          c.prenom.lower().contains(r) |
          c.telephone.contains(r));
    }
    return query.watch();
  }

  Future<Client> getById(String id) {
    return (_db.select(_db.clients)..where((c) => c.id.equals(id)))
        .getSingle();
  }

  Future<Client> creer(ClientsCompanion client) {
    return _db.into(_db.clients).insertReturning(client);
  }

  Future<void> modifier(String id, ClientsCompanion modifications) {
    return (_db.update(_db.clients)..where((c) => c.id.equals(id))).write(
      modifications.copyWith(
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }

  Future<void> supprimer(String id) {
    return (_db.update(_db.clients)..where((c) => c.id.equals(id))).write(
      ClientsCompanion(
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }

  Stream<List<Commande>> watchCommandesDuClient(String clientId) {
    return (_db.select(_db.commandes)
          ..where((c) => c.clientId.equals(clientId) & c.deletedAt.isNull())
          ..orderBy([(c) => OrderingTerm.desc(c.dateEcheance)]))
        .watch();
  }
}
