import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers.dart';
import '../../../widgets/app_logo.dart';
import 'fiche_client_page.dart';

class ListeClientsPage extends ConsumerStatefulWidget {
  const ListeClientsPage({super.key});

  @override
  ConsumerState<ListeClientsPage> createState() => _ListeClientsPageState();
}

class _ListeClientsPageState extends ConsumerState<ListeClientsPage> {
  final _rechercheController = TextEditingController();
  String _recherche = '';

  @override
  void dispose() {
    _rechercheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clients = ref.watch(clientsProvider(_recherche));

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            AppLogo(size: 36),
            SizedBox(width: 10),
            Text('Clients'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_clients',
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const _NouveauClientDialog(),
        ),
        child: const Icon(Icons.person_add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _rechercheController,
              decoration: InputDecoration(
                hintText: 'Rechercher par nom, prénom, téléphone...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _recherche.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _rechercheController.clear();
                          setState(() => _recherche = '');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _recherche = v),
            ),
          ),
          Expanded(
            child: clients.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur : $e')),
              data: (liste) {
                if (liste.isEmpty) {
                  return Center(
                    child: Text(
                      _recherche.isEmpty
                          ? 'Aucun client.\nAppuyez sur + pour en ajouter un.'
                          : 'Aucun résultat pour "$_recherche".',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: liste.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 72),
                  itemBuilder: (context, i) => _ClientTile(client: liste[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tuile client ──────────────────────────────────────────────

class _ClientTile extends ConsumerWidget {
  const _ClientTile({required this.client});
  final Client client;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commandes = ref.watch(commandesDuClientProvider(client.id));
    final nb = commandes.valueOrNull?.length ?? 0;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text(
          client.nom.isNotEmpty ? client.nom[0].toUpperCase() : '?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
      title: Text(
        '${client.nom} ${client.prenom ?? ''}'.trim(),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        client.telephone ?? 'Pas de téléphone',
        style: TextStyle(color: client.telephone != null ? null : Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      trailing: nb > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$nb cmd',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FicheClientPage(clientId: client.id),
        ),
      ),
    );
  }
}

// ── Dialog nouveau client ─────────────────────────────────────

class _NouveauClientDialog extends ConsumerStatefulWidget {
  const _NouveauClientDialog();

  @override
  ConsumerState<_NouveauClientDialog> createState() =>
      _NouveauClientDialogState();
}

class _NouveauClientDialogState extends ConsumerState<_NouveauClientDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _adresseController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _adresseController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _creer() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final prenom = _prenomController.text.trim();
    final telephone = _telephoneController.text.trim();
    await ref.read(clientRepositoryProvider).creer(
          ClientsCompanion.insert(
            nom: _nomController.text.trim(),
            prenom: Value(prenom.isEmpty ? null : prenom),
            telephone: Value(telephone.isEmpty ? null : telephone),
            email: Value(_vide(_emailController.text)),
            adresse: Value(_vide(_adresseController.text)),
            note: Value(_vide(_noteController.text)),
          ),
        );
    if (mounted) Navigator.of(context).pop();
  }

  static String? _vide(String t) => t.trim().isEmpty ? null : t.trim();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouveau client'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nomController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Nom *'),
              validator: (v) => (v ?? '').trim().isEmpty ? 'Requis' : null,
            ),
            TextFormField(
              controller: _prenomController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Prénom'),
            ),
            TextFormField(
              controller: _telephoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Téléphone *'),
              // Obligatoire côté serveur pour identifier le client.
              validator: (v) => (v ?? '').trim().length < 6 ? 'Numéro requis' : null,
            ),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'E-mail'),
              validator: (v) {
                final t = (v ?? '').trim();
                return t.isEmpty || RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t)
                    ? null
                    : 'E-mail invalide';
              },
            ),
            TextFormField(
              controller: _adresseController,
              decoration: const InputDecoration(labelText: 'Adresse'),
            ),
            TextFormField(
              controller: _noteController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
          ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(onPressed: _creer, child: const Text('Créer')),
      ],
    );
  }
}
