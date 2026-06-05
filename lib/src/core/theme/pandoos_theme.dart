import 'package:flutter/material.dart';
import 'pandoos_colors.dart';
import 'pandoos_typography.dart';

class PandoosTheme {
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: PandoosColors.background,
      colorScheme: const ColorScheme.dark(
        primary:     PandoosColors.primary,
        secondary:   PandoosColors.accent,
        surface:     PandoosColors.surface,
        error:       PandoosColors.error,
      ),

      // App bar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: PandoosTypography.h1,
        iconTheme: const IconThemeData(color: PandoosColors.textPrimary),
      ),

      // Bottom nav
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: PandoosColors.surface,
        selectedItemColor: PandoosColors.primary,
        unselectedItemColor: PandoosColors.textMuted,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),

      // Navigation bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: PandoosColors.surface,
        indicatorColor: PandoosColors.primaryGlow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return PandoosTypography.labelSmall.copyWith(
              color: PandoosColors.primary,
            );
          }
          return PandoosTypography.labelSmall;
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: PandoosColors.primary, size: 22);
          }
          return const IconThemeData(color: PandoosColors.textMuted, size: 22);
        }),
      ),

      // Text
      textTheme: TextTheme(
        displayLarge:  PandoosTypography.display1,
        displayMedium: PandoosTypography.display2,
        headlineLarge: PandoosTypography.h1,
        headlineMedium:PandoosTypography.h2,
        headlineSmall: PandoosTypography.h3,
        bodyLarge:     PandoosTypography.bodyLarge,
        bodyMedium:    PandoosTypography.bodyMedium,
        bodySmall:     PandoosTypography.bodySmall,
        labelLarge:    PandoosTypography.labelLarge,
        labelSmall:    PandoosTypography.labelSmall,
      ),

      // Input / Search
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PandoosColors.surfaceHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: PandoosColors.primary, width: 1.5),
        ),
        hintStyle: PandoosTypography.bodyMedium,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        prefixIconColor: PandoosColors.textMuted,
      ),

      // Slider (seek bar)
      sliderTheme: const SliderThemeData(
        activeTrackColor:   PandoosColors.primary,
        inactiveTrackColor: PandoosColors.textMuted,
        thumbColor:         PandoosColors.primary,
        overlayColor:       PandoosColors.primaryGlow,
        trackHeight: 3,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
      ),

      // Icon
      iconTheme: const IconThemeData(color: PandoosColors.textSecondary, size: 22),
    );
  }
}
