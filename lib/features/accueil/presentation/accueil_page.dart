import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';
import '../../../core/providers.dart';
import '../../commandes/presentation/nouvelle_commande_flow.dart';
import '../../commandes/presentation/prise_mesures_page.dart';
import '../../../widgets/app_logo.dart';

const _jours = [
  'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'
];
const _mois = [
  'Jan.', 'Fév.', 'Mars', 'Avr.', 'Mai', 'Juin',
  'Juil.', 'Août', 'Sep.', 'Oct.', 'Nov.', 'Déc.'
];

String _dateCourte(DateTime d) =>
    '${_jours[d.weekday - 1]} ${d.day} ${_mois[d.month - 1]}';

class AccueilPage extends ConsumerWidget {
  const AccueilPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commandes = ref.watch(commandesAvecClientProvider);
    final retards = ref.watch(commandesEnRetardProvider);
    final echeances = ref.watch(echeancesProchesProvider);
    final soldes = ref.watch(soldesDusProvider);
    final revenus = ref.watch(revenusduMoisProvider);
    final salon = ref.watch(salonProvider).valueOrNull;
    final currentUser = ref.watch(currentUserProvider);

    final fmt = NumberFormat('#,###', 'fr_FR');
    final fmtDate = DateFormat('dd/MM/yyyy');
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final nomAtelier = salon?.nom.isNotEmpty == true ? salon!.nom : 'Dev Couturier';

