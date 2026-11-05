import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';
import '../../../core/providers.dart';
import '../../finances/finance_labels.dart';

/// Flux de création d'une commande en 3 étapes, calqué sur l'API (Order) :
/// 1. Client (recherche ou création rapide)
/// 2. Modèle du catalogue (`catalog_model`, facultatif)
/// 3. Détails (prix, avance, échéance, description, notes) → enregistrement
class NouvelleCommandeFlow extends ConsumerStatefulWidget {
  const NouvelleCommandeFlow({super.key});

  @override
  ConsumerState<NouvelleCommandeFlow> createState() =>
      _NouvelleCommandeFlowState();
}

class _NouvelleCommandeFlowState extends ConsumerState<NouvelleCommandeFlow> {
  static const _nbEtapes = 3;

  final _pageController = PageController();
  int _etape = 0;

  // --- Étape 1 : client ---
  Client? _client;
  final _rechercheController = TextEditingController();
  String _recherche = '';

  // --- Étape 2 : modèle ---
  Modele? _modele;

  // --- Étape 3 : détails ---
  final _formDetailsKey = GlobalKey<FormState>();
  final _prixController = TextEditingController();
  final _avanceController = TextEditingController(text: '0');
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  ModePaiement _modeAvance = ModePaiement.especes;
  DateTime? _echeance;
  bool _enregistrementEnCours = false;

