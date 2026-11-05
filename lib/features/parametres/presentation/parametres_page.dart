import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' show Value;

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart' show RoleMembre;
import '../../../core/providers.dart';
import '../../notifications/notifications_provider.dart';
import '../../notifications/presentation/liste_notifications_page.dart';
import '../../../widgets/app_logo.dart';

class ParametresPage extends ConsumerWidget {
  const ParametresPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salon = ref.watch(salonProvider).valueOrNull;
    final currentUser = ref.watch(currentUserProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            AppLogo(size: 36),
            SizedBox(width: 10),
            Text('Paramètres'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [

          // ── Mon atelier ───────────────────────────────────
          _SectionTitre('Mon atelier'),
          // Fiche de l'atelier (Workshop) : modifiée ici, envoyée au serveur à la sync.
          _Card(children: [
            _ChampAtelier(
              icone: Icons.store,
              titre: 'Nom de l\'atelier',
              valeur: salon?.nom,
              onSave: (v) => _modifierSalon(ref, salon, SalonsCompanion(nom: Value(v))),
              obligatoire: true,
            ),
            _Divider(),
            _ChampAtelier(
              icone: Icons.phone,
              titre: 'Téléphone',
              valeur: salon?.telephone,
              clavier: TextInputType.phone,
              onSave: (v) => _modifierSalon(ref, salon, SalonsCompanion(telephone: Value(_vide(v)))),
            ),
            _Divider(),
            _ChampAtelier(
              icone: Icons.email,
              titre: 'E-mail',
              valeur: salon?.email,
              clavier: TextInputType.emailAddress,
              onSave: (v) => _modifierSalon(ref, salon, SalonsCompanion(email: Value(_vide(v)))),
            ),
            _Divider(),
            _ChampAtelier(
              icone: Icons.location_on,
              titre: 'Adresse',
              valeur: salon?.adresse,
              onSave: (v) => _modifierSalon(ref, salon, SalonsCompanion(adresse: Value(_vide(v)))),
            ),
            _Divider(),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: cs.secondaryContainer,
                child: Icon(Icons.attach_money, color: cs.secondary, size: 20),
              ),
              title: const Text('Devise'),
              subtitle: Text('Franc CFA (XOF)',
                  style: TextStyle(color: cs.primary, fontWeight: FontWeight.w600)),
            ),
          ]),
          // ── Utilisateur connecté ──────────────────────────
          if (currentUser != null) ...[
            _SectionTitre('Mon compte'),
            _Card(children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: cs.primaryContainer,
                  child: Text(
                    (currentUser.firstName ?? currentUser.username)[0].toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.w700, color: cs.primary),
                  ),
                ),
                title: Text(currentUser.firstName ?? currentUser.username),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (currentUser.lastName != null) Text(currentUser.lastName!),
                    Text(_libelleRole(currentUser.role), style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
                  ],
                ),
              ),
            ]),
          ],

          // ── Centre de notifications ──────────────────────
          _SectionTitre('Centre de notifications'),
          _Card(children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: cs.primaryContainer,
                child: Icon(Icons.notifications, color: cs.primary, size: 20),
              ),
              title: const Text('Voir les notifications'),
              subtitle: Text('${ref.watch(unreadCountProvider)} non lue(s)'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ListeNotificationsPage()),
              ),
            ),
          ]),

          // ── Synchronisation ───────────────────────────────
          _SectionTitre('Synchronisation'),
          _Card(children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: cs.tertiaryContainer,
                child: Icon(Icons.cloud_sync, color: cs.tertiary, size: 20),
              ),
              title: const Text('Serveur'),
              subtitle: Text(
                ref.watch(apiBaseUrlProvider),
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
              ),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () => _editerTexte(context,
                  titre: 'URL du serveur',
                  valeurInitiale: ref.read(apiBaseUrlProvider),
                  onSave: (v) {
                    if (v.isNotEmpty) ref.read(apiBaseUrlProvider.notifier).state = v;
                  }),
            ),
            _Divider(),
            _SyncStatusTile(ref: ref, cs: cs),
            if (ref.watch(syncAuthProvider)) ...[
              _Divider(),
              _DerniereSyncTile(ref: ref, cs: cs),
              _Divider(),
              _SyncButtonTile(ref: ref, cs: cs),
            ],
            if (ref.watch(lastSyncErrorProvider) case final err?) ...[
              _Divider(),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: cs.errorContainer,
                  child: Icon(Icons.error_outline, color: cs.error, size: 20),
                ),
                title: Text(err, style: TextStyle(fontSize: 13, color: cs.error)),
                trailing: IconButton(
                  icon: Icon(Icons.close, size: 18, color: cs.onSurfaceVariant),
                  onPressed: () => ref.read(lastSyncErrorProvider.notifier).state = null,
                ),
              ),
            ],
            _Divider(),
            _CompteurEnAttenteTile(ref: ref, cs: cs),
          ]),

          _SectionTitre('Application'),
          _Card(children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: cs.surfaceContainerHighest,
                child: Icon(Icons.info_outline, color: cs.onSurfaceVariant, size: 20),
              ),
              title: const Text('Version'),
              trailing: Text('1.0.0',
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13)),
            ),
            _Divider(),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: cs.errorContainer,
                child: Icon(Icons.delete_sweep, color: cs.error, size: 20),
              ),
              title: Text('Réinitialiser les données',
                  style: TextStyle(color: cs.error)),
              subtitle: Text('Supprime toutes les données locales',
                  style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
              onTap: () => _reinitialiserDonnees(context, ref),
            ),
          ]),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _editerTexte(
    BuildContext context, {
    required String titre,
    required String valeurInitiale,
    required void Function(String) onSave,
  }) async {
    final controller = TextEditingController(text: valeurInitiale);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(titre),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
          decoration: InputDecoration(hintText: titre),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result != null) onSave(result);
  }

  static String? _vide(String v) => v.trim().isEmpty ? null : v.trim();

  /// Crée la fiche atelier si besoin, sinon la modifie ; la sync l'envoie au serveur.
  Future<void> _modifierSalon(WidgetRef ref, Salon? salon, SalonsCompanion modifs) async {
    final db = ref.read(databaseProvider);
    final maintenant = DateTime.now();
    if (salon == null) {
      await db.into(db.salons).insert(modifs.copyWith(
            nom: modifs.nom.present ? modifs.nom : const Value('Mon atelier'),
            updatedAt: Value(maintenant),
          ));
    } else {
      await (db.update(db.salons)..where((s) => s.id.equals(salon.id))).write(
          modifs.copyWith(updatedAt: Value(maintenant), isSynced: const Value(false)));
    }
  }

  Future<void> _reinitialiserDonnees(BuildContext context, WidgetRef ref) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Réinitialiser toutes les données ?'),
        content: const Text(
          'Cette action supprime toutes les données locales (clients, commandes, paiements, mesures, modèles).\n\n'
          'Les données sur le serveur ne sont pas affectées. Vous devrez resynchroniser après.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Tout effacer'),
          ),
        ],
      ),
    );
    if (confirme == true) {
      await ref.read(databaseProvider).clearAllData();
      ref.read(lastSyncTimeProvider.notifier).state = null;
      ref.read(lastSyncErrorProvider.notifier).state = null;
      ref.read(syncAuthProvider.notifier).state = false;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Données locales réinitialisées')),
        );
      }
    }
  }
}

