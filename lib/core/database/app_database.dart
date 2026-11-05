import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// Base locale : uniquement les ressources que l'API Dev Couturier connaît
/// (atelier, membres, clients, relevés de mesures, catalogue, commandes, paiements).
@DriftDatabase(
  tables: [
    Salons,
    Users,
    Clients,
    FichesMesures,
    Mesures,
    Modeles,
    Commandes,
    Paiements,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 3) await m.createTable(users);
          if (from < 4) await m.createTable(salons);
          if (from < 6) {
            await m.addColumn(paiements, paiements.statut);
            await m.addColumn(paiements, paiements.reference);
          }
          if (from < 7) {
            // Branchement sur l'API Dev Couturier : lien vers les UUID serveur.
            await m.addColumn(clients, clients.remoteId);
            await m.addColumn(fichesMesures, fichesMesures.remoteId);
            await m.addColumn(modeles, modeles.remoteId);
            await m.addColumn(commandes, commandes.remoteId);
            await m.addColumn(commandes, commandes.statutDistant);
            await m.addColumn(commandes, commandes.reference);
            await m.addColumn(paiements, paiements.remoteId);
            await m.addColumn(paiements, paiements.statutDistant);
            await m.addColumn(paiements, paiements.numeroRecu);
            // Les données envoyées à l'ancien serveur doivent repartir vers le nouveau.
            for (final table in ['clients', 'fiches_mesures', 'mesures', 'modeles', 'commandes', 'paiements']) {
              await customStatement('UPDATE $table SET is_synced = 0');
            }
          }
          if (from < 8) {
            // Retrait de ce que l'API ne gère pas : tâches, stock, dépenses,
            // modèles de mesures, photos, sexe, tissu, assignation, type de paiement…
            for (final table in [
              'taches',
              'stock_items',
              'depenses',
              'template_champs',
              'templates_mesures',
              'modele_photos',
            ]) {
              await customStatement('DROP TABLE IF EXISTS $table');
            }
            await customStatement(
                "UPDATE paiements SET mode = 'autre' WHERE mode IN ('wave', 'mobileMoney')");
            await customStatement("UPDATE users SET role = CASE role "
                "WHEN 'gerant' THEN 'manager' WHEN 'employe' THEN 'tailor' ELSE role END");
            await m.alterTable(TableMigration(salons));
            await m.alterTable(TableMigration(users));
            await m.alterTable(TableMigration(clients, newColumns: [clients.email, clients.adresse]));
            await m.alterTable(TableMigration(modeles, newColumns: [modeles.imageUrl, modeles.estPublie]));
            await m.alterTable(TableMigration(commandes, newColumns: [commandes.notes]));
            await m.alterTable(TableMigration(paiements));
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Sur le web, SQLite tourne en WebAssembly (web/sqlite3.wasm + web/drift_worker.js,
  /// aux versions de sqlite3 et drift du pubspec.lock) et stocke dans le navigateur.
  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'dev_couturier_db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  Future<void> clearAllData() async {
    await customStatement('PRAGMA foreign_keys = OFF');
    await batch((b) {
      b.deleteAll(paiements);
      b.deleteAll(commandes);
      b.deleteAll(modeles);
      b.deleteAll(mesures);
      b.deleteAll(fichesMesures);
      b.deleteAll(clients);
      b.deleteAll(users);
      b.deleteAll(salons);
    });
    await customStatement('PRAGMA foreign_keys = ON');
  }
}
