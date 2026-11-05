import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';

class PaiementRepository {
  PaiementRepository(this._db);

  final AppDatabase _db;

  /// Paiements réellement encaissés (hors attentes et échecs).
  Expression<bool> _encaisse($PaiementsTable p) =>
      p.deletedAt.isNull() & p.statut.equals(StatutPaiement.reussi);

  Stream<List<Paiement>> watchDeCommande(String commandeId) {
    return (_db.select(_db.paiements)
          ..where((p) => p.commandeId.equals(commandeId) & p.deletedAt.isNull())
          ..orderBy([(p) => OrderingTerm.desc(p.datePaiement)]))
        .watch();
  }

  Future<Paiement> ajouter(PaiementsCompanion paiement) {
    return _db.into(_db.paiements).insertReturning(paiement);
  }

  /// Confirme (`reussi`) ou déclare échoué un paiement en attente.
  /// La date d'encaissement devient celle de la confirmation.
  Future<void> changerStatut(String id, String statut) {
    final maintenant = DateTime.now();
    return (_db.update(_db.paiements)..where((p) => p.id.equals(id))).write(
      PaiementsCompanion(
        statut: Value(statut),
        datePaiement: statut == StatutPaiement.reussi ? Value(maintenant) : const Value.absent(),
        updatedAt: Value(maintenant),
        isSynced: const Value(false),
      ),
    );
  }

  Future<int> totalPaye(String commandeId) async {
    final somme = _db.paiements.montant.sum();
    final row = await (_db.selectOnly(_db.paiements)
          ..addColumns([somme])
          ..where(_db.paiements.commandeId.equals(commandeId) &
              _encaisse(_db.paiements)))
        .getSingle();
    return row.read(somme) ?? 0;
  }

  Future<void> supprimer(String id) {
    return (_db.update(_db.paiements)..where((p) => p.id.equals(id))).write(
      PaiementsCompanion(
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }

  /// Somme des paiements encaissés dans le mois courant.
  Future<int> revenusduMois() async {
    final now = DateTime.now();
    final debutMois = DateTime(now.year, now.month);
    final finMois = DateTime(now.year, now.month + 1);
    final somme = _db.paiements.montant.sum();
    final row = await (_db.selectOnly(_db.paiements)
          ..addColumns([somme])
          ..where(_encaisse(_db.paiements) &
              _db.paiements.datePaiement
                  .isBetweenValues(debutMois, finMois)))
        .getSingle();
    return row.read(somme) ?? 0;
  }
}
