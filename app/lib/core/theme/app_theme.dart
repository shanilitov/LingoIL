import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_design.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.featherGreen,
        primary: AppColors.featherGreen,
        secondary: AppColors.bee,
        error: AppColors.cardinal,
        surface: AppColors.polar,
      ),
      scaffoldBackgroundColor: AppColors.polar,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.polar,
        foregroundColor: AppColors.eel,
        centerTitle: true,
      ),
      textTheme: base.textTheme.copyWith(
        displayLarge: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: AppColors.eel,
          height: 1.2,
        ),
        headlineSmall: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.eel,
          height: 1.2,
        ),
        titleLarge: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.eel,
          height: 1.3,
        ),
        titleMedium: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.eel,
          height: 1.3,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          color: AppColors.eel,
          height: 1.45,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: AppColors.wolf,
          height: 1.4,
        ),
        labelLarge: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 1.0,
        ),
        labelSmall: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.wolf,
          height: 1.0,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.snow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppDesign.borderRadiusXl,
          side: const BorderSide(color: AppColors.swan, width: AppDesign.cardBorderWidth),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.snow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDesign.spaceLg,
          vertical: AppDesign.spaceLg,
        ),
        border: OutlineInputBorder(
          borderRadius: AppDesign.borderRadiusLg,
          borderSide: const BorderSide(color: AppColors.swan, width: AppDesign.cardBorderWidth),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDesign.borderRadiusLg,
          borderSide: const BorderSide(color: AppColors.swan, width: AppDesign.cardBorderWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDesign.borderRadiusLg,
          borderSide: const BorderSide(color: AppColors.featherGreen, width: AppDesign.cardBorderWidth),
        ),
        hintStyle: const TextStyle(color: AppColors.hare),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: AppDesign.borderRadiusMd),
        side: const BorderSide(color: AppColors.swan, width: AppDesign.cardBorderWidth),
        backgroundColor: AppColors.snow,
        selectedColor: AppColors.featherGreen.withValues(alpha: 0.18),
        labelStyle: const TextStyle(color: AppColors.eel, fontWeight: FontWeight.w700),
      ),
      dividerColor: AppColors.swan,
    );
  }
}
