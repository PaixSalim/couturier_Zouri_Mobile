import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/providers.dart';
import 'data/finance_repository.dart';
import 'finance_labels.dart';

final financeRepositoryProvider = Provider<FinanceRepository>(
    (ref) => FinanceRepository(ref.watch(databaseProvider)));

/// Mois affiché sur l'écran Finances (premier jour du mois).
final moisFinancesProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

final encaissementsDuMoisProvider =
    StreamProvider.family<List<(Paiement, Commande, Client)>, DateTime>(
  (ref, mois) =>
      ref.watch(financeRepositoryProvider).watchEncaissementsDuMois(mois),
);

AsyncValue<ResumeFinances> _resume(Ref ref, DateTime mois) =>
    ref.watch(encaissementsDuMoisProvider(mois)).whenData((e) => construireResume(e, codeMode));

/// Résumé du mois sélectionné, réactif aux paiements locaux.
final resumeFinancesProvider = Provider<AsyncValue<ResumeFinances>>(
  (ref) => _resume(ref, ref.watch(moisFinancesProvider)),
);

/// Résumé du mois précédent (pour la tendance « vs mois préc. »).
final resumeMoisPrecedentProvider = Provider<AsyncValue<ResumeFinances>>((ref) {
  final mois = ref.watch(moisFinancesProvider);
  return _resume(ref, DateTime(mois.year, mois.month - 1));
});

final commandesAEncaisserProvider =
    FutureProvider.autoDispose<List<CommandeAEncaisser>>(
  (ref) => ref.watch(financeRepositoryProvider).commandesAEncaisser(),
);
