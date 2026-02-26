import 'package:flutter/material.dart';

/// Duolingo-inspired design tokens for consistent spacing, radius & elevation.
/// See docs/design-guide.md for the full design guide.
class AppDesign {
  // ── Spacing (4px base grid) ────────────────────────────────
  static const double spaceXxs = 2;
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 12;
  static const double spaceLg = 16;
  static const double spaceXl = 20;
  static const double spaceXxl = 24;
  static const double spaceXxxl = 32;

  // ── Border Radius ──────────────────────────────────────────
  static const double radiusSm = 8;
  static const double radiusMd = 13;
  static const double radiusLg = 16;
  static const double radiusXl = 22;
  static const double radiusFull = 999;

  // ── Button ─────────────────────────────────────────────────
  static const double buttonHeight = 56;
  static const double buttonShadowOffset = 4;
  static const Duration buttonPressDuration = Duration(milliseconds: 100);

  // ── Progress Bar ───────────────────────────────────────────
  static const double progressBarHeight = 16;
  static const Duration progressAnimationDuration = Duration(milliseconds: 300);

  // ── Feedback Banner ────────────────────────────────────────
  static const double bannerBorderWidth = 2;
  static const Duration bannerAppearDuration = Duration(milliseconds: 200);

  // ── Card ───────────────────────────────────────────────────
  static const double cardBorderWidth = 2;
  static const double cardPadding = 16;

  // ── Touch Target ───────────────────────────────────────────
  static const double minTouchTarget = 48;

  // ── Animation Durations ────────────────────────────────────
  static const Duration cardTransitionDuration = Duration(milliseconds: 250);
  static const Duration xpCounterDuration = Duration(milliseconds: 400);

  // ── Helpers ────────────────────────────────────────────────
  static BorderRadius borderRadiusSm = BorderRadius.circular(radiusSm);
  static BorderRadius borderRadiusMd = BorderRadius.circular(radiusMd);
  static BorderRadius borderRadiusLg = BorderRadius.circular(radiusLg);
  static BorderRadius borderRadiusXl = BorderRadius.circular(radiusXl);
  static BorderRadius borderRadiusFull = BorderRadius.circular(radiusFull);
}
