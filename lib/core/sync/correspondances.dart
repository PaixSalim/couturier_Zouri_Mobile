import '../database/tables.dart';

/// Correspondances entre le modèle local (Drift) et l'API Dev Couturier.
/// Fonctions pures : aucune dépendance au réseau ni à la base.

// ─── Commandes ────────────────────────────────────────────────

/// Ordre des statuts de commande côté API (hors annulation).
const statutsCommandeApi = ['draft', 'confirmed', 'in_progress', 'ready', 'delivered'];

String statutCommandeVersApi(StatutCommande s) => switch (s) {
      StatutCommande.enAttente => 'confirmed',
      StatutCommande.enCours => 'in_progress',
      StatutCommande.terminee => 'ready',
      StatutCommande.livree => 'delivered',
      StatutCommande.annulee => 'cancelled',
    };

StatutCommande statutCommandeDepuisApi(String? s) => switch (s) {
      'in_progress' => StatutCommande.enCours,
      'ready' => StatutCommande.terminee,
      'delivered' => StatutCommande.livree,
      'cancelled' => StatutCommande.annulee,
      _ => StatutCommande.enAttente, // draft, confirmed
    };

/// Transitions à envoyer, une par une, pour passer de [actuel] à [cible].
/// Renvoie `null` si c'est impossible (retour en arrière, commande close).
List<String>? cheminStatuts(String actuel, String cible) {
  if (actuel == cible) return const [];
  if (actuel == 'delivered' || actuel == 'cancelled') return null;
  if (cible == 'cancelled') return const ['cancelled'];
  final de = statutsCommandeApi.indexOf(actuel);
  final vers = statutsCommandeApi.indexOf(cible);
  if (de < 0 || vers < 0 || vers < de) return null;
  return statutsCommandeApi.sublist(de + 1, vers + 1);
}

/// Les articles d'une commande ne sont modifiables qu'avant la confection.
bool articlesModifiables(String? statutDistant) =>
    statutDistant == null || statutDistant == 'draft' || statutDistant == 'confirmed';

// ─── Paiements ────────────────────────────────────────────────

String methodeVersApi(ModePaiement m) => switch (m) {
      ModePaiement.especes => 'cash',
      ModePaiement.orangeMoney => 'orange_money',
      ModePaiement.moovMoney => 'moov_money',
      ModePaiement.virement => 'bank_transfer',
      ModePaiement.carte => 'card',
      ModePaiement.autre => 'other',
    };

ModePaiement methodeDepuisApi(String? m) => ModePaiement.values.firstWhere(
      (mode) => methodeVersApi(mode) == m,
      orElse: () => ModePaiement.autre,
    );

/// Statut local (`StatutPaiement`) correspondant au statut API.
String statutPaiementDepuisApi(String? s) => switch (s) {
      'confirmed' => StatutPaiement.reussi,
      'pending' => StatutPaiement.enAttente,
      _ => StatutPaiement.echoue, // failed, cancelled, refunded
    };

// ─── Clients ──────────────────────────────────────────────────

/// Le mobile exige le nom, l'API exige le prénom : sans prénom, le nom sert de prénom.
({String firstName, String lastName}) nomVersApi(String nom, String? prenom) {
  final p = prenom?.trim() ?? '';
  return p.isEmpty ? (firstName: nom.trim(), lastName: '') : (firstName: p, lastName: nom.trim());
}

({String nom, String? prenom}) nomDepuisApi(String firstName, String lastName) =>
    lastName.trim().isEmpty
        ? (nom: firstName.trim(), prenom: null)
        : (nom: lastName.trim(), prenom: firstName.trim());

// ─── Mesures ──────────────────────────────────────────────────

/// Une seule unité par relevé côté API : pouces si une mesure est en pouces, sinon cm.
String uniteReleve(Iterable<String> unites) =>
    unites.any((u) => const {'in', 'pouce', 'pouces'}.contains(u.toLowerCase())) ? 'in' : 'cm';

// ─── Dates ────────────────────────────────────────────────────

String dateApi(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// L'API refuse une échéance dans le passé (tolérance d'un jour).
bool echeanceAcceptee(DateTime echeance, {DateTime? maintenant}) {
  final m = maintenant ?? DateTime.now();
  final hier = DateTime(m.year, m.month, m.day).subtract(const Duration(days: 1));
  return !DateTime(echeance.year, echeance.month, echeance.day).isBefore(hier);
}

int montantDepuisApi(Object? valeur) =>
    valeur == null ? 0 : double.parse(valeur.toString()).round();
