import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';

/// Repository des commandes.
///
/// Règles :
/// 1. Toute modification passe par ici, jamais par la BD directement
///    depuis l'UI. En V2, c'est ICI qu'on branchera la sync.
/// 2. On met à jour `updatedAt` à chaque écriture et on remet
///    `isSynced` à false.
/// 3. Suppression = logique (deletedAt), jamais de vrai DELETE.
/// 4. Les lectures filtrent toujours `deletedAt IS NULL`.
class CommandeRepository {
  CommandeRepository(this._db);

  final AppDatabase _db;

  static const _statutsTermines = [
    StatutCommande.livree,
    StatutCommande.annulee,
  ];

  // ----------------------------------------------------------
  // LECTURES
  // ----------------------------------------------------------

  /// Commandes actives + leur client, triées par échéance.
  Stream<List<(Commande, Client)>> watchAvecClient({StatutCommande? statut}) {
    final query = _db.select(_db.commandes).join([
      innerJoin(_db.clients, _db.clients.id.equalsExp(_db.commandes.clientId)),
    ])
      ..where(_db.commandes.deletedAt.isNull())
      ..orderBy([OrderingTerm.asc(_db.commandes.dateEcheance)]);

    if (statut != null) {
      query.where(_db.commandes.statut.equalsValue(statut));
    }

    return query.watch().map((rows) => rows
        .map((r) => (r.readTable(_db.commandes), r.readTable(_db.clients)))
        .toList());
  }

  /// Commandes en retard (échéance dépassée, non livrées/annulées).
  Stream<List<Commande>> watchEnRetard() {
    return (_db.select(_db.commandes)
          ..where((c) =>
              c.deletedAt.isNull() &
              c.dateEcheance.isSmallerThanValue(DateTime.now()) &
              c.statut.isNotInValues(_statutsTermines))
          ..orderBy([(c) => OrderingTerm.asc(c.dateEcheance)]))
        .watch();
  }

  /// Échéances dans les [jours] prochains jours (dashboard).
  Stream<List<Commande>> watchEcheancesProches({int jours = 7}) {
    final maintenant = DateTime.now();
    final limite = maintenant.add(Duration(days: jours));
    return (_db.select(_db.commandes)
          ..where((c) =>
              c.deletedAt.isNull() &
              c.dateEcheance.isBetweenValues(maintenant, limite) &
              c.statut.isNotInValues(_statutsTermines))
          ..orderBy([(c) => OrderingTerm.asc(c.dateEcheance)]))
        .watch();
  }

  Future<Commande> getById(String id) {
    return (_db.select(_db.commandes)..where((c) => c.id.equals(id)))
        .getSingle();
  }

  /// Solde restant = prixConvenu - somme des paiements.
  Future<int> soldeRestant(String commandeId) async {
    final commande = await getById(commandeId);
    final somme = _db.paiements.montant.sum();
    final row = await (_db.selectOnly(_db.paiements)
          ..addColumns([somme])
          ..where(_db.paiements.commandeId.equals(commandeId) &
              _db.paiements.deletedAt.isNull() &
              _db.paiements.statut.equals(StatutPaiement.reussi)))
        .getSingle();
    return commande.prixConvenu - (row.read(somme) ?? 0);
  }

  /// Total des soldes dus sur toutes les commandes actives
  /// (seuls les paiements encaissés de ces commandes sont déduits).
  Future<int> soldesDus() async {
    final actives = await (_db.select(_db.commandes)
          ..where((c) =>
              c.deletedAt.isNull() & c.statut.isNotInValues(_statutsTermines)))
        .get();
    if (actives.isEmpty) return 0;

    final sommePaiements = _db.paiements.montant.sum();
    final rowP = await (_db.selectOnly(_db.paiements)
          ..addColumns([sommePaiements])
          ..where(_db.paiements.deletedAt.isNull() &
              _db.paiements.statut.equals(StatutPaiement.reussi) &
              _db.paiements.commandeId.isIn(actives.map((c) => c.id))))
        .getSingle();

    final totalPrix = actives.fold<int>(0, (s, c) => s + c.prixConvenu);
    final reste = totalPrix - (rowP.read(sommePaiements) ?? 0);
    return reste < 0 ? 0 : reste.toInt();
  }

  // ----------------------------------------------------------
  // ÉCRITURES
  // ----------------------------------------------------------

  Future<String> creer(CommandesCompanion commande) async {
    final row = await _db.into(_db.commandes).insertReturning(commande);
    return row.id;
  }

  Future<void> changerStatut(String id, StatutCommande statut) {
    return (_db.update(_db.commandes)..where((c) => c.id.equals(id))).write(
      CommandesCompanion(
        statut: Value(statut),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }

  Future<void> supprimer(String id) {
    return (_db.update(_db.commandes)..where((c) => c.id.equals(id))).write(
      CommandesCompanion(
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }
}
