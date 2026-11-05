import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../data/finance_repository.dart';
import '../finance_labels.dart';
import '../finances_provider.dart';
import 'encaisser_sheet.dart';

/// Écran « Caisse & acomptes » (onglet Finances).
class FinancesPage extends ConsumerWidget {
  const FinancesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mois = ref.watch(moisFinancesProvider);
    final resume = ref.watch(resumeFinancesProvider);
    final precedent = ref.watch(resumeMoisPrecedentProvider).valueOrNull;
    final reste = ref.watch(soldesDusProvider).valueOrNull ?? 0;
    final now = DateTime.now();
    final estMoisCourant = mois.year == now.year && mois.month == now.month;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Caisse & acomptes'),
        actions: [
          IconButton(
            tooltip: 'Mois précédent',
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: () => ref.read(moisFinancesProvider.notifier).state =
                DateTime(mois.year, mois.month - 1),
          ),
          Center(
            child: Text(
              _capitaliser(DateFormat('MMM yyyy', 'fr_FR').format(mois)),
              style: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            tooltip: 'Mois suivant',
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: estMoisCourant
                ? null
                : () => ref.read(moisFinancesProvider.notifier).state =
                    DateTime(mois.year, mois.month + 1),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: resume.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (r) => RefreshIndicator(
          onRefresh: () async {
            await ref.read(syncServiceProvider).executeSync();
            ref.invalidate(soldesDusProvider);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              _CarteCaisse(
                resume: r,
                reste: reste,
                active: estMoisCourant,
                variation: _variation(r.encaisse, precedent?.encaisse),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: () => _choisirCommande(context, ref),
                icon: const Icon(Icons.add_circle_outline_rounded),
                label: const Text('Encaisser'),
              ),
              const SizedBox(height: 22),
              const _Surtitre('Modes de règlement'),
              const SizedBox(height: 8),
              if (r.parMode.isEmpty)
                Text('Aucun encaissement ce mois-ci.',
                    style: TextStyle(color: AppTheme.encreDouce))
              else
                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: r.parMode.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) =>
                        _PastilleMode(code: r.parMode[i].$1, montant: r.parMode[i].$2),
                  ),
                ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Text('Encaissements',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text('${r.journal.length}'),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              if (r.journal.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text('Aucun encaissement ce mois-ci.',
                        style: TextStyle(color: AppTheme.encreDouce)),
                  ),
                ),
              ..._journalParJour(context, ref, r.journal),
            ],
          ),
        ),
      ),
    );
  }

  static double? _variation(int actuel, int? precedent) {
    if (precedent == null || precedent == 0) return null;
    return (actuel - precedent) * 100 / precedent.abs();
  }

  static String _capitaliser(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  List<Widget> _journalParJour(
      BuildContext context, WidgetRef ref, List<MouvementCaisse> journal) {
    final widgets = <Widget>[];
    final now = DateTime.now();
    DateTime? jourCourant;
    for (final m in journal) {
      final jour = DateTime(m.date.year, m.date.month, m.date.day);
      if (jour != jourCourant) {
        jourCourant = jour;
        final estAujourdhui =
            jour == DateTime(now.year, now.month, now.day);
        widgets.add(_EnTeteJour(
          (estAujourdhui ? "Aujourd'hui · " : '') +
              DateFormat('EEEE d MMMM', 'fr_FR').format(jour),
        ));
      }
      widgets.add(_CarteMouvement(mouvement: m));
    }
    return widgets;
  }

  Future<void> _choisirCommande(BuildContext context, WidgetRef ref) async {
    final choix = await showModalBottomSheet<CommandeAEncaisser>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => const _ChoixCommandeSheet(),
    );
    if (choix == null || !context.mounted) return;
    await ouvrirEncaisser(
      context,
      commande: choix.commande,
      solde: choix.solde,
    );
  }
}

class _CarteCaisse extends StatelessWidget {
  const _CarteCaisse({
    required this.resume,
    required this.reste,
    required this.active,
    required this.variation,
  });

