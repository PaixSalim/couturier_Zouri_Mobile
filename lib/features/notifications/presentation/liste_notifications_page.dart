import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../notifications_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ListeNotificationsPage extends ConsumerWidget {
  const ListeNotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncNotifs = ref.watch(notificationsListProvider);
    final unread = ref.watch(unreadCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: () async {
                try {
                  await ref.read(apiClientProvider).marquerToutLu();
                  ref.read(unreadCountProvider.notifier).reset();
                  ref.invalidate(notificationsListProvider);
                } catch (_) {}
              },
              child: const Text('Tout lu'),
            ),
        ],
      ),
      body: asyncNotifs.when(
        data: (notifs) {
          if (notifs.isEmpty) {
            return const Center(child: Text('Aucune notification'));
          }
          return ListView.separated(
            itemCount: notifs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final n = notifs[i];
              return ListTile(
                leading: Icon(
                  n.estLu ? Icons.notifications_none : Icons.notifications,
                  color: n.estLu ? Colors.grey : Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  n.titre,
                  style: TextStyle(
                    fontWeight: n.estLu ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  n.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  _formatDate(n.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onTap: () async {
                  if (!n.estLu) {
                    try {
                      await ref.read(apiClientProvider).marquerLu(n.id);
                      ref.read(unreadCountProvider.notifier).decrement();
                      ref.invalidate(notificationsListProvider);
                    } catch (_) {}
                  }
                  if (n.lien != null && n.lien!.startsWith('/')) {
                    final url = '${ref.read(apiBaseUrlProvider)}${n.lien}';
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
      ),
    );
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}j';
    return '${d.day}/${d.month}/${d.year}';
  }
}
