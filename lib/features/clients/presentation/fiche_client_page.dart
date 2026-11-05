import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';
import '../../../core/providers.dart';
import '../../commandes/presentation/detail_commande_page.dart';
import '../../commandes/presentation/nouvelle_commande_flow.dart';
import '../../commandes/presentation/prise_mesures_page.dart';

class FicheClientPage extends ConsumerWidget {
  const FicheClientPage({super.key, required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientAsync = ref.watch(
      clientsProvider('').select(
        (v) => v.whenData(
          (l) => l.where((c) => c.id == clientId).firstOrNull,
        ),
      ),
    );

    return clientAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Erreur : $e'))),
      data: (client) {
        if (client == null) {
          return const Scaffold(
              body: Center(child: Text('Client introuvable.')));
        }
        final nomClient = '${client.nom} ${client.prenom ?? ''}'.trim();

        return Scaffold(
          appBar: AppBar(
            title: Text(nomClient),
            actions: [
              if (client.telephone != null) ...[
                IconButton(
                  icon: const Icon(Icons.phone),
                  tooltip: 'Appeler',
                  onPressed: () => launchUrl(
                    Uri.parse(
                        'tel:${client.telephone!.replaceAll(' ', '')}'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chat),
                  tooltip: 'WhatsApp',
                  onPressed: () => launchUrl(
                    Uri.parse(
                        'https://wa.me/${client.telephone!.replaceAll(RegExp(r'[^0-9+]'), '')}'),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
              ],
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _InfosClient(client: client),
              const SizedBox(height: 16),
              _SectionFichesMesures(client: client),
              const SizedBox(height: 16),
              _SectionCommandes(clientId: clientId),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: 'fab_fiche_client',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const NouvelleCommandeFlow(),
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Commande'),
          ),
        );
      },
    );
  }
}

// ── Infos client ──────────────────────────────────────────────

class _InfosClient extends StatelessWidget {
  const _InfosClient({required this.client});
  final Client client;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Informations',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (client.telephone != null)
              _LigneInfo(Icons.phone, client.telephone!),
            if (client.email != null) _LigneInfo(Icons.mail_outline, client.email!),
            if (client.adresse != null) _LigneInfo(Icons.place_outlined, client.adresse!),
            if (client.note != null) _LigneInfo(Icons.notes, client.note!),
             if (client.telephone == null &&
                 client.email == null &&
                 client.adresse == null &&
                 client.note == null)
               Text('Aucune information supplémentaire.',
                   style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _LigneInfo extends StatelessWidget {
  const _LigneInfo(this.icone, this.texte);
  final IconData icone;
  final String texte;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icone, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text(texte)),
        ],
      ),
    );
  }
}

// ── Fiches de mesures ─────────────────────────────────────────

class _SectionFichesMesures extends ConsumerWidget {
  const _SectionFichesMesures({required this.client});
  final Client client;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fiches = ref.watch(fichesDuClientProvider(client.id));
    final fmtDate = DateFormat('dd/MM/yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Fiches de mesures',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const Spacer(),
            TextButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PriseMesuresPage(client: client),
                ),
              ),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Nouvelle'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        fiches.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Erreur : $e'),
          data: (liste) {
            if (liste.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'Aucune fiche de mesures.',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                ),
              );
            }
            return Card(
              child: Column(
                children: liste
                    .map((f) => _FicheMesureTile(fiche: f, fmtDate: fmtDate))
                    .toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _FicheMesureTile extends ConsumerWidget {
  const _FicheMesureTile({required this.fiche, required this.fmtDate});
  final FichesMesure fiche;
  final DateFormat fmtDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mesures = ref.watch(mesuresDeFicheProvider(fiche.id));

    return ExpansionTile(
      leading: const Icon(Icons.straighten),
      title: Text(fiche.libelle),
      subtitle: Text('Prise le ${fmtDate.format(fiche.datePrise)}'),
      children: [
        mesures.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
          error: (e, _) => Text('Erreur : $e'),
          data: (liste) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: liste
                  .map((m) => Row(
                        children: [
                          Expanded(
                            child: Text(m.nomMesure,
                                style: const TextStyle(color: Colors.grey)),
                          ),
                          Text(
                            '${m.valeur} ${m.unite}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Historique commandes ──────────────────────────────────────

class _SectionCommandes extends ConsumerWidget {
  const _SectionCommandes({required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commandes = ref.watch(commandesDuClientProvider(clientId));
    final fmtDate = DateFormat('dd/MM/yy');
    final fmt = NumberFormat('#,###', 'fr_FR');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Historique commandes',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        commandes.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Erreur : $e'),
          data: (liste) {
            if (liste.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text('Aucune commande.',
                        style: TextStyle(color: Colors.grey.shade500)),
                  ),
                ),
              );
            }
            return Card(
              child: Column(
                children: liste
                    .map((c) => ListTile(
                          leading: _BadgeStatut(statut: c.statut),
                          title: Text(
                            c.description ?? 'Sans description',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                              '${fmt.format(c.prixConvenu)} FCFA — '
                              '${fmtDate.format(c.dateEcheance)}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetailCommandePage(commandeId: c.id),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            );
          },
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _BadgeStatut extends StatelessWidget {
  const _BadgeStatut({required this.statut});
  final StatutCommande statut;

  @override
  Widget build(BuildContext context) {
    final (libelle, couleur) = switch (statut) {
      StatutCommande.enAttente => ('Attente', Theme.of(context).colorScheme.tertiary),
      StatutCommande.enCours => ('En cours', Theme.of(context).colorScheme.primary),
      StatutCommande.terminee => ('Terminée', Theme.of(context).colorScheme.primary),
      StatutCommande.livree => ('Livrée', Theme.of(context).colorScheme.outline),
      StatutCommande.annulee => ('Annulée', Theme.of(context).colorScheme.error),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(libelle,
          style: TextStyle(
              color: couleur, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }
}
