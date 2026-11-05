import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers.dart';
import '../../commandes/presentation/nouvelle_commande_flow.dart';

class DetailModelePage extends ConsumerWidget {
  const DetailModelePage({super.key, required this.modeleId});
  final String modeleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modeles = ref.watch(modelesProvider);
    final fmt = NumberFormat('#,###', 'fr_FR');

    return modeles.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Erreur : $e'))),
      data: (liste) {
        final modele =
            liste.where((m) => m.id == modeleId).firstOrNull;
        if (modele == null) {
          return const Scaffold(
              body: Center(child: Text('Modèle introuvable.')));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              modele.nom,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          body: ListView(
            children: [
              // ── Photo (image_url de l'API) ───────────────
              if (modele.imageUrl != null)
                Image.network(
                  modele.imageUrl!,
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                )
              else
                Container(
                  height: 200,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.checkroom_outlined,
                    size: 80,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
                  ),
                ),

              // ── Infos ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(modele.nom,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1C1B1F))),
                    const SizedBox(height: 8),
                    if (modele.typeVetement != null)
                      Chip(
                        label: Text(modele.typeVetement!),
                        visualDensity: VisualDensity.compact,
                      ),
                    if (modele.prixIndicatif != null) ...[
                      const SizedBox(height: 8),
                       Row(
                         children: [
                           Icon(Icons.sell_outlined,
                               size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
                           const SizedBox(width: 6),
                           Text(
                             '${fmt.format(modele.prixIndicatif)} FCFA',
                             style: const TextStyle(
                                 fontSize: 18,
                                 fontWeight: FontWeight.w700),
                           ),
                           Text(' (prix de base)',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                    ],
                    if (modele.description != null) ...[
                      const SizedBox(height: 12),
                      Text(modele.description!,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.5)),
                    ],
                    const SizedBox(height: 12),
                    // L'API ne supprime pas un modèle : on le publie ou on le retire du catalogue client.
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Visible par les clients'),
                      subtitle: const Text('Publié dans le catalogue client'),
                      value: modele.estPublie,
                      onChanged: (v) => ref
                          .read(modeleRepositoryProvider)
                          .modifier(modele.id, ModelesCompanion(estPublie: Value(v))),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const NouvelleCommandeFlow(),
                        ),
                      ),
                      icon: const Icon(Icons.content_cut),
                      label: const Text('Créer une commande avec ce modèle'),
                      style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(48)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
