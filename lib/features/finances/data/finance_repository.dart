import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';

/// Un encaissement du journal de caisse.
class MouvementCaisse {
  const MouvementCaisse({
    required this.id,
    required this.date,
    required this.montant,
    required this.titre,
    required this.detail,
    required this.mode,
    this.reference,
    this.commandeId,
  });

  final String id;
  final DateTime date;

  final int montant;
  final String titre;
  final String detail;

  /// Code API du mode (`cash`, `orange_money`…).
  final String mode;
  final String? reference;
  final String? commandeId;
}

class ResumeFinances {
  const ResumeFinances({
    required this.encaisse,
    required this.parMode,
    required this.journal,
  });

  final int encaisse;

  /// Montant encaissé par code de mode, trié du plus gros au plus petit.
  final List<(String, int)> parMode;
  final List<MouvementCaisse> journal;
}

/// Commande avec un solde restant, proposée au bouton « Encaisser ».
typedef CommandeAEncaisser = ({Commande commande, Client client, int solde});

class FinanceRepository {
  FinanceRepository(this._db);

  final AppDatabase _db;

  static (DateTime, DateTime) bornesMois(DateTime mois) =>
      (DateTime(mois.year, mois.month), DateTime(mois.year, mois.month + 1));

  /// Paiements encaissés du mois, avec la commande et le client.
  Stream<List<(Paiement, Commande, Client)>> watchEncaissementsDuMois(
      DateTime mois) {
    final (debut, fin) = bornesMois(mois);
    final p = _db.paiements;
    final query = _db.select(p).join([
      innerJoin(_db.commandes, _db.commandes.id.equalsExp(p.commandeId)),
      innerJoin(_db.clients, _db.clients.id.equalsExp(_db.commandes.clientId)),
    ])
      ..where(p.deletedAt.isNull() &
          p.statut.equals(StatutPaiement.reussi) &
          p.datePaiement.isBiggerOrEqualValue(debut) &
          p.datePaiement.isSmallerThanValue(fin))
      ..orderBy([OrderingTerm.desc(p.datePaiement)]);
    return query.watch().map((rows) => [
          for (final r in rows)
            (r.readTable(p), r.readTable(_db.commandes), r.readTable(_db.clients)),
        ]);
  }

  /// Commandes non annulées dont le solde n'est pas réglé, par échéance.
  Future<List<CommandeAEncaisser>> commandesAEncaisser() async {
    final rows = await (_db.select(_db.commandes).join([
      innerJoin(_db.clients, _db.clients.id.equalsExp(_db.commandes.clientId)),
    ])
          ..where(_db.commandes.deletedAt.isNull() &
              _db.commandes.statut.equalsValue(StatutCommande.annulee).not())
          ..orderBy([OrderingTerm.asc(_db.commandes.dateEcheance)]))
        .get();

    final somme = _db.paiements.montant.sum();
    final payes = await (_db.selectOnly(_db.paiements)
          ..addColumns([_db.paiements.commandeId, somme])
          ..where(_db.paiements.deletedAt.isNull() &
              _db.paiements.statut.equals(StatutPaiement.reussi))
          ..groupBy([_db.paiements.commandeId]))
        .get();
    final payeParCommande = {
      for (final r in payes) r.read(_db.paiements.commandeId)!: r.read(somme) ?? 0,
    };

    return [
      for (final r in rows)
        if (r.readTable(_db.commandes) case final c
            when c.prixConvenu - (payeParCommande[c.id] ?? 0) > 0)
          (
            commande: c,
            client: r.readTable(_db.clients),
            solde: c.prixConvenu - (payeParCommande[c.id] ?? 0),
          ),
    ];
  }
}

ResumeFinances construireResume(
  List<(Paiement, Commande, Client)> encaissements,
  String Function(ModePaiement) codeMode,
) {
  final parMode = <String, int>{};
  final journal = <MouvementCaisse>[];

  for (final (p, c, client) in encaissements) {
    final code = codeMode(p.mode);
    parMode[code] = (parMode[code] ?? 0) + p.montant;
    journal.add(MouvementCaisse(
      id: p.id,
      date: p.datePaiement,
      montant: p.montant,
      titre: '${client.prenom ?? ''} ${client.nom}'.trim(),
      detail: [
        c.reference ?? (c.description?.isNotEmpty == true ? c.description! : 'Commande'),
        if (p.numeroRecu != null) p.numeroRecu!,
      ].join(' · '),
      mode: code,
      reference: p.reference,
      commandeId: c.id,
    ));
  }
  journal.sort((a, b) => b.date.compareTo(a.date));

  return ResumeFinances(
    encaisse: encaissements.fold(0, (s, e) => s + e.$1.montant),
    parMode: parMode.entries.map((e) => (e.key, e.value)).toList()
      ..sort((a, b) => b.$2.compareTo(a.$2)),
    journal: journal,
  );
}
