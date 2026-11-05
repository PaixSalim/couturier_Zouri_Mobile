import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/database/tables.dart';
import '../../../core/providers.dart';
import 'detail_commande_page.dart';
import 'nouvelle_commande_flow.dart';
import '../../../widgets/app_logo.dart';

class ListeCommandesPage extends ConsumerStatefulWidget {
  const ListeCommandesPage({super.key});

  @override
  ConsumerState<ListeCommandesPage> createState() => _ListeCommandesPageState();
}

class _ListeCommandesPageState extends ConsumerState<ListeCommandesPage> {
  StatutCommande? _filtre;

  @override
  Widget build(BuildContext context) {
    final commandes = ref.watch(commandesFiltreesProvider(_filtre));
    final fmtDate = DateFormat('dd/MM/yy');

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            AppLogo(size: 36),
            SizedBox(width: 10),
            Text('Commandes'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_commandes',
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const NouvelleCommandeFlow()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Commande'),
      ),
      body: Column(
        children: [
          // ── Chips de filtre ──────────────────────────────
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _FiltreChip(
                  label: 'Toutes',
                  selectionne: _filtre == null,
                  onTap: () => setState(() => _filtre = null),
                ),
                const SizedBox(width: 8),
                ...StatutCommande.values.map((s) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _FiltreChip(
                        label: _libelleStatut(s),
                        couleur: _couleurStatut(s),
                        selectionne: _filtre == s,
                        onTap: () => setState(() => _filtre = s),
                      ),
                    )),
              ],
            ),
          ),
          const Divider(height: 1),
          // ── Liste ────────────────────────────────────────
          Expanded(
            child: commandes.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur : $e')),
              data: (liste) {
                if (liste.isEmpty) {
                  return Center(
                    child: Text(
                      _filtre == null
                          ? 'Aucune commande.\nAppuyez sur + pour commencer.'
                          : 'Aucune commande "${_libelleStatut(_filtre!)}".',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: liste.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 72),
                  itemBuilder: (context, i) {
                    final (commande, client) = liste[i];
                    final enRetard =
                        commande.dateEcheance.isBefore(DateTime.now()) &&
                            commande.statut != StatutCommande.livree &&
                            commande.statut != StatutCommande.annulee;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      leading: CircleAvatar(
                        backgroundColor: enRetard
                            ? Theme.of(context).colorScheme.errorContainer
                            : Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          client.nom.isNotEmpty
                              ? client.nom[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: enRetard
                                ? Theme.of(context).colorScheme.onErrorContainer
                                : Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      title: Text(
                        '${client.nom} ${client.prenom ?? ''}'.trim(),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            commande.description ?? 'Sans description',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(
                                Icons.event,
                                size: 12,
                                color: enRetard
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                fmtDate.format(commande.dateEcheance),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: enRetard
                                      ? Theme.of(context).colorScheme.error
                                      : Theme.of(context).colorScheme.onSurfaceVariant,
                                  fontWeight: enRetard
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                              if (enRetard) ...[
                                const SizedBox(width: 6),
                                Text(
                                  'EN RETARD',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Theme.of(context).colorScheme.error,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${commande.prixConvenu} F',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                          const SizedBox(height: 6),
                          _BadgeStatut(statut: commande.statut),
                        ],
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              DetailCommandePage(commandeId: commande.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chip de filtre ────────────────────────────────────────────

class _FiltreChip extends StatelessWidget {
  const _FiltreChip({
    required this.label,
    required this.selectionne,
    required this.onTap,
    this.couleur,
  });

  final String label;
  final bool selectionne;
  final VoidCallback onTap;
  final Color? couleur;

  @override
  Widget build(BuildContext context) {
    final color = couleur ?? Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selectionne ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selectionne ? Colors.white : color,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ── Badge statut ──────────────────────────────────────────────

class _BadgeStatut extends StatelessWidget {
  const _BadgeStatut({required this.statut});
  final StatutCommande statut;

  @override
  Widget build(BuildContext context) {
    final couleur = _couleurStatut(statut);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _libelleStatut(statut),
        style: TextStyle(color: couleur, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────

String _libelleStatut(StatutCommande s) => switch (s) {
      StatutCommande.enAttente => 'En attente',
      StatutCommande.enCours => 'En cours',
      StatutCommande.terminee => 'Terminée',
      StatutCommande.livree => 'Livrée',
      StatutCommande.annulee => 'Annulée',
    };

Color _couleurStatut(StatutCommande s) => switch (s) {
      StatutCommande.enAttente => const Color(0xFFD97706),
      StatutCommande.enCours => const Color(0xFFC05621),
      StatutCommande.terminee => const Color(0xFF0284C7),
      StatutCommande.livree => const Color(0xFF065F46),
      StatutCommande.annulee => const Color(0xFF78716C),
    };
