import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../finance_labels.dart';
import '../finances_provider.dart';

/// Ouvre la feuille d'encaissement d'une commande.
/// Renvoie `true` si un paiement a été encaissé.
Future<bool?> ouvrirEncaisser(
  BuildContext context, {
  required Commande commande,
  required int solde,
  Paiement? paiementEnAttente,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => EncaisserSheet(
      commande: commande,
      solde: solde,
      paiementEnAttente: paiementEnAttente,
    ),
  );
}

enum _Etape { saisie, attente, reussi, echoue }

class EncaisserSheet extends ConsumerStatefulWidget {
  const EncaisserSheet({
    super.key,
    required this.commande,
    required this.solde,
    this.paiementEnAttente,
  });

  final Commande commande;
  final int solde;

  /// Reprend un paiement resté « en attente ».
  final Paiement? paiementEnAttente;

  @override
  ConsumerState<EncaisserSheet> createState() => _EncaisserSheetState();
}

class _EncaisserSheetState extends ConsumerState<EncaisserSheet> {
  final _fmt = NumberFormat('#,###', 'fr_FR');
  late final TextEditingController _montant;
  late final TextEditingController _reference;
  ModePaiement _mode = ModePaiement.especes;

  _Etape _etape = _Etape.saisie;
  String? _erreur;
  Paiement? _paiement;

  /// Comme sur l'API : seules les espèces sont confirmées tout de suite,
  /// les autres modes attendent que le couturier voie l'argent arriver.
  bool get _estMobile => _mode != ModePaiement.especes;

  @override
  void initState() {
    super.initState();
    final p = widget.paiementEnAttente;
    _montant = TextEditingController(
        text: '${p?.montant ?? (widget.solde > 0 ? widget.solde : '')}');
    _reference = TextEditingController(text: p?.reference ?? '');
    if (p != null) {
      _mode = p.mode;
      _etape = _Etape.attente;
      _paiement = p;
    }
  }

  @override
  void dispose() {
    _montant.dispose();
    _reference.dispose();
    super.dispose();
  }

  int get _montantSaisi =>
      int.tryParse(_montant.text.replaceAll(RegExp(r'\D'), '')) ?? 0;

  void _rafraichirSoldes() {
    ref.invalidate(soldeRestantProvider(widget.commande.id));
    ref.invalidate(soldesDusProvider);
    ref.invalidate(revenusduMoisProvider);
    ref.invalidate(commandesAEncaisserProvider);
  }

  Future<void> _valider() async {
    final montant = _montantSaisi;
    if (montant <= 0) {
      setState(() => _erreur = 'Saisissez un montant.');
      return;
    }
    if (montant > widget.solde) {
      setState(() =>
          _erreur = 'Le montant dépasse le solde (${_fmt.format(widget.solde)} FCFA).');
      return;
    }
    setState(() => _erreur = null);
    String? vide(String t) => t.trim().isEmpty ? null : t.trim();
    // Hors espèces : en attente jusqu'à ce que le couturier voie l'argent arriver.
    final paiement = await ref.read(paiementRepositoryProvider).ajouter(
          PaiementsCompanion.insert(
            commandeId: widget.commande.id,
            montant: montant,
            mode: Value(_mode),
            statut: Value(_estMobile ? StatutPaiement.enAttente : StatutPaiement.reussi),
            reference: Value(_estMobile ? vide(_reference.text) : null),
          ),
        );
    _rafraichirSoldes();
    _synchroniserEnFond();
    if (!mounted) return;
    if (_estMobile) {
      setState(() {
        _paiement = paiement;
        _etape = _Etape.attente;
      });
    } else {
      Navigator.pop(context, true);
    }
  }

  /// Envoi au serveur dès que possible ; sans réseau, la prochaine sync s'en charge.
  void _synchroniserEnFond() {
    if (ref.read(apiClientProvider).isAuthenticated) {
      ref.read(syncServiceProvider).executeSync();
    }
  }

