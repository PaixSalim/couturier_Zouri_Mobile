import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/sync/api_client.dart';

// ============================================================
// Modèle de notification serveur
// ============================================================

class NotificationServeur {
  final String id;
  final String type;
  final String titre;
  final String message;
  final String? lien;
  final bool estLu;
  final DateTime createdAt;

  NotificationServeur({
    required this.id,
    required this.type,
    required this.titre,
    required this.message,
    this.lien,
    required this.estLu,
    required this.createdAt,
  });

  factory NotificationServeur.fromJson(Map<String, dynamic> json) {
    return NotificationServeur(
      id: json['id'] as String,
      type: json['kind'] as String? ?? '',
      titre: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      lien: null, // l'API renvoie l'UUID de la commande/du paiement, pas d'URL
      estLu: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
    );
  }
}

// ============================================================
// Provider : nombre de notifications non lues
// ============================================================

final unreadCountProvider = StateNotifierProvider<UnreadCountNotifier, int>((ref) {
  return UnreadCountNotifier(ref.read(apiClientProvider));
});

class UnreadCountNotifier extends StateNotifier<int> {
  final ApiClient _api;
  UnreadCountNotifier(this._api) : super(0);

  Future<void> fetch() async {
    try {
      state = await _api.nonLues();
    } catch (_) {
      // keep previous count
    }
  }

  void decrement() {
    if (state > 0) state--;
  }

  void reset() => state = 0;
}

// ============================================================
// Provider : liste des notifications
// ============================================================

final notificationsListProvider =
    FutureProvider.autoDispose<List<NotificationServeur>>((ref) async {
  final api = ref.read(apiClientProvider);
  final raw = await api.getNotifications();
  return raw.map((j) => NotificationServeur.fromJson(j)).toList();
});
