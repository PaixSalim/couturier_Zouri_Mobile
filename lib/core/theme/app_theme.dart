import 'package:flutter/material.dart';

/// Palette « atelier » : terracotta chaud, lin écru, sauge/émeraude.
/// Les formes sont franches (rayons 12-20) et les surfaces douces pour
/// évoquer le papier de soie et les tissus naturels.
class AppTheme {
  static const Color terracotta = Color(0xFFC05621);
  static const Color terracottaDark = Color(0xFF9F3E07);
  static const Color emeraude = Color(0xFF065F46);
  static const Color emeraudeSoft = Color(0xFFCCF1E8);
  static const Color lin = Color(0xFFFBF7F1);
  static const Color ecru = Color(0xFFF3EBDF);
  static const Color encre = Color(0xFF2B211B);
  static const Color encreDouce = Color(0xFF57504A);
  static const Color filet = Color(0xFFE8DFD3);
  static const Color ocre = Color(0xFFD97706);
  static const Color brique = Color(0xFFB4302B);

  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: terracotta,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFFDE7D8),
      onPrimaryContainer: Color(0xFF6E2A03),
      secondary: emeraude,
      onSecondary: Colors.white,
      secondaryContainer: emeraudeSoft,
      onSecondaryContainer: Color(0xFF064E42),
      tertiary: ocre,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFFEF0D4),
      onTertiaryContainer: Color(0xFF6B4400),
      error: brique,
      onError: Colors.white,
      errorContainer: Color(0xFFFBE4E2),
      onErrorContainer: Color(0xFF6F1D18),
      surface: lin,
      onSurface: encre,
      onSurfaceVariant: encreDouce,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: Color(0xFFFFFDFA),
      surfaceContainer: ecru,
      surfaceContainerHigh: Color(0xFFEFE6D8),
      surfaceContainerHighest: Color(0xFFE9DECD),
      outline: Color(0xFFC4B6A5),
      outlineVariant: filet,
      shadow: Color(0x1A2B211B),
      inverseSurface: Color(0xFF39312A),
      onInverseSurface: Color(0xFFFBF7F1),
      inversePrimary: Color(0xFFFFB68A),
      surfaceTint: terracotta,
    );

    final base = ThemeData.light().textTheme.apply(
          fontFamily: 'Inter',
          bodyColor: encre,
          displayColor: encre,
        );

    final textTheme = base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontFamily: 'Outfit',
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontFamily: 'Outfit',
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontFamily: 'Outfit',
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontFamily: 'Outfit',
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontFamily: 'Outfit',
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontFamily: 'Outfit',
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontFamily: 'Outfit',
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontFamily: 'Outfit',
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontFamily: 'Outfit',
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: base.bodyLarge?.copyWith(height: 1.45),
      bodyMedium: base.bodyMedium?.copyWith(height: 1.45),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      labelSmall: base.labelSmall?.copyWith(letterSpacing: 0.6),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'Inter',
      textTheme: textTheme,
      scaffoldBackgroundColor: lin,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: lin,
        foregroundColor: encre,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleSpacing: 16,
        iconTheme: IconThemeData(color: encre),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: filet),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: filet,
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: terracotta,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: encre,
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          side: const BorderSide(color: Color(0xFFD8CBBA), width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: terracotta,
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: terracotta,
        foregroundColor: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        hintStyle: const TextStyle(color: Color(0xFF9C8F80), fontSize: 14),
        labelStyle: const TextStyle(color: encreDouce, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: filet),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: filet),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: terracotta, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: brique),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: brique, width: 1.6),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: ecru,
        selectedColor: const Color(0xFFFDE7D8),
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: encre,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: const Color(0xFFFDE7D8),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? terracotta : encreDouce,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: selected ? terracotta : const Color(0xFF8C8177),
          );
        }),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: lin,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: lin,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: encre,
        contentTextStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: encreDouce,
        textColor: encre,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: terracotta,
        linearTrackColor: ecru,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? Colors.white : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? terracotta : null,
        ),
      ),
    );
  }
}