  @override
  void dispose() {
    _pageController.dispose();
    _rechercheController.dispose();
    _prixController.dispose();
    _avanceController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ==========================================================
  // NAVIGATION ENTRE ÉTAPES
  // ==========================================================

  void _allerA(int etape) {
    setState(() => _etape = etape);
    _pageController.animateToPage(
      etape,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void _suivant() {
    if (_etape == 0 && _client == null) {
      _snack('Choisissez d\'abord un client.');
      return;
    }
    if (_etape < _nbEtapes - 1) _allerA(_etape + 1);
  }

  void _precedent() {
    if (_etape > 0) _allerA(_etape - 1);
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // ==========================================================
  // ENREGISTREMENT FINAL
  // ==========================================================

  Future<void> _enregistrer() async {
    if (!(_formDetailsKey.currentState?.validate() ?? false)) return;
    if (_echeance == null) {
      _snack('Choisissez la date de livraison.');
      return;
    }

    setState(() => _enregistrementEnCours = true);
    try {
      final prix = int.parse(_prixController.text.trim());
      final avance = int.tryParse(_avanceController.text.trim()) ?? 0;
      final description = _descriptionController.text.trim();
      final notes = _notesController.text.trim();

      final commandeId =
          await ref.read(commandeRepositoryProvider).creer(
                CommandesCompanion.insert(
                  clientId: _client!.id,
                  modeleId: Value(_modele?.id),
                  description:
                      Value(description.isEmpty ? null : description),
                  notes: Value(notes.isEmpty ? null : notes),
                  prixConvenu: prix,
                  dateEcheance: _echeance!,
                ),
              );

      if (avance > 0) {
        await ref.read(paiementRepositoryProvider).ajouter(
              PaiementsCompanion.insert(
                commandeId: commandeId,
                montant: avance,
                mode: Value(_modeAvance),
                // Comme sur l'API : hors espèces, le paiement attend confirmation.
                statut: Value(_modeAvance == ModePaiement.especes
                    ? StatutPaiement.reussi
                    : StatutPaiement.enAttente),
              ),
            );
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Commande enregistrée ✓')),
      );
    } catch (e) {
      _snack('Erreur lors de l\'enregistrement : $e');
    } finally {
      if (mounted) setState(() => _enregistrementEnCours = false);
    }
  }

  // ==========================================================
  // UI
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle commande (${_etape + 1}/$_nbEtapes)'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: (_etape + 1) / _nbEtapes),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _etapeClient(),
          _etapeModele(),
          _etapeDetails(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              if (_etape > 0)
                OutlinedButton(
                  onPressed: _precedent,
                  child: const Text('Précédent'),
                ),
              const Spacer(),
              if (_etape < _nbEtapes - 1)
                FilledButton(
                  onPressed: _suivant,
                  child: const Text('Suivant'),
                )
              else
                FilledButton.icon(
                  onPressed: _enregistrementEnCours ? null : _enregistrer,
                  icon: _enregistrementEnCours
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
      ),
    );
  }

  // ----------------------------------------------------------
  // ÉTAPE 1 : CLIENT
  // ----------------------------------------------------------

  Widget _etapeClient() {
    final clients = ref.watch(clientsProvider(_recherche));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _rechercheController,
            decoration: InputDecoration(
              hintText: 'Rechercher un client...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.person_add),
                tooltip: 'Nouveau client',
                onPressed: _ouvrirDialogNouveauClient,
              ),
              border: const OutlineInputBorder(),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Aucun client trouvé.'),
                      const SizedBox(height: 8),
                      FilledButton.icon(
                        onPressed: _ouvrirDialogNouveauClient,
                        icon: const Icon(Icons.person_add),
                        label: const Text('Créer un client'),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: liste.length,
                itemBuilder: (context, i) {
                  final c = liste[i];
                  final selectionne = _client?.id == c.id;
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(c.nom.isNotEmpty
                          ? c.nom[0].toUpperCase()
                          : '?'),
                    ),
                    title: Text('${c.nom} ${c.prenom ?? ''}'.trim()),
                    subtitle:
                        c.telephone != null ? Text(c.telephone!) : null,
                    trailing: selectionne
                        ? const Icon(Icons.check_circle,
                            color: Colors.green)
                        : null,
                    selected: selectionne,
                    onTap: () => setState(() => _client = c),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _ouvrirDialogNouveauClient() async {
    final client = await showDialog<Client>(
      context: context,
      builder: (_) => const _NouveauClientDialog(),
    );
    if (client != null) {
      setState(() => _client = client);
    }
  }

  // ----------------------------------------------------------
  // ÉTAPE 2 : MODÈLE
  // ----------------------------------------------------------

  Widget _etapeModele() {
    final modeles = ref.watch(modelesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Text('Modèle du catalogue (facultatif) :',
              style: Theme.of(context).textTheme.titleSmall),
        ),
        Expanded(
          child: modeles.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Erreur : $e')),
            data: (liste) {
              if (liste.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Catalogue vide. Vous pourrez ajouter vos modèles '
                      'depuis l\'écran Catalogue. Vous pouvez continuer '
                      'sans modèle.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                itemCount: liste.length,
                itemBuilder: (context, i) {
                  final m = liste[i];
                  final selectionne = _modele?.id == m.id;
                  return _CarteModele(
                    modele: m,
                    selectionne: selectionne,
                    onTap: () => setState(() {
                      _modele = selectionne ? null : m;
                      // Le prix de base du modèle pré-remplit le prix convenu.
                      if (_modele?.prixIndicatif != null && _prixController.text.trim().isEmpty) {
                        _prixController.text = '${_modele!.prixIndicatif}';
                      }
                    }),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // ÉTAPE 3 : DÉTAILS
  // ----------------------------------------------------------

  Widget _etapeDetails() {
    final formatDate = DateFormat('dd/MM/yyyy');

    return Form(
      key: _formDetailsKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Récapitulatif
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Récapitulatif',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text('Client : ${_client?.nom ?? '—'} '
                      '${_client?.prenom ?? ''}'),
                  Text('Modèle : ${_modele?.nom ?? 'Aucun'}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _prixController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Prix convenu (FCFA) *',
              border: OutlineInputBorder(),
            ),
            validator: (v) {
              final n = int.tryParse((v ?? '').trim());
              if (n == null || n <= 0) return 'Entrez un prix valide';
              return null;
            },
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _avanceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Avance versée (FCFA)',
              border: OutlineInputBorder(),
            ),
            validator: (v) {
              final avance = int.tryParse((v ?? '0').trim()) ?? 0;
              final prix =
                  int.tryParse(_prixController.text.trim()) ?? 0;
              if (avance < 0) return 'Montant invalide';
              if (avance > prix) {
                return 'L\'avance dépasse le prix convenu';
              }
              return null;
            },
            onChanged: (_) => setState(() {}),
          ),
          if ((int.tryParse(_avanceController.text.trim()) ?? 0) > 0) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<ModePaiement>(
              value: _modeAvance,
              decoration: const InputDecoration(
                labelText: 'Mode de paiement de l\'avance',
                border: OutlineInputBorder(),
                helperText: 'Hors espèces, l\'avance reste en attente de confirmation',
              ),
              items: [
                for (final m in modesSaisie)
                  DropdownMenuItem(value: m, child: Text(libelleMode(m))),
              ],
              onChanged: (v) =>
                  setState(() => _modeAvance = v ?? _modeAvance),
            ),
          ],
          const SizedBox(height: 16),

          Card(
            child: ListTile(
              leading: const Icon(Icons.event),
              title: Text(_echeance == null
                  ? 'Date de livraison *'
                  : 'Livraison : ${formatDate.format(_echeance!)}'),
              trailing: const Icon(Icons.edit_calendar),
              onTap: () async {
                final maintenant = DateTime.now();
                final date = await showDatePicker(
                  context: context,
                  initialDate:
                      _echeance ?? maintenant.add(const Duration(days: 7)),
                  firstDate: maintenant,
                  lastDate: maintenant.add(const Duration(days: 365)),
                );
                if (date != null) setState(() => _echeance = date);
              },
            ),
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description / détails',
              helperText:
                  'Ex : broderie au col, poches plaquées, doublure...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notes internes',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CARTE MODÈLE (vignette dans la grille)
// ============================================================

class _CarteModele extends StatelessWidget {
  const _CarteModele({
    required this.modele,
    required this.selectionne,
    required this.onTap,
  });

  final Modele modele;
  final bool selectionne;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final vide = Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.checkroom, size: 48),
    );
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: selectionne
            ? BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
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
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(modele.nom,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall),
                  if (modele.prixIndicatif != null)
                    Text('${modele.prixIndicatif} FCFA',
                        style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DIALOG CRÉATION RAPIDE D'UN CLIENT
// ============================================================

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

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  Future<void> _creer() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final telephone = _telephoneController.text.trim();
    final prenom = _prenomController.text.trim();

    final client = await ref.read(clientRepositoryProvider).creer(
          ClientsCompanion.insert(
            nom: _nomController.text.trim(),
            prenom: Value(prenom.isEmpty ? null : prenom),
            telephone: Value(telephone.isEmpty ? null : telephone),
          ),
        );
    if (mounted) Navigator.of(context).pop(client);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouveau client'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nomController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Nom *'),
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? 'Le nom est requis' : null,
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
          ],
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