  final ResumeFinances resume;
  final int reste;
  final bool active;
  final double? variation;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,###', 'fr_FR');
    final total = resume.encaisse + reste;
    final partEnc = total == 0 ? 1.0 : resume.encaisse / total;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.filet),
        boxShadow: const [
          BoxShadow(color: Color(0x14C05621), blurRadius: 24, offset: Offset(0, 8), spreadRadius: -4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: active ? AppTheme.emeraude : AppTheme.encreDouce,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(active ? 'CAISSE ACTIVE' : 'CAISSE CLÔTURÉE',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
              const Spacer(),
              if (variation != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: variation! >= 0 ? const Color(0xFFD1FAE5) : const Color(0xFFFBE4E2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${variation! >= 0 ? '+' : ''}${variation!.toStringAsFixed(1)}% vs mois préc.',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: variation! >= 0 ? AppTheme.emeraude : AppTheme.brique,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Encaissé ce mois-ci',
              style: TextStyle(fontSize: 13, color: AppTheme.encreDouce)),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: fmt.format(resume.encaisse)),
                const TextSpan(text: ' FCFA', style: TextStyle(fontSize: 16)),
              ]),
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 40,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.8,
                color: AppTheme.terracottaDark,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: (partEnc * 100).round().clamp(2, 98),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                      color: AppTheme.emeraude, borderRadius: BorderRadius.circular(99)),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                flex: 100 - (partEnc * 100).round().clamp(2, 98),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                      color: AppTheme.terracotta, borderRadius: BorderRadius.circular(99)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _Tuile(Icons.south_rounded, 'Encaissé', resume.encaisse, AppTheme.emeraude),
              const SizedBox(width: 8),
              _Tuile(Icons.hourglass_bottom_rounded, 'À recouvrer', reste, AppTheme.terracotta),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tuile extends StatelessWidget {
  const _Tuile(this.icone, this.libelle, this.valeur, this.couleur);

  final IconData icone;
  final String libelle;
  final int valeur;
  final Color couleur;

  String _compact(int v) {
    if (v.abs() >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v.abs() >= 10000) return '${(v / 1000).round()}k';
    return NumberFormat('#,###', 'fr_FR').format(v);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppTheme.ecru, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icone, size: 14, color: couleur),
              const SizedBox(width: 4),
              Flexible(
                child: Text(libelle,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 11.5, fontWeight: FontWeight.w600, color: couleur)),
              ),
            ]),
            const SizedBox(height: 6),
            Text(_compact(valeur),
                style: const TextStyle(
                    fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.w700)),
            const Text('FCFA', style: TextStyle(fontSize: 10.5, color: AppTheme.encreDouce)),
          ],
        ),
      ),
    );
  }
}

class _Surtitre extends StatelessWidget {
  const _Surtitre(this.texte);
  final String texte;

  @override
  Widget build(BuildContext context) => Text(
        texte.toUpperCase(),
        style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.8,
            color: AppTheme.encreDouce),
      );
}

class _PastilleMode extends StatelessWidget {
  const _PastilleMode({required this.code, required this.montant});

  final String code;
  final int montant;

  @override
  Widget build(BuildContext context) {
    final mode = modeDepuisCode(code);
    final (fond, encre) = teinteMode(mode);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.filet),
      ),
      child: Row(
        children: [
          CircleAvatar(
              radius: 16, backgroundColor: fond, child: Icon(iconeMode(mode), size: 17, color: encre)),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(libelleMode(mode), style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('${NumberFormat('#,###', 'fr_FR').format(montant)} FCFA',
                  style: const TextStyle(fontSize: 12, color: AppTheme.encreDouce)),
            ],
          ),
        ],
      ),
    );
  }
}

class _EnTeteJour extends StatelessWidget {
  const _EnTeteJour(this.texte);
  final String texte;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Row(
        children: [
          Text(texte.toUpperCase(),
              style: const TextStyle(
                  fontSize: 11.5, fontWeight: FontWeight.w600, letterSpacing: 0.7,
                  color: AppTheme.encreDouce)),
          const SizedBox(width: 10),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

class _CarteMouvement extends StatelessWidget {
  const _CarteMouvement({required this.mouvement});

  final MouvementCaisse mouvement;

  @override
  Widget build(BuildContext context) {
    final m = mouvement;
    final mode = modeDepuisCode(m.mode);
    final (fond, encre) = teinteMode(mode);
    final fmt = NumberFormat('#,###', 'fr_FR');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.filet),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: fond, borderRadius: BorderRadius.circular(12)),
                  child: Icon(iconeMode(mode), color: encre),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.titre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontFamily: 'Outfit', fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(m.detail,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, color: AppTheme.encreDouce)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '+${fmt.format(m.montant)}',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppTheme.emeraude,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: AppTheme.lin,
            child: Text(
              [
                libelleMode(mode),
                if (m.reference?.isNotEmpty == true) m.reference!,
              ].join(' · '),
              style: const TextStyle(fontSize: 12, color: AppTheme.encreDouce),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoixCommandeSheet extends ConsumerWidget {
  const _ChoixCommandeSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commandes = ref.watch(commandesAEncaisserProvider);
    final fmt = NumberFormat('#,###', 'fr_FR');
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      builder: (_, controller) => Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Encaisser une commande',
                  style: TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.w700)),
            ),
          ),
          Expanded(
            child: commandes.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur : $e')),
              data: (liste) => liste.isEmpty
                  ? const Center(child: Text('Toutes les commandes sont soldées.'))
                  : ListView.separated(
                      controller: controller,
                      itemCount: liste.length,
                      separatorBuilder: (_, __) => const Divider(indent: 20, endIndent: 20),
                      itemBuilder: (_, i) {
                        final c = liste[i];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          title: Text('${c.client.prenom ?? ''} ${c.client.nom}'.trim(),
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(
                            '${c.commande.description?.isNotEmpty == true ? c.commande.description : 'Commande'}'
                            ' · éch. ${DateFormat('dd/MM').format(c.commande.dateEcheance)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text('${fmt.format(c.solde)} F',
                              style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.terracotta)),
                          onTap: () => Navigator.pop(context, c),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