// ── Widgets utilitaires ───────────────────────────────────────

class _SectionTitre extends StatelessWidget {
  const _SectionTitre(this.titre);
  final String titre;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        titre.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(child: Column(children: children)),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 56,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}

class _ChampAtelier extends StatelessWidget {
  const _ChampAtelier({
    required this.icone,
    required this.titre,
    required this.valeur,
    required this.onSave,
    this.clavier = TextInputType.text,
    this.obligatoire = false,
  });

  final IconData icone;
  final String titre;
  final String? valeur;
  final void Function(String) onSave;
  final TextInputType clavier;
  final bool obligatoire;

  Future<void> _editer(BuildContext context) async {
    final controller = TextEditingController(text: valeur ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(titre),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: clavier,
          textCapitalization: TextCapitalization.sentences,
          onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
          decoration: InputDecoration(hintText: titre),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null || (obligatoire && result.isEmpty)) return;
    onSave(result);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final vide = valeur == null || valeur!.isEmpty;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: cs.primaryContainer,
        child: Icon(icone, color: cs.primary, size: 20),
      ),
      title: Text(titre),
      subtitle: Text(
        vide ? 'Appuyez pour renseigner' : valeur!,
        style: TextStyle(
          color: vide ? cs.onSurfaceVariant : cs.primary,
          fontWeight: vide ? FontWeight.normal : FontWeight.w600,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () => _editer(context),
    );
  }
}

class _SyncStatusTile extends ConsumerWidget {
  const _SyncStatusTile({required this.ref, required this.cs});
  final WidgetRef ref;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context, WidgetRef _) {
    final connecte = ref.watch(syncAuthProvider);
    if (connecte) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.withAlpha(40),
          child: const Icon(Icons.cloud_done, color: Colors.green, size: 20),
        ),
        title: const Text('Connecte'),
        subtitle: Text('Sync auto activee',
            style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
        trailing: IconButton(
          icon: const Icon(Icons.logout, size: 20),
          onPressed: () async {
            await ref.read(apiClientProvider).logout();
            ref.read(syncAuthProvider.notifier).state = false;
          },
        ),
      );
    }
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: cs.errorContainer,
        child: const Icon(Icons.cloud_off, color: Colors.grey, size: 20),
      ),
      title: const Text('Non connecte'),
      subtitle: const Text('Connectez-vous au serveur',
          style: TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () => _connecterServeur(context, ref),
    );
  }
}

