import 'package:dev_couturier/core/database/tables.dart';
import 'package:dev_couturier/core/sync/correspondances.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('cheminStatuts', () {
    test('avance étape par étape', () {
      expect(cheminStatuts('draft', 'delivered'), ['confirmed', 'in_progress', 'ready', 'delivered']);
      expect(cheminStatuts('confirmed', 'ready'), ['in_progress', 'ready']);
      expect(cheminStatuts('ready', 'ready'), isEmpty);
    });

    test("l'annulation est directe tant que la commande n'est pas close", () {
      expect(cheminStatuts('in_progress', 'cancelled'), ['cancelled']);
      expect(cheminStatuts('delivered', 'cancelled'), isNull);
    });

    test('pas de retour en arrière', () {
      expect(cheminStatuts('ready', 'in_progress'), isNull);
      expect(cheminStatuts('cancelled', 'confirmed'), isNull);
    });
  });

  test('statuts de commande aller-retour', () {
    for (final s in StatutCommande.values) {
      expect(statutCommandeDepuisApi(statutCommandeVersApi(s)), s);
    }
    expect(statutCommandeDepuisApi('draft'), StatutCommande.enAttente);
  });

  test("modes de paiement : ceux de l'API, aller-retour", () {
    for (final m in ModePaiement.values) {
      expect(methodeDepuisApi(methodeVersApi(m)), m);
    }
    expect(methodeVersApi(ModePaiement.virement), 'bank_transfer');
    expect(methodeVersApi(ModePaiement.carte), 'card');
    expect(methodeDepuisApi('inconnu'), ModePaiement.autre);
  });

  test('nom et prénom', () {
    expect(nomVersApi('Ouédraogo', 'Awa'), (firstName: 'Awa', lastName: 'Ouédraogo'));
    expect(nomVersApi('Tantie Awa', null), (firstName: 'Tantie Awa', lastName: ''));
    expect(nomDepuisApi('Awa', 'Ouédraogo'), (nom: 'Ouédraogo', prenom: 'Awa'));
    expect(nomDepuisApi('Tantie Awa', ''), (nom: 'Tantie Awa', prenom: null));
  });

  test('échéance acceptée avec un jour de tolérance', () {
    final maintenant = DateTime(2026, 11, 4, 15);
    expect(echeanceAcceptee(DateTime(2026, 11, 3), maintenant: maintenant), isTrue);
    expect(echeanceAcceptee(DateTime(2026, 11, 2), maintenant: maintenant), isFalse);
    expect(dateApi(DateTime(2026, 1, 5)), '2026-01-05');
  });

  test('montants décimaux du serveur', () {
    expect(montantDepuisApi('15000.00'), 15000);
    expect(montantDepuisApi(null), 0);
  });
}