    final prenom = currentUser?.firstName?.isNotEmpty == true
        ? currentUser!.firstName!
        : (currentUser?.username ?? '');
    final heure = DateTime.now().hour;
    final salutation =
        heure < 12 ? 'Bonjour' : heure < 18 ? 'Bon après-midi' : 'Bonsoir';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const AppLogo(size: 36),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    nomAtelier,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Tableau de bord',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (currentUser != null)
              CircleAvatar(
                radius: 17,
                backgroundColor: cs.primaryContainer,
                child: Text(
                  currentUser.firstName?.isNotEmpty == true
                      ? currentUser.firstName![0].toUpperCase()
                      : currentUser.username[0].toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
      body: commandes.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (liste) {
          final nbActives = liste
              .where((c) =>
                  c.$1.statut == StatutCommande.enCours ||
                  c.$1.statut == StatutCommande.enAttente)
              .length;
          final nbCours = liste
              .where((c) => c.$1.statut == StatutCommande.enCours)
              .length;
          final nbRetard = retards.valueOrNull?.length ?? 0;
          final nbEcheances = echeances.valueOrNull?.length ?? 0;
          final listeRetards = retards.valueOrNull ?? const [];
          final listeEcheances = echeances.valueOrNull ?? const [];
          final clientsParId = {
            for (final p in liste) p.$1.id: p.$2,
          };

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              // ── Hero terracotta ──────────────────────────
              _Hero(
                salutation: salutation,
                prenom: prenom,
                nomAtelier: nomAtelier,
                nbCours: nbCours,
                nbEcheances: nbEcheances,
              ),
              const SizedBox(height: 14),

              // ── Actions principales ──────────────────────
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _ActionBtn(
                      icone: Icons.add,
                      label: 'Nouvelle commande',
                      primary: true,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const NouvelleCommandeFlow()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: _ActionBtn(
                      icone: Icons.straighten,
                      label: 'Mensurations',
                      primary: false,
                      onTap: () => _choisirClientPourMesures(context, ref),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              _SectionHeader(
                titre: 'Activité de l\'atelier',
                trailing: 'Temps réel',
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _ActivityCard(
                      label: 'Commandes actives',
                      valeur: '$nbActives',
                      icone: Icons.receipt_long_outlined,
                      accent: cs.primary,
                      chip: nbCours > 0 ? '$nbCours en atelier' : null,
                      chipColor: cs.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActivityCard(
                      label: 'À livrer d\'urgence',
                      valeur: '$nbRetard',
                      icone: Icons.notifications_active_outlined,
                      accent: cs.error,
                      chip: nbRetard > 0 ? 'Échéances' : null,
                      chipColor: cs.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ActivityCard(
                      label: 'Acomptes perçus',
                      valeur: fmt.format(revenus.valueOrNull ?? 0),
                      suffixe: 'FCFA',
                      sousTitre: 'ce mois',
                      icone: Icons.savings_outlined,
                      accent: cs.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActivityCard(
                      label: 'Reste à recouvrer',
                      valeur: fmt.format(soldes.valueOrNull ?? 0),
                      suffixe: 'FCFA',
                      sousTitre: 'sur commandes',
                      icone: Icons.account_balance_wallet_outlined,
                      accent: const Color(0xFFD97706),
                      valueColor: const Color(0xFFD97706),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Urgences & prochaines livraisons ─────────
              _SectionHeader(
                titre: 'Urgences & prochaines livraisons',
                action: 'Voir tout',
                onAction: () {},
              ),
              const SizedBox(height: 12),

              if (listeRetards.isEmpty && listeEcheances.isEmpty && liste.isEmpty)
                const _EtatVide(),

              ...listeRetards.map(
                (c) => _UrgenceCard(
                  commande: c,
                  client: clientsParId[c.clientId],
                  fmtDate: fmtDate,
                  enRetard: true,
                ),
              ),
              ...listeEcheances.map(
                (c) => _UrgenceCard(
                  commande: c,
                  client: clientsParId[c.clientId],
                  fmtDate: fmtDate,
                  enRetard: false,
                ),
              ),

              if (listeRetards.isEmpty && listeEcheances.isEmpty && liste.isNotEmpty) ...[
                const SizedBox(height: 4),
                _SectionHeader(titre: 'Commandes récentes'),
                const SizedBox(height: 12),
                ...liste.take(5).map(
                      (pair) => _UrgenceCard(
                        commande: pair.$1,
                        client: pair.$2,
                        fmtDate: fmtDate,
                        enRetard: false,
                      ),
                    ),
              ],

              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }

  Future<void> _choisirClientPourMesures(
      BuildContext context, WidgetRef ref) async {
    final clients = ref.read(clientsProvider('')).valueOrNull ?? const <Client>[];
    if (clients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ajoutez d\'abord un client.')),
      );
      return;
    }
    final client = await showModalBottomSheet<Client>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  'Prendre les mensurations',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: clients.length,
                  itemBuilder: (_, i) {
                    final c = clients[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(ctx).colorScheme.primaryContainer,
                        child: Text(
                          c.nom.isNotEmpty ? c.nom[0].toUpperCase() : '?',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(ctx).colorScheme.primary,
                          ),
                        ),
                      ),
                      title: Text('${c.nom} ${c.prenom ?? ''}'.trim()),
                      subtitle: Text(c.telephone ?? '—'),
                      onTap: () => Navigator.pop(ctx, c),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (client != null && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PriseMesuresPage(client: client)),
      );
    }
  }
}

// ── Hero terracotta ───────────────────────────────────────────

class _Hero extends StatelessWidget {
  const _Hero({
    required this.salutation,
    required this.prenom,
    required this.nomAtelier,
    required this.nbCours,
    required this.nbEcheances,
  });

  final String salutation;
  final String prenom;
  final String nomAtelier;
  final int nbCours;
  final int nbEcheances;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFC05621), Color(0xFF9F3E07), Color(0xFF7D2D00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40C05621),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            bottom: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFFA6F2D1),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Atelier ouvert',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _dateCourte(DateTime.now()),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                prenom.isEmpty ? salutation : '$salutation, $prenom',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Le fil d\'or est prêt. Voici l\'activité de $nomAtelier.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.5,
                  height: 1.4,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _HeroStat(
                      icone: Icons.content_cut,
                      label: 'En atelier',
                      valeur: '$nbCours',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _HeroStat(
                      icone: Icons.local_shipping_outlined,
                      label: 'Échéances sem.',
                      valeur: '$nbEcheances',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.icone,
    required this.label,
    required this.valeur,
  });

  final IconData icone;
  final String label;
  final String valeur;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icone, size: 17, color: Colors.white),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  valeur,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Actions ───────────────────────────────────────────────────

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.icone,
    required this.label,
    required this.primary,
    required this.onTap,
  });

  final IconData icone;
  final String label;
  final bool primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: primary ? cs.primary : cs.surfaceContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icone,
                  size: 18, color: primary ? Colors.white : cs.onSurface),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: primary ? Colors.white : cs.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.titre,
    this.trailing,
    this.action,
    this.onAction,
  });

  final String titre;
  final String? trailing;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            titre,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: cs.onSurfaceVariant,
            ),
          ),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Row(
              children: [
                Text(
                  action!,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: cs.primary,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(Icons.arrow_forward, size: 14, color: cs.primary),
              ],
            ),
          ),
      ],
    );
  }
}

