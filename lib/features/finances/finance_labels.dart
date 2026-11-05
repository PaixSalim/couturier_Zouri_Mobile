import 'package:flutter/material.dart';

import '../../core/database/tables.dart';
import '../../core/sync/correspondances.dart';

/// Libellés, icônes et teintes partagés par les écrans Finances / Paiement.
/// Les codes « snake_case » sont ceux de l'API Django.

/// Modes proposés à la saisie : ceux de l'API.
const modesSaisie = ModePaiement.values;

/// Code API du mode (`cash`, `orange_money`, `bank_transfer`…).
String codeMode(ModePaiement m) => methodeVersApi(m);

ModePaiement modeDepuisCode(String? code) => methodeDepuisApi(code);

String libelleMode(ModePaiement m) => switch (m) {
      ModePaiement.especes => 'Espèces',
      ModePaiement.orangeMoney => 'Orange Money',
      ModePaiement.moovMoney => 'Moov Money',
      ModePaiement.virement => 'Virement',
      ModePaiement.carte => 'Carte',
      ModePaiement.autre => 'Autre',
    };

IconData iconeMode(ModePaiement m) => switch (m) {
      ModePaiement.especes => Icons.payments_outlined,
      ModePaiement.orangeMoney || ModePaiement.moovMoney => Icons.phone_iphone_rounded,
      ModePaiement.virement => Icons.account_balance_outlined,
      ModePaiement.carte => Icons.credit_card_rounded,
      ModePaiement.autre => Icons.more_horiz_rounded,
    };

/// (fond, encre) de la pastille d'un mode de paiement.
(Color, Color) teinteMode(ModePaiement m) => switch (m) {
      ModePaiement.especes => (const Color(0xFFD1FAE5), const Color(0xFF065F46)),
      ModePaiement.orangeMoney => (const Color(0xFFFFEDD5), const Color(0xFFC2410C)),
      ModePaiement.moovMoney => (const Color(0xFFDBEAFE), const Color(0xFF1D4ED8)),
      ModePaiement.virement => (const Color(0xFFE0F2FE), const Color(0xFF0369A1)),
      ModePaiement.carte => (const Color(0xFFEDE9FE), const Color(0xFF6D28D9)),
      ModePaiement.autre => (const Color(0xFFF5EFEB), const Color(0xFF57504A)),
    };
