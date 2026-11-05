import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/accueil/presentation/accueil_page.dart';
import '../features/commandes/presentation/liste_commandes_page.dart';
import '../features/clients/presentation/liste_clients_page.dart';
import '../features/finances/presentation/finances_page.dart';
import '../features/modeles/presentation/catalogue_page.dart';
import '../features/parametres/presentation/parametres_page.dart';
import '../core/providers.dart';
import '../features/notifications/notifications_provider.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _index = 0;

  // Navigation : Tableau · Commandes · Clients · Finances.
  // Catalogue et Réglages passent dans le menu « Plus ».
  final _pages = <Widget>[
    const AccueilPage(),
    const ListeCommandesPage(),
    const ListeClientsPage(),
    const FinancesPage(),
  ];

  static const _indexPlus = 4;

  Future<void> _ouvrirPlus() async {
    final page = await showModalBottomSheet<Widget>(
      context: context,
      useSafeArea: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.checkroom_outlined),
              title: const Text('Catalogue'),
              onTap: () => Navigator.pop(ctx, const CataloguePage()),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Réglages'),
              onTap: () => Navigator.pop(ctx, const ParametresPage()),
            ),
          ],
        ),
      ),
    );
    if (page != null && mounted) {
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialiserSync();
    });
  }

  void _initialiserSync() {
    final sync = ref.read(syncServiceProvider);
    sync.startListening();
    sync.onSyncComplete = () {
      ref.read(lastSyncTimeProvider.notifier).state = sync.lastSyncTime;
      ref.read(isSyncingProvider.notifier).state = false;
      _chargerUtilisateurCourant();
      ref.read(unreadCountProvider.notifier).fetch();
    };
    sync.onSyncError = () {
      ref.read(lastSyncErrorProvider.notifier).state = sync.lastSyncError;
      ref.read(isSyncingProvider.notifier).state = false;
    };
    // Auto-connect if token exists
    ref.read(apiClientProvider).loadToken().then((_) {
      if (ref.read(apiClientProvider).isAuthenticated) {
        ref.read(syncAuthProvider.notifier).state = true;
        sync.executeSync();
      }
      _chargerUtilisateurCourant();
    });
  }

  Future<void> _chargerUtilisateurCourant() async {
    final moiId = await ref.read(syncServiceProvider).moiId();
    if (moiId == null) return;
    final db = ref.read(databaseProvider);
    final moi = await (db.select(db.users)..where((u) => u.id.equals(moiId))).getSingleOrNull();
    if (mounted) ref.read(currentUserProvider.notifier).state = moi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) {
          if (i == _indexPlus) {
            _ouvrirPlus();
          } else {
            setState(() => _index = i);
          }
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Tableau',
          ),
          const NavigationDestination(
            icon: Icon(Icons.content_cut_outlined),
            selectedIcon: Icon(Icons.content_cut),
            label: 'Commandes',
          ),
          const NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Clients',
          ),
          const NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Finances',
          ),
          const NavigationDestination(
            icon: Icon(Icons.menu_rounded),
            label: 'Plus',
          ),
        ],
      ),
    );
  }
}
