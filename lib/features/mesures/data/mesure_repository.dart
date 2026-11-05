import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

/// Une mesure saisie par le couturier avant enregistrement.
class MesureSaisie {
  MesureSaisie({required this.nom, required this.valeur, this.unite = 'cm'});

  final String nom;
  final double valeur;
  final String unite;
}

class MesureRepository {
  MesureRepository(this._db);

  final AppDatabase _db;

  /// Noms de mesures déjà saisis dans l'atelier, du plus utilisé au moins utilisé
  /// (suggestions à la prise de mesures ; l'API accepte des noms libres).
  Future<List<String>> nomsDejaUtilises() async {
    final n = _db.mesures.nomMesure.count();
    final rows = await (_db.selectOnly(_db.mesures)
          ..addColumns([_db.mesures.nomMesure, n])
          ..where(_db.mesures.deletedAt.isNull())
          ..groupBy([_db.mesures.nomMesure])
          ..orderBy([OrderingTerm.desc(n)]))
        .get();
    return [for (final r in rows) r.read(_db.mesures.nomMesure)!];
  }

  // ----------------------------------------------------------
  // FICHES DE MESURES
  // ----------------------------------------------------------

  Stream<List<FichesMesure>> watchFichesDuClient(String clientId) {
    return (_db.select(_db.fichesMesures)
          ..where((f) => f.clientId.equals(clientId) & f.deletedAt.isNull())
          ..orderBy([(f) => OrderingTerm.desc(f.datePrise)]))
        .watch();
  }

  Stream<List<Mesure>> watchMesuresDeFiche(String ficheId) {
    return (_db.select(_db.mesures)
          ..where((m) => m.ficheId.equals(ficheId) & m.deletedAt.isNull())
          ..orderBy([(m) => OrderingTerm.asc(m.ordre)]))
        .watch();
  }

  /// Crée une fiche complète (fiche + toutes ses mesures) en une
  /// transaction. Retourne la fiche créée.
  Future<FichesMesure> creerFiche({
    required String clientId,
    required String libelle,
    required List<MesureSaisie> mesures,
  }) {
    return _db.transaction(() async {
      final fiche = await _db.into(_db.fichesMesures).insertReturning(
            FichesMesuresCompanion.insert(
              clientId: clientId,
              libelle: libelle,
            ),
          );
      for (var i = 0; i < mesures.length; i++) {
        await _db.into(_db.mesures).insert(
              MesuresCompanion.insert(
                ficheId: fiche.id,
                nomMesure: mesures[i].nom,
                valeur: mesures[i].valeur,
                unite: Value(mesures[i].unite),
                ordre: Value(i),
              ),
            );
      }
      return fiche;
    });
  }
}
