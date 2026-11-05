import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

class ModeleRepository {
  ModeleRepository(this._db);

  final AppDatabase _db;

  Stream<List<Modele>> watchTous() {
    return (_db.select(_db.modeles)
          ..where((m) => m.deletedAt.isNull())
          ..orderBy([(m) => OrderingTerm.asc(m.nom)]))
        .watch();
  }

  Future<Modele> creer(ModelesCompanion modele) =>
      _db.into(_db.modeles).insertReturning(modele);

  Future<void> modifier(String id, ModelesCompanion modifications) {
    return (_db.update(_db.modeles)..where((m) => m.id.equals(id))).write(
      modifications.copyWith(
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }

  Future<void> supprimer(String id) {
    return (_db.update(_db.modeles)..where((m) => m.id.equals(id))).write(
      ModelesCompanion(
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }
}
