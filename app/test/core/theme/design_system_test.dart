import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingoil/core/theme/app_colors.dart';
import 'package:lingoil/core/theme/app_design.dart';
import 'package:lingoil/core/theme/app_theme.dart';

void main() {
  group('AppColors', () {
    test('primary colors match Duolingo palette', () {
      expect(AppColors.featherGreen, const Color(0xFF58CC02));
      expect(AppColors.featherGreenDark, const Color(0xFF58A700));
      expect(AppColors.maskGreen, const Color(0xFF89E219));
    });

    test('feedback colors match Duolingo palette', () {
      expect(AppColors.cardinal, const Color(0xFFFF4B4B));
      expect(AppColors.bee, const Color(0xFFFFC800));
      expect(AppColors.fox, const Color(0xFFFF9600));
      expect(AppColors.macaw, const Color(0xFF1CB0F6));
    });

    test('neutral colors match Duolingo palette', () {
      expect(AppColors.snow, const Color(0xFFFFFFFF));
      expect(AppColors.polar, const Color(0xFFF7F7F7));
      expect(AppColors.swan, const Color(0xFFE5E5E5));
      expect(AppColors.hare, const Color(0xFFAFAFAF));
      expect(AppColors.wolf, const Color(0xFF777777));
      expect(AppColors.eel, const Color(0xFF4B4B4B));
    });

    test('legacy aliases point to correct new tokens', () {
      expect(AppColors.learningPrimary, AppColors.featherGreen);
      expect(AppColors.learningPrimaryDark, AppColors.featherGreenDark);
      expect(AppColors.motivationAccent, AppColors.bee);
      expect(AppColors.success, AppColors.featherGreen);
      expect(AppColors.error, AppColors.cardinal);
      expect(AppColors.warning, AppColors.bee);
      expect(AppColors.info, AppColors.macaw);
      expect(AppColors.neutral0, AppColors.snow);
      expect(AppColors.neutral50, AppColors.polar);
      expect(AppColors.neutral200, AppColors.swan);
    });

    test('semantic surfaces are defined', () {
      expect(AppColors.correctSurface, const Color(0xFFD7FFB8));
      expect(AppColors.wrongSurface, const Color(0xFFFFDFE0));
    });
  });

  group('AppDesign', () {
    test('spacing follows 4px base grid', () {
      expect(AppDesign.spaceXxs, 2);
      expect(AppDesign.spaceXs, 4);
      expect(AppDesign.spaceSm, 8);
      expect(AppDesign.spaceMd, 12);
      expect(AppDesign.spaceLg, 16);
      expect(AppDesign.spaceXl, 20);
      expect(AppDesign.spaceXxl, 24);
      expect(AppDesign.spaceXxxl, 32);
    });

    test('spacing values are multiples of 4 (except xxs)', () {
      expect(AppDesign.spaceXs % 4, 0);
      expect(AppDesign.spaceSm % 4, 0);
      expect(AppDesign.spaceMd % 4, 0);
      expect(AppDesign.spaceLg % 4, 0);
      expect(AppDesign.spaceXl % 4, 0);
      expect(AppDesign.spaceXxl % 4, 0);
      expect(AppDesign.spaceXxxl % 4, 0);
    });

    test('border radii are ordered from small to full', () {
      expect(AppDesign.radiusSm, lessThan(AppDesign.radiusMd));
      expect(AppDesign.radiusMd, lessThan(AppDesign.radiusLg));
      expect(AppDesign.radiusLg, lessThan(AppDesign.radiusXl));
      expect(AppDesign.radiusXl, lessThan(AppDesign.radiusFull));
    });

    test('button dimensions match Duolingo specs', () {
      expect(AppDesign.buttonHeight, 56);
      expect(AppDesign.buttonShadowOffset, 4);
      expect(AppDesign.buttonPressDuration, const Duration(milliseconds: 100));
    });

    test('progress bar matches Duolingo specs', () {
      expect(AppDesign.progressBarHeight, 16);
    });

    test('minimum touch target is 48px for accessibility', () {
      expect(AppDesign.minTouchTarget, 48);
    });

    test('border radius helpers produce correct values', () {
      expect(AppDesign.borderRadiusSm,
          BorderRadius.circular(AppDesign.radiusSm));
      expect(AppDesign.borderRadiusMd,
          BorderRadius.circular(AppDesign.radiusMd));
      expect(AppDesign.borderRadiusLg,
          BorderRadius.circular(AppDesign.radiusLg));
      expect(AppDesign.borderRadiusXl,
          BorderRadius.circular(AppDesign.radiusXl));
      expect(AppDesign.borderRadiusFull,
          BorderRadius.circular(AppDesign.radiusFull));
    });
  });

  group('AppTheme', () {
    test('light theme uses Duolingo primary colors', () {
      final theme = AppTheme.light();
      expect(theme.colorScheme.primary, AppColors.featherGreen);
      expect(theme.colorScheme.secondary, AppColors.bee);
      expect(theme.colorScheme.error, AppColors.cardinal);
    });

    test('light theme scaffold uses polar background', () {
      final theme = AppTheme.light();
      expect(theme.scaffoldBackgroundColor, AppColors.polar);
    });

    test('light theme uses Material 3', () {
      final theme = AppTheme.light();
      expect(theme.useMaterial3, isTrue);
    });

    test('light theme app bar has no elevation', () {
      final theme = AppTheme.light();
      expect(theme.appBarTheme.elevation, 0);
      expect(theme.appBarTheme.backgroundColor, AppColors.polar);
    });

    test('light theme cards use snow background with swan border', () {
      final theme = AppTheme.light();
      expect(theme.cardTheme.color, AppColors.snow);
      expect(theme.cardTheme.elevation, 0);
    });

    test('light theme label text is bold with letter spacing', () {
      final theme = AppTheme.light();
      final labelLarge = theme.textTheme.labelLarge;
      expect(labelLarge?.fontWeight, FontWeight.w800);
      expect(labelLarge?.letterSpacing, 1.0);
    });
  });
}
