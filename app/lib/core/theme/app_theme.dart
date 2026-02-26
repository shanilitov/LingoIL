import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.learningPrimary,
        primary: AppColors.learningPrimary,
        secondary: AppColors.motivationAccent,
        surface: AppColors.neutral50,
      ),
      scaffoldBackgroundColor: AppColors.neutral50,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.neutral50,
        foregroundColor: AppColors.neutral900,
        centerTitle: true,
      ),
      textTheme: base.textTheme.copyWith(
        headlineSmall: const TextStyle(
          fontWeight: FontWeight.w800,
          color: AppColors.neutral900,
          height: 1.2,
        ),
        titleMedium: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.neutral900,
          height: 1.3,
        ),
        bodyLarge: const TextStyle(
          color: AppColors.neutral900,
          height: 1.45,
        ),
        bodyMedium: const TextStyle(
          color: AppColors.neutral700,
          height: 1.4,
        ),
        labelLarge: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.neutral0,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.neutral0,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.neutral200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.neutral200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.learningPrimary, width: 1.4),
        ),
        hintStyle: const TextStyle(color: AppColors.neutral500),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        side: const BorderSide(color: AppColors.neutral200),
        backgroundColor: AppColors.neutral0,
        selectedColor: AppColors.learningPrimary.withValues(alpha: 0.18),
        labelStyle: const TextStyle(color: AppColors.neutral900, fontWeight: FontWeight.w600),
      ),
      dividerColor: AppColors.neutral200,
    );
  }
}
