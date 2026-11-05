import 'package:dev_couturier/core/database/app_database.dart';
import 'package:dev_couturier/core/database/tables.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// Base telle qu'elle était en version 7 (avant le retrait des fonctions absentes de l'API).
const _schemaV7 = [
  '''CREATE TABLE salons (id TEXT NOT NULL PRIMARY KEY, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
     deleted_at INTEGER, is_synced INTEGER NOT NULL DEFAULT 0, nom TEXT NOT NULL, email TEXT, telephone TEXT,
     adresse TEXT, devise TEXT NOT NULL DEFAULT 'FCFA', logo_path TEXT)''',
  '''CREATE TABLE users (id TEXT NOT NULL PRIMARY KEY, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
     deleted_at INTEGER, is_synced INTEGER NOT NULL DEFAULT 0, username TEXT NOT NULL, email TEXT, first_name TEXT,
     last_name TEXT, telephone TEXT, role TEXT NOT NULL DEFAULT 'employe', est_actif INTEGER NOT NULL DEFAULT 1)''',
  '''CREATE TABLE clients (id TEXT NOT NULL PRIMARY KEY, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
     deleted_at INTEGER, is_synced INTEGER NOT NULL DEFAULT 0, nom TEXT NOT NULL, prenom TEXT, telephone TEXT,
     sexe TEXT, photo_path TEXT, remote_id TEXT, note TEXT)''',
  '''CREATE TABLE templates_mesures (id TEXT NOT NULL PRIMARY KEY, libelle TEXT NOT NULL)''',
  '''CREATE TABLE template_champs (id TEXT NOT NULL PRIMARY KEY, template_id TEXT NOT NULL)''',
  '''CREATE TABLE fiches_mesures (id TEXT NOT NULL PRIMARY KEY, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
     deleted_at INTEGER, is_synced INTEGER NOT NULL DEFAULT 0, client_id TEXT NOT NULL REFERENCES clients (id),
     libelle TEXT NOT NULL, remote_id TEXT, date_prise INTEGER NOT NULL)''',
  '''CREATE TABLE mesures (id TEXT NOT NULL PRIMARY KEY, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
     deleted_at INTEGER, is_synced INTEGER NOT NULL DEFAULT 0, fiche_id TEXT NOT NULL REFERENCES fiches_mesures (id),
     nom_mesure TEXT NOT NULL, valeur REAL NOT NULL, unite TEXT NOT NULL DEFAULT 'cm', ordre INTEGER NOT NULL DEFAULT 0)''',
  '''CREATE TABLE modeles (id TEXT NOT NULL PRIMARY KEY, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
     deleted_at INTEGER, is_synced INTEGER NOT NULL DEFAULT 0, nom TEXT NOT NULL, description TEXT,
     prix_indicatif INTEGER, remote_id TEXT, type_vetement TEXT)''',
  '''CREATE TABLE modele_photos (id TEXT NOT NULL PRIMARY KEY, modele_id TEXT NOT NULL, path TEXT NOT NULL)''',
  '''CREATE TABLE commandes (id TEXT NOT NULL PRIMARY KEY, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
     deleted_at INTEGER, is_synced INTEGER NOT NULL DEFAULT 0, client_id TEXT NOT NULL REFERENCES clients (id),
     modele_id TEXT REFERENCES modeles (id), fiche_mesures_id TEXT REFERENCES fiches_mesures (id), description TEXT,
     prix_convenu INTEGER NOT NULL, tissu_fourni_par TEXT NOT NULL DEFAULT 'client', metrage_tissu REAL,
     date_commande INTEGER NOT NULL, date_echeance INTEGER NOT NULL, statut TEXT NOT NULL DEFAULT 'enAttente',
     photo_reference_path TEXT, remote_id TEXT, statut_distant TEXT, reference TEXT, assignee_a TEXT)''',
  '''CREATE TABLE taches (id TEXT NOT NULL PRIMARY KEY, titre TEXT NOT NULL)''',
  '''CREATE TABLE paiements (id TEXT NOT NULL PRIMARY KEY, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
     deleted_at INTEGER, is_synced INTEGER NOT NULL DEFAULT 0, commande_id TEXT NOT NULL REFERENCES commandes (id),
     montant INTEGER NOT NULL, date_paiement INTEGER NOT NULL, type TEXT NOT NULL DEFAULT 'tranche',
     mode TEXT NOT NULL DEFAULT 'especes', note TEXT, statut TEXT NOT NULL DEFAULT 'reussi', reference TEXT,
     remote_id TEXT, statut_distant TEXT, numero_recu TEXT, telephone_payeur TEXT)''',
  '''CREATE TABLE depenses (id TEXT NOT NULL PRIMARY KEY, libelle TEXT NOT NULL)''',
  '''CREATE TABLE stock_items (id TEXT NOT NULL PRIMARY KEY, nom TEXT NOT NULL)''',
  // Données d'un atelier en service.
  "INSERT INTO salons VALUES ('s1', 0, 0, NULL, 1, 'Atelier Awa', NULL, NULL, NULL, 'FCFA', '/logo.png')",
  "INSERT INTO users VALUES ('u1', 0, 0, NULL, 1, 'awa', NULL, 'Awa', NULL, NULL, 'gerant', 1)",
  "INSERT INTO clients VALUES ('c1', 0, 0, NULL, 1, 'Kaboré', 'Issa', '70000000', 'homme', '/p.jpg', 'cli-1', 'fidèle')",
  "INSERT INTO modeles VALUES ('m1', 0, 0, NULL, 1, 'Boubou', NULL, 25000, 'mod-1', 'Homme')",
  "INSERT INTO commandes VALUES ('k1', 0, 0, NULL, 1, 'c1', 'm1', NULL, 'Boubou', 25000, 'atelier', 3.5, "
      "0, 1800000000, 'enCours', NULL, 'cmd-1', 'in_progress', 'CMD-2026-0001', 'u1')",
  "INSERT INTO paiements VALUES ('p1', 0, 0, NULL, 1, 'k1', 10000, 0, 'avance', 'wave', NULL, 'reussi', NULL, "
      "'pay-1', 'confirmed', 'REC-1', '70000000')",
  'PRAGMA user_version = 7',
];

void main() {
  test('la migration v7 → v8 garde les données et retire ce que l’API ne connaît pas', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory(setup: (raw) {
      for (final sql in _schemaV7) {
        raw.execute(sql);
      }
    }));
    addTearDown(db.close);

    final client = await db.select(db.clients).getSingle();
    expect((client.nom, client.note, client.remoteId, client.email), ('Kaboré', 'fidèle', 'cli-1', null));
    final commande = await db.select(db.commandes).getSingle();
    expect((commande.modeleId, commande.statut, commande.reference, commande.notes),
        ('m1', StatutCommande.enCours, 'CMD-2026-0001', null));
    final paiement = await db.select(db.paiements).getSingle();
    expect((paiement.mode, paiement.numeroRecu), (ModePaiement.autre, 'REC-1'), reason: 'Wave → Autre');
    expect((await db.select(db.users).getSingle()).role, RoleMembre.manager);
    expect((await db.select(db.modeles).getSingle()).estPublie, isFalse);

    final tables = await db
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
        .map((r) => r.read<String>('name'))
        .get();
    for (final retiree in ['taches', 'depenses', 'stock_items', 'templates_mesures', 'template_champs', 'modele_photos']) {
      expect(tables, isNot(contains(retiree)));
    }
    final colonnesCommandes = await db
        .customSelect('PRAGMA table_info(commandes)')
        .map((r) => r.read<String>('name'))
        .get();
    expect(colonnesCommandes, isNot(contains('tissu_fourni_par')));
    expect(colonnesCommandes, isNot(contains('assignee_a')));
  });
}