Future<void> _connecterServeur(BuildContext context, WidgetRef ref) async {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Connexion au serveur'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: usernameCtrl,
          decoration: const InputDecoration(
            labelText: "Nom d'utilisateur",
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: passwordCtrl,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Mot de passe',
            prefixIcon: Icon(Icons.lock),
          ),
        ),
      ]),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Se connecter'),
        ),
      ],
    ),
  );
  if (result == true) {
    final sync = ref.read(syncServiceProvider);
    sync.onSyncComplete = () {
      ref.read(lastSyncTimeProvider.notifier).state = sync.lastSyncTime;
      ref.read(isSyncingProvider.notifier).state = false;
    };
    sync.onSyncError = () {
      ref.read(lastSyncErrorProvider.notifier).state = sync.lastSyncError;
      ref.read(isSyncingProvider.notifier).state = false;
    };
    final ok = await sync.login(usernameCtrl.text, passwordCtrl.text);
    if (context.mounted) {
      ref.read(syncAuthProvider.notifier).state = ok;
      if (ok && sync.lastSyncTime != null) {
        ref.read(lastSyncTimeProvider.notifier).state = sync.lastSyncTime;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? 'Connecte au serveur !' : 'Echec de connexion'),
        ),
      );
    }
  }
  usernameCtrl.dispose();
  passwordCtrl.dispose();
}

class _DerniereSyncTile extends ConsumerWidget {
  const _DerniereSyncTile({required this.ref, required this.cs});
  final WidgetRef ref;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context, WidgetRef _) {
    final lastTime = ref.watch(lastSyncTimeProvider);
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: cs.tertiaryContainer,
        child: Icon(Icons.schedule, color: cs.tertiary, size: 20),
      ),
      title: Text(lastTime != null
          ? 'Derniere sync : ${dateFmt.format(lastTime)}'
          : 'Pas encore synchronise'),
      subtitle: Text(lastTime != null
          ? 'Les donnees sont a jour'
          : 'Synchronisez pour la premiere fois',
          style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
    );
  }
}

class _SyncButtonTile extends ConsumerWidget {
  const _SyncButtonTile({required this.ref, required this.cs});
  final WidgetRef ref;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context, WidgetRef _) {
    final syncing = ref.watch(isSyncingProvider);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: cs.primaryContainer,
        child: syncing
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: cs.primary),
              )
            : Icon(Icons.sync, color: cs.primary, size: 20),
      ),
      title: Text(syncing
          ? 'Synchronisation en cours...'
          : 'Synchroniser maintenant'),
      onTap: syncing
          ? null
          : () async {
              ref.read(isSyncingProvider.notifier).state = true;
              final sync = ref.read(syncServiceProvider);
              sync.onSyncComplete = () {
                ref.read(lastSyncTimeProvider.notifier).state = sync.lastSyncTime;
                ref.read(isSyncingProvider.notifier).state = false;
              };
              sync.onSyncError = () {
                ref.read(lastSyncErrorProvider.notifier).state = sync.lastSyncError;
                ref.read(isSyncingProvider.notifier).state = false;
              };
              await sync.executeSync();
              if (sync.lastSyncError == null) {
                ref.read(lastSyncTimeProvider.notifier).state = sync.lastSyncTime;
              }
              ref.read(isSyncingProvider.notifier).state = false;
            },
    );
  }
}

class _CompteurEnAttenteTile extends ConsumerWidget {
  const _CompteurEnAttenteTile({required this.ref, required this.cs});
  final WidgetRef ref;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context, WidgetRef _) {
    final pending = ref.watch(pendingSyncCountProvider);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: cs.surfaceContainerHighest,
        child: Icon(Icons.hourglass_empty, color: cs.onSurfaceVariant, size: 20),
      ),
      title: pending.when(
        data: (count) => Text(
          count > 0
              ? '$count element(s) en attente de sync'
              : 'Tout est synchronise',
        ),
        loading: () => const Text('Calcul...'),
        error: (_, __) => const Text('Erreur de comptage'),
      ),
      subtitle: pending.when(
        data: (count) => count > 0
            ? Text('Connectez-vous au serveur pour synchroniser',
                style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant))
            : null,
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }
}

String _libelleRole(RoleMembre r) => switch (r) {
      RoleMembre.owner => 'Propriétaire',
      RoleMembre.manager => 'Responsable',
      RoleMembre.tailor => 'Tailleur',
      RoleMembre.member => 'Membre',
    };
