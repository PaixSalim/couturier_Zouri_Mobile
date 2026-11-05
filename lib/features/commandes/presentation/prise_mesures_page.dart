import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers.dart';
import '../../mesures/data/mesure_repository.dart';

/// Prise de mesures = un relevé de l'API (MeasurementRecord) :
/// des noms de mesures libres, une valeur chacun, une unité (cm ou pouces)
/// et une note. Les noms déjà utilisés dans l'atelier sont proposés en raccourci.
class PriseMesuresPage extends ConsumerStatefulWidget {
  const PriseMesuresPage({super.key, required this.client});

  final Client client;

  @override
  ConsumerState<PriseMesuresPage> createState() => _PriseMesuresPageState();
}

class _Ligne {
  _Ligne([String nom = ''])
      : nom = TextEditingController(text: nom),
        valeur = TextEditingController();

  final TextEditingController nom;
  final TextEditingController valeur;

  void dispose() {
    nom.dispose();
    valeur.dispose();
  }
}

class _PriseMesuresPageState extends ConsumerState<PriseMesuresPage> {
  late final _noteController = TextEditingController(
      text: 'Relevé du ${DateFormat('dd/MM/yyyy').format(DateTime.now())}');
  final List<_Ligne> _lignes = [_Ligne()];
  String _unite = 'cm';
  bool _enregistrement = false;

  @override
  void dispose() {
    _noteController.dispose();
    for (final l in _lignes) {
      l.dispose();
    }
    super.dispose();
  }

  void _ajouter([String nom = '']) {
    setState(() {
      // Une ligne vide en fin de liste est réutilisée plutôt que d'en ajouter une.
      final derniere = _lignes.isEmpty ? null : _lignes.last;
      if (nom.isNotEmpty && derniere != null && derniere.nom.text.trim().isEmpty) {
        derniere.nom.text = nom;
      } else {
        _lignes.add(_Ligne(nom));
      }
    });
  }

  void _retirer(_Ligne ligne) {
    setState(() => _lignes.remove(ligne));
    ligne.dispose();
  }

  Future<void> _enregistrer() async {
    final libelle = _noteController.text.trim();
    if (libelle.isEmpty) {
      _snack('Donnez un nom au relevé.');
      return;
    }

    final mesures = <MesureSaisie>[];
    final noms = <String>{};
    for (final l in _lignes) {
      final nom = l.nom.text.trim();
      final valeur = double.tryParse(l.valeur.text.trim().replaceAll(',', '.'));
      if (nom.isEmpty && valeur == null) continue;
      if (nom.isEmpty || valeur == null || valeur <= 0) {
        _snack('Chaque mesure doit avoir un nom et une valeur positive.');
        return;
      }
      if (!noms.add(nom.toLowerCase())) {
        _snack('La mesure « $nom » est saisie deux fois.');
        return;
      }
      mesures.add(MesureSaisie(nom: nom, valeur: valeur, unite: _unite));
    }
    if (mesures.isEmpty) {
      _snack('Saisissez au moins une mesure.');
      return;
    }

    setState(() => _enregistrement = true);
    try {
      final fiche = await ref.read(mesureRepositoryProvider).creerFiche(
            clientId: widget.client.id,
            libelle: libelle,
            mesures: mesures,
          );
      if (mounted) Navigator.of(context).pop(fiche);
    } finally {
      if (mounted) setState(() => _enregistrement = false);
    }
  }

  void _snack(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final suggestions = ref.watch(nomsMesuresProvider).valueOrNull ?? const <String>[];
    final dejaSaisis = {for (final l in _lignes) l.nom.text.trim().toLowerCase()};
    final nomClient = '${widget.client.nom} ${widget.client.prenom ?? ''}'.trim();

    return Scaffold(
      appBar: AppBar(title: Text('Mesures — $nomClient')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Nom du relevé',
              helperText: 'Ex : Boubou mariage, Robe soirée…',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'cm', label: Text('Centimètres')),
              ButtonSegment(value: 'in', label: Text('Pouces')),
            ],
            selected: {_unite},
            onSelectionChanged: (s) => setState(() => _unite = s.first),
          ),
          if (suggestions.any((n) => !dejaSaisis.contains(n.toLowerCase()))) ...[
            const SizedBox(height: 16),
            Text('Mesures déjà utilisées', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final n in suggestions.take(20))
                  if (!dejaSaisis.contains(n.toLowerCase()))
                    ActionChip(label: Text(n), onPressed: () => _ajouter(n)),
              ],
            ),
          ],
          const SizedBox(height: 16),
          for (final l in _lignes)
            Padding(
              key: ObjectKey(l),
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: l.nom,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        labelText: 'Mesure',
                        hintText: 'Tour de taille',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: l.valeur,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        labelText: 'Valeur',
                        suffixText: _unite,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Retirer',
                    icon: const Icon(Icons.close),
                    onPressed: _lignes.length > 1 ? () => _retirer(l) : null,
                  ),
                ],
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _ajouter,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter une mesure'),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _enregistrement ? null : _enregistrer,
            icon: _enregistrement
                ? const SizedBox(
                    width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.save),
            label: const Text('Enregistrer le relevé'),
          ),
        ],
      ),
    );
  }
}
