import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/database/tables.dart';
import '../../../core/providers.dart';
import '../../../core/sync/correspondances.dart';
import '../../finances/finance_labels.dart';
import '../../finances/presentation/encaisser_sheet.dart';

class DetailCommandePage extends ConsumerWidget {
  const DetailCommandePage({super.key, required this.commandeId});

  final String commandeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commandesStream = ref.watch(commandesAvecClientProvider);
    final paiements = ref.watch(paiementsDeCommandeProvider(commandeId));
    final solde = ref.watch(soldeRestantProvider(commandeId));
    final modeles = ref.watch(modelesProvider).valueOrNull ?? const [];
    final fmtDate = DateFormat('dd/MM/yyyy');
    final fmt = NumberFormat('#,###', 'fr_FR');

    return commandesStream.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Erreur : $e'))),
      data: (liste) {
        final pair = liste.where((p) => p.$1.id == commandeId).firstOrNull;
        if (pair == null) {
          return const Scaffold(
              body: Center(child: Text('Commande introuvable.')));
        }
        final (commande, client) = pair;
        final modele = modeles.where((m) => m.id == commande.modeleId).firstOrNull;
        final nomClient = '${client.nom} ${client.prenom ?? ''}'.trim();
        final enRetard = commande.dateEcheance.isBefore(DateTime.now()) &&
            commande.statut != StatutCommande.livree &&
            commande.statut != StatutCommande.annulee;

        return Scaffold(
          appBar: AppBar(
            title: Text(nomClient),
            actions: [
              if (client.telephone != null) ...[
                IconButton(
                  icon: const Icon(Icons.phone),
                  tooltip: 'Appeler',
                  onPressed: () => _appeler(client.telephone!),
                ),
                IconButton(
                  icon: const Icon(Icons.chat),
                  tooltip: 'WhatsApp',
                  onPressed: () => _whatsapp(
                    client.telephone!,
                    nomClient,
                    solde.valueOrNull ?? 0,
                    commande.statut,
                    fmt,
                  ),
                ),
              ],
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Statut ──────────────────────────────────
              _Section(
                titre: 'Statut',
                child: _SelecteurStatut(
                  commandeId: commandeId,
                  statut: commande.statut,
                ),
              ),

              // ── Infos commande ───────────────────────────
              _Section(
                titre: 'Détails',
                child: Column(
                  children: [
                    if (commande.reference != null)
                      _Ligne('Référence', commande.reference!),
                     _Ligne(
                       'Échéance',
                       fmtDate.format(commande.dateEcheance),
                       couleur: enRetard ? Theme.of(context).colorScheme.error : null,
                       icone: enRetard ? Icons.warning_amber_rounded : Icons.event,
                     ),
                     _Ligne('Prix convenu',
                         '${fmt.format(commande.prixConvenu)} FCFA'),
                     _Ligne(
                       'Solde restant',
                       solde.when(
                         data: (v) => '${fmt.format(v)} FCFA',
                         loading: () => '…',
                         error: (_, __) => '—',
                       ),
                       couleur: solde.valueOrNull != null &&
                               solde.valueOrNull! > 0
                           ? Theme.of(context).colorScheme.tertiary
                           : Theme.of(context).colorScheme.primary,
                     ),
                    if (modele != null) _Ligne('Modèle', modele.nom),
                    if (commande.description != null)
                      _Ligne('Description', commande.description!),
                    if (commande.notes?.trim().isNotEmpty == true)
                      _Ligne('Notes', commande.notes!.trim()),
                  ],
                ),
              ),

              // ── Paiements ────────────────────────────────
              _Section(
                titre: 'Paiements',
                action: TextButton.icon(
                  onPressed: () => ouvrirEncaisser(
                    context,
                    commande: commande,
                    solde: solde.valueOrNull ?? commande.prixConvenu,
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Encaisser'),
                ),
                child: paiements.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Erreur : $e'),
                  data: (liste) {
                    if (liste.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text('Aucun paiement enregistré.',
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      );
                    }
                    return Column(
                      children: liste.map((p) {
                        final enAttente = p.statut == StatutPaiement.enAttente;
                        final echoue = p.statut == StatutPaiement.echoue;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(iconeMode(p.mode),
                              color: teinteMode(p.mode).$2),
                          title: Text(
                            '${fmt.format(p.montant)} FCFA',
                            style: TextStyle(
                              decoration:
                                  echoue ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          subtitle: Text(
                            '${libelleMode(p.mode)}'
                            '${p.numeroRecu != null ? ' · Reçu ${p.numeroRecu}' : ''}\n'
                            '${fmtDate.format(p.datePaiement)}'
                            '${p.reference != null ? ' · ${p.reference}' : ''}',
                          ),
                          isThreeLine: true,
                          trailing: enAttente
                              ? const Chip(
                                  label: Text('En attente'),
                                  visualDensity: VisualDensity.compact)
                              : echoue
                                  ? const Chip(
                                      label: Text('Échoué'),
                                      visualDensity: VisualDensity.compact)
                                  : null,
                          // Reprendre un paiement resté en attente
                          onTap: enAttente
                              ? () => ouvrirEncaisser(
                                    context,
                                    commande: commande,
                                    solde: solde.valueOrNull ?? p.montant,
                                    paiementEnAttente: p,
                                  )
                              : null,
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Actions ────────────────────────────────────────────────

  void _appeler(String telephone) {
    final tel = telephone.replaceAll(' ', '');
    launchUrl(Uri.parse('tel:$tel'));
  }

  void _whatsapp(
    String telephone,
    String nomClient,
    int solde,
    StatutCommande statut,
    NumberFormat fmt,
  ) {
    final tel = telephone.replaceAll(RegExp(r'[^0-9+]'), '');
    final message = statut == StatutCommande.terminee
        ? 'Bonjour $nomClient, votre tenue est prête, vous pouvez passer la récupérer.'
            '${solde > 0 ? ' Solde restant : ${fmt.format(solde)} FCFA.' : ' Solde entièrement réglé ✓'}'
        : 'Bonjour $nomClient, votre commande est en cours de confection.'
            '${solde > 0 ? ' Solde restant : ${fmt.format(solde)} FCFA.' : ''}';

    launchUrl(
      Uri.parse('https://wa.me/$tel?text=${Uri.encodeComponent(message)}'),
      mode: LaunchMode.externalApplication,
    );
  }
}

// ── Selecteur de statut ───────────────────────────────────────

class _SelecteurStatut extends ConsumerWidget {
  const _SelecteurStatut(
      {required this.commandeId, required this.statut});

  final String commandeId;
  final StatutCommande statut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couleur = Theme.of(context).colorScheme.primary;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      // Le serveur n'accepte que les transitions vers l'avant (et l'annulation avant livraison).
      children: StatutCommande.values
          .where((s) => s == statut || cheminStatuts(statutCommandeVersApi(statut), statutCommandeVersApi(s)) != null)
          .map((s) {
        final selectionne = s == statut;
        return GestureDetector(
          onTap: selectionne
              ? null
              : () => ref
                  .read(commandeRepositoryProvider)
                  .changerStatut(commandeId, s),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: selectionne ? couleur : couleur.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: selectionne
                  ? null
                  : Border.all(color: couleur.withValues(alpha: 0.25)),
            ),
            child: Text(
              _libelleStatut(s),
              style: TextStyle(
                color: selectionne ? Colors.white : couleur,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Widgets utilitaires ───────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section({required this.titre, required this.child, this.action});
  final String titre;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(titre,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const Spacer(),
            if (action != null) action!,
          ],
        ),
        const SizedBox(height: 8),
        Card(child: Padding(padding: const EdgeInsets.all(12), child: child)),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _Ligne extends StatelessWidget {
  const _Ligne(this.label, this.valeur, {this.couleur, this.icone});
  final String label;
  final String valeur;
  final Color? couleur;
  final IconData? icone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          if (icone != null) ...[
            Icon(icone, size: 14, color: couleur ?? Colors.grey),
            const SizedBox(width: 4),
          ],
          Text('$label : ',
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Expanded(
            child: Text(
              valeur,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: couleur),
              textAlign: TextAlign.end,
            ),
          ),
        ],
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