// ── Activity card ─────────────────────────────────────────────

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.label,
    required this.valeur,
    required this.icone,
    required this.accent,
    this.suffixe,
    this.sousTitre,
    this.chip,
    this.chipColor,
    this.valueColor,
  });

  final String label;
  final String valeur;
  final IconData icone;
  final Color accent;
  final String? suffixe;
  final String? sousTitre;
  final String? chip;
  final Color? chipColor;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.5,
                    height: 1.25,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icone, size: 16, color: accent),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  valeur,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    height: 1.05,
                    color: valueColor ?? cs.onSurface,
                  ),
                ),
              ),
              if (suffixe != null) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    suffixe!,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          if (chip != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
              decoration: BoxDecoration(
                color: (chipColor ?? accent).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                chip!,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: chipColor ?? accent,
                ),
              ),
            )
          else if (sousTitre != null)
            Text(
              sousTitre!,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10.5,
                color: cs.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Urgence card ──────────────────────────────────────────────

class _UrgenceCard extends ConsumerWidget {
  const _UrgenceCard({
    required this.commande,
    required this.client,
    required this.fmtDate,
    required this.enRetard,
  });

  final Commande commande;
  final Client? client;
  final DateFormat fmtDate;
  final bool enRetard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final fmt = NumberFormat('#,###', 'fr_FR');
    final nom = client != null
        ? '${client!.nom} ${client!.prenom ?? ''}'.trim()
        : '—';
    final solde = ref.watch(soldeRestantProvider(commande.id));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _couleurStatut(commande.statut).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  nom.isNotEmpty ? nom[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: _couleurStatut(commande.statut),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            nom,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      commande.description ?? 'Sans description',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.5,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _BadgeStatut(statut: commande.statut),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: enRetard
                      ? cs.errorContainer
                      : cs.surfaceContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      enRetard ? Icons.warning_amber_rounded : Icons.event,
                      size: 12,
                      color: enRetard ? cs.error : cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      fmtDate.format(commande.dateEcheance),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: enRetard ? cs.error : cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '${fmt.format(commande.prixConvenu)} F',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          solde.when(
            loading: () => const SizedBox(height: 6),
            error: (_, __) => const SizedBox(height: 6),
            data: (reste) {
              final prix = commande.prixConvenu;
              final paye = (prix - reste).clamp(0, prix);
              final ratio = prix > 0 ? paye / prix : 0.0;
              final pct = (ratio * 100).round();
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 6,
                      backgroundColor: cs.surfaceContainerHigh,
                      valueColor: AlwaysStoppedAnimation(cs.secondary),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Acompte : ${fmt.format(paye)} F',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.5,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        reste <= 0 ? 'Soldé' : '$pct% réglé',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: reste <= 0 ? cs.secondary : cs.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
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
    final (libelle, fond, texte) = switch (statut) {
      StatutCommande.enAttente => (
          'EN ATTENTE',
          const Color(0xFFFEF3C7),
          const Color(0xFF92400E)
        ),
      StatutCommande.enCours => (
          'EN COURS',
          const Color(0xFFFFEDD5),
          const Color(0xFF9A3412)
        ),
      StatutCommande.terminee => (
          'TERMINÉE',
          const Color(0xFFE0F2FE),
          const Color(0xFF075985)
        ),
      StatutCommande.livree => (
          'LIVRÉE',
          const Color(0xFFD1FAE5),
          const Color(0xFF065F46)
        ),
      StatutCommande.annulee => (
          'ANNULÉE',
          const Color(0xFFF5F5F4),
          const Color(0xFF78716C)
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: fond,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        libelle,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          color: texte,
        ),
      ),
    );
  }
}

class _EtatVide extends StatelessWidget {
  const _EtatVide();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 52, color: cs.outline),
          const SizedBox(height: 10),
          const Text(
            'Aucune commande pour le moment',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Appuyez sur + pour créer la première.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

Color _couleurStatut(StatutCommande statut) {
  return switch (statut) {
    StatutCommande.enAttente => const Color(0xFFD97706),
    StatutCommande.enCours => const Color(0xFFC05621),
    StatutCommande.terminee => const Color(0xFF0284C7),
    StatutCommande.livree => const Color(0xFF065F46),
    StatutCommande.annulee => const Color(0xFF78716C),
  };
}