  Future<void> _conclure(bool recu) async {
    final p = _paiement!;
    await ref
        .read(paiementRepositoryProvider)
        .changerStatut(p.id, recu ? StatutPaiement.reussi : StatutPaiement.echoue);
    _rafraichirSoldes();
    _synchroniserEnFond();
    if (!mounted) return;
    setState(() => _etape = recu ? _Etape.reussi : _Etape.echoue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: switch (_etape) {
            _Etape.saisie => _buildSaisie(theme),
            _Etape.attente => _buildAttente(theme),
            _Etape.reussi || _Etape.echoue => _buildResultat(theme),
          },
        ),
      ),
    );
  }

  // ── Étape 1 : saisie ─────────────────────────────────────────

  Widget _buildSaisie(ThemeData theme) {
    return Column(
      key: const ValueKey('saisie'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Encaisser', style: theme.textTheme.titleLarge),
        const SizedBox(height: 2),
        Text('Reste à payer : ${_fmt.format(widget.solde)} FCFA',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: AppTheme.encreDouce)),
        const SizedBox(height: 18),
        TextField(
          controller: _montant,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(
              fontFamily: 'Outfit', fontSize: 26, fontWeight: FontWeight.w700),
          decoration: const InputDecoration(labelText: 'Montant', suffixText: 'FCFA'),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final pas in const [5000, 10000, 25000])
              ActionChip(
                label: Text('+${_fmt.format(pas)}'),
                onPressed: () {
                  final v = (_montantSaisi + pas).clamp(0, widget.solde);
                  setState(() => _montant.text = '$v');
                },
              ),
            ActionChip(
              label: const Text('Solde total'),
              onPressed: () => setState(() => _montant.text = '${widget.solde}'),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text('Mode de règlement', style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [for (final m in modesSaisie) _ChipMode(
            mode: m,
            selectionne: _mode == m,
            onTap: () => setState(() => _mode = m),
          )],
        ),
        if (_estMobile) ...[
          const SizedBox(height: 16),
          TextField(
            controller: _reference,
            decoration: const InputDecoration(
              labelText: 'Référence de la transaction',
              prefixIcon: Icon(Icons.tag_rounded),
              helperText: "Facultatif : l'identifiant du SMS ou du relevé.",
            ),
          ),
        ],
        if (_erreur != null) ...[
          const SizedBox(height: 14),
          _Bandeau(texte: _erreur!, couleur: AppTheme.brique),
        ],
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: _valider,
          icon: Icon(_estMobile ? Icons.hourglass_top_rounded : Icons.check_rounded),
          label: Text(_estMobile
              ? 'Enregistrer le paiement ${libelleMode(_mode)}'
              : 'Encaisser ${_montantSaisi > 0 ? '${_fmt.format(_montantSaisi)} FCFA' : ''}'),
        ),
      ],
    );
  }

  // ── Étape 3 : attente de validation par le client ────────────

  Widget _buildAttente(ThemeData theme) {
    final p = _paiement!;
    final (fond, encre) = teinteMode(_mode);
    return Column(
      key: const ValueKey('attente'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Center(
          child: CircleAvatar(
            radius: 34,
            backgroundColor: fond,
            child: Icon(Icons.phonelink_ring_rounded, color: encre, size: 32),
          ),
        ),
        const SizedBox(height: 14),
        Text('${_fmt.format(p.montant)} FCFA',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text(
          'Paiement ${libelleMode(_mode)} en attente',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        if (p.reference?.isNotEmpty == true)
          Text('Réf. ${p.reference}',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.encreDouce)),
        const SizedBox(height: 16),
        const _Bandeau(
          texte: "Vérifiez que l'argent est bien arrivé avant de confirmer.\n"
              'Le serveur est informé à la prochaine synchronisation.',
          couleur: AppTheme.ocre,
          icone: Icons.hourglass_top_rounded,
        ),
        if (_erreur != null) ...[
          const SizedBox(height: 10),
          _Bandeau(texte: _erreur!, couleur: AppTheme.brique),
        ],
        const SizedBox(height: 18),
        FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: AppTheme.emeraude),
          onPressed: () => _conclure(true),
          icon: const Icon(Icons.check_circle_outline_rounded),
          label: const Text('Argent reçu'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(foregroundColor: AppTheme.brique),
          onPressed: () => _conclure(false),
          icon: const Icon(Icons.cancel_outlined),
          label: const Text('Paiement non reçu'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Fermer (le paiement reste en attente)'),
        ),
      ],
    );
  }

  // ── Étape 4 : résultat ───────────────────────────────────────

  Widget _buildResultat(ThemeData theme) {
    final ok = _etape == _Etape.reussi;
    return Column(
      key: const ValueKey('resultat'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Icon(ok ? Icons.check_circle_rounded : Icons.error_rounded,
            size: 64, color: ok ? AppTheme.emeraude : AppTheme.brique),
        const SizedBox(height: 12),
        Text(ok ? 'Paiement reçu' : 'Paiement échoué',
            textAlign: TextAlign.center, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(
          ok
              ? '${_fmt.format(_paiement!.montant)} FCFA encaissés via ${libelleMode(_mode)}.'
              : 'Paiement marqué comme non reçu. Aucun montant encaissé.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: AppTheme.encreDouce),
        ),
        const SizedBox(height: 22),
        if (ok)
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Terminer'),
          )
        else ...[
          FilledButton(
            onPressed: () => setState(() {
              _etape = _Etape.saisie;
              _paiement = null;
            }),
            child: const Text('Réessayer'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Fermer'),
          ),
        ],
      ],
    );
  }
}

class _ChipMode extends StatelessWidget {
  const _ChipMode({required this.mode, required this.selectionne, required this.onTap});

  final ModePaiement mode;
  final bool selectionne;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (fond, encre) = teinteMode(mode);
    return Material(
      color: selectionne ? fond : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(color: selectionne ? encre : AppTheme.filet, width: selectionne ? 1.6 : 1),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(iconeMode(mode), size: 18, color: encre),
                const SizedBox(width: 6),
                Text(libelleMode(mode),
                    style: TextStyle(
                      fontWeight: selectionne ? FontWeight.w700 : FontWeight.w500,
                      color: selectionne ? encre : AppTheme.encre,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Bandeau extends StatelessWidget {
  const _Bandeau({required this.texte, required this.couleur, this.icone});

  final String texte;
  final Color couleur;
  final IconData? icone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: couleur.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone ?? Icons.info_outline_rounded, size: 18, color: couleur),
          const SizedBox(width: 8),
          Expanded(
            child: Text(texte,
                style: TextStyle(fontSize: 13, color: couleur, height: 1.35)),
          ),
        ],
      ),
    );
  }
}
