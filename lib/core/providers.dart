import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/app_database.dart';
import 'database/tables.dart';
import 'sync/api_client.dart';
import 'sync/sync_service.dart';
import '../features/clients/data/client_repository.dart';
import '../features/commandes/data/commande_repository.dart';
import '../features/mesures/data/mesure_repository.dart';
import '../features/modeles/data/modele_repository.dart';
import '../features/paiements/data/paiement_repository.dart';

// ============================================================
// BASE DE DONNÉES (singleton)
// ============================================================

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

// ============================================================
// REPOSITORIES
// ============================================================

final clientRepositoryProvider = Provider<ClientRepository>(
    (ref) => ClientRepository(ref.watch(databaseProvider)));

final commandeRepositoryProvider = Provider<CommandeRepository>(
    (ref) => CommandeRepository(ref.watch(databaseProvider)));

final mesureRepositoryProvider = Provider<MesureRepository>(
    (ref) => MesureRepository(ref.watch(databaseProvider)));

final modeleRepositoryProvider = Provider<ModeleRepository>(
    (ref) => ModeleRepository(ref.watch(databaseProvider)));

final paiementRepositoryProvider = Provider<PaiementRepository>(
    (ref) => PaiementRepository(ref.watch(databaseProvider)));

// ============================================================
// STREAMS RÉACTIFS (l'UI se met à jour toute seule)
// ============================================================

/// Clients filtrés par la recherche (chaîne vide = tous).
final clientsProvider = StreamProvider.family<List<Client>, String>(
  (ref, recherche) =>
      ref.watch(clientRepositoryProvider).watchTous(recherche: recherche),
);

final commandesAvecClientProvider = StreamProvider<List<(Commande, Client)>>(
  (ref) => ref.watch(commandeRepositoryProvider).watchAvecClient(),
);

/// Commandes filtrées par statut (null = toutes).
final commandesFiltreesProvider =
    StreamProvider.family<List<(Commande, Client)>, StatutCommande?>(
  (ref, statut) =>
      ref.watch(commandeRepositoryProvider).watchAvecClient(statut: statut),
);

/// Solde restant d'une commande spécifique.
final soldeRestantProvider = FutureProvider.family<int, String>(
  (ref, commandeId) =>
      ref.watch(commandeRepositoryProvider).soldeRestant(commandeId),
);

final commandesEnRetardProvider = StreamProvider<List<Commande>>(
  (ref) => ref.watch(commandeRepositoryProvider).watchEnRetard(),
);

final modelesProvider = StreamProvider<List<Modele>>(
  (ref) => ref.watch(modeleRepositoryProvider).watchTous(),
);

final fichesDuClientProvider =
    StreamProvider.family<List<FichesMesure>, String>(
  (ref, clientId) =>
      ref.watch(mesureRepositoryProvider).watchFichesDuClient(clientId),
);

/// Noms de mesures déjà utilisés (suggestions de saisie).
final nomsMesuresProvider = FutureProvider.autoDispose<List<String>>(
  (ref) => ref.watch(mesureRepositoryProvider).nomsDejaUtilises(),
);

final paiementsDeCommandeProvider =
    StreamProvider.family<List<Paiement>, String>(
  (ref, commandeId) =>
      ref.watch(paiementRepositoryProvider).watchDeCommande(commandeId),
);

final echeancesProchesProvider = StreamProvider<List<Commande>>(
  (ref) => ref.watch(commandeRepositoryProvider).watchEcheancesProches(),
);

final soldesDusProvider = FutureProvider<int>(
  (ref) => ref.watch(commandeRepositoryProvider).soldesDus(),
);

final revenusduMoisProvider = FutureProvider<int>(
  (ref) => ref.watch(paiementRepositoryProvider).revenusduMois(),
);

final commandesDuClientProvider =
    StreamProvider.family<List<Commande>, String>(
  (ref, clientId) =>
      ref.watch(clientRepositoryProvider).watchCommandesDuClient(clientId),
);

final mesuresDeFicheProvider =
    StreamProvider.family<List<Mesure>, String>(
  (ref, ficheId) =>
      ref.watch(mesureRepositoryProvider).watchMesuresDeFiche(ficheId),
);

// ============================================================
// SYNC (API + Synchronisation)
// ============================================================

/// URL de l'API Dev Couturier, modifiable dans Réglages › Synchronisation.
/// Par défaut : serveur Django local vu depuis l'émulateur Android (10.0.2.2),
/// ou depuis le navigateur pour la version web (localhost).
/// Sur un vrai téléphone : l'IP du PC sur le même Wi-Fi, ou sans toucher au code :
/// flutter run --dart-define=API_BASE_URL=http://192.168.1.79:8000
const String _defaultApiBaseUrl = kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000';
const String _apiBaseUrlOverride = String.fromEnvironment('API_BASE_URL');

final apiBaseUrlProvider = StateProvider<String>(
  (ref) => (_apiBaseUrlOverride.isNotEmpty
          ? _apiBaseUrlOverride
          : _defaultApiBaseUrl)
      .replaceFirst(RegExp(r'/+$'), ''),
);

/// Client HTTP pour l'API REST Django
final apiClientProvider = Provider<ApiClient>((ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider);
  return ApiClient(baseUrl);
});

/// Service de synchronisation
final syncServiceProvider = Provider<SyncService>((ref) {
  final db = ref.watch(databaseProvider);
  final api = ref.watch(apiClientProvider);
  return SyncService(db, api);
});

/// État de la connexion au serveur
final syncAuthProvider = StateProvider<bool>((ref) => false);

/// Indique si une sync est en cours
final isSyncingProvider = StateProvider<bool>((ref) => false);

/// Dernière synchronisation réussie
final lastSyncTimeProvider = StateProvider<DateTime?>((ref) => null);

/// Dernière erreur de synchronisation
final lastSyncErrorProvider = StateProvider<String?>((ref) => null);

/// Nombre d'éléments en attente de synchronisation
final pendingSyncCountProvider = FutureProvider<int>((ref) async {
  final sync = ref.watch(syncServiceProvider);
  return sync.pendingCount();
});

// ============================================================
// SALON / ENTREPRISE
// ============================================================

final salonProvider = StreamProvider<Salon?>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.salons)).watchSingle();
});

/// Utilisateur connecté (GET /auth/me/ + son rôle dans l'atelier), mis à jour à chaque sync.
final currentUserProvider = StateProvider<User?>((ref) => null);
