import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers.dart';
import '../../../widgets/app_logo.dart';
import 'detail_modele_page.dart';

class CataloguePage extends ConsumerWidget {
  const CataloguePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modeles = ref.watch(modelesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            AppLogo(size: 36),
            SizedBox(width: 10),
            Text('Catalogue'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_catalogue',
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => const _AjouterModeleSheet(),
        ),
        child: const Icon(Icons.add),
      ),
      body: modeles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (liste) {
          if (liste.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.checkroom_outlined,
                      size: 72, color: Theme.of(context).colorScheme.outlineVariant),
                  const SizedBox(height: 12),
                  Text('Catalogue vide.',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 4),
                  Text('Appuyez sur + pour ajouter un modèle.',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ],
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.72,
            ),
            itemCount: liste.length,
            itemBuilder: (context, i) => _CarteModele(modele: liste[i]),
          );
        },
      ),
    );
  }
}

// ── Carte modèle ──────────────────────────────────────────────

class _CarteModele extends StatelessWidget {
  const _CarteModele({required this.modele});
  final Modele modele;

  @override
  Widget build(BuildContext context) {
    final vide = Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(Icons.checkroom_outlined,
          size: 52, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.35)),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailModelePage(modeleId: modele.id),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: modele.imageUrl == null
                  ? vide
                  : Image.network(modele.imageUrl!,
                      fit: BoxFit.cover, errorBuilder: (_, __, ___) => vide),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    modele.nom,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    [
                      if (modele.prixIndicatif != null) '${modele.prixIndicatif} FCFA',
                      if (!modele.estPublie) 'Non publié',
                    ].join(' · '),
                    style: TextStyle(
                        fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sheet ajout modèle ────────────────────────────────────────

class _AjouterModeleSheet extends ConsumerStatefulWidget {
  const _AjouterModeleSheet();

  @override
  ConsumerState<_AjouterModeleSheet> createState() =>
      _AjouterModeleSheetState();
}

class _AjouterModeleSheetState extends ConsumerState<_AjouterModeleSheet> {
  final _nomController = TextEditingController();
  final _descController = TextEditingController();
  final _prixController = TextEditingController();
  final _typeController = TextEditingController();
  final _imageController = TextEditingController();
  bool _publie = false;
  bool _enCours = false;

  @override
  void dispose() {
    _nomController.dispose();
    _descController.dispose();
    _prixController.dispose();
    _typeController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    final nom = _nomController.text.trim();
    if (nom.isEmpty) return;
    final image = _imageController.text.trim();
    if (image.isNotEmpty && !(Uri.tryParse(image)?.isAbsolute ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Le lien de la photo doit commencer par http(s)://')));
      return;
    }
    setState(() => _enCours = true);
    try {
      final prix = int.tryParse(_prixController.text.trim());
      final type = _typeController.text.trim();
      await ref.read(modeleRepositoryProvider).creer(
            ModelesCompanion.insert(
              nom: nom,
              description: Value(
                  _descController.text.trim().isEmpty
                      ? null
                      : _descController.text.trim()),
              prixIndicatif: Value(prix),
              typeVetement: Value(type.isEmpty ? null : type),
              imageUrl: Value(image.isEmpty ? null : image),
              estPublie: Value(_publie),
            ),
          );
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _enCours = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Nouveau modèle',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            TextField(
              controller: _nomController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nom du modèle *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _typeController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Catégorie',
                hintText: 'Ex : Homme, Femme, Enfant, Accessoire',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _prixController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Prix de base (FCFA)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _imageController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Lien de la photo',
                hintText: 'https://…',
                helperText: 'Photo déjà hébergée en ligne (facultatif)',
                border: OutlineInputBorder(),
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Visible par les clients'),
              value: _publie,
              onChanged: (v) => setState(() => _publie = v),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _enCours ? null : _enregistrer,
              icon: _enCours
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.check),
              label: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
