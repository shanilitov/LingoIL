import 'package:flutter/material.dart';

/// LingoIL color palette — inspired by Duolingo's design system.
/// See docs/design-guide.md for full usage rules.
class AppColors {
  // ── Primary (Duolingo "Feather Green") ─────────────────────
  static const Color featherGreen = Color(0xFF58CC02);
  static const Color featherGreenDark = Color(0xFF58A700);
  static const Color maskGreen = Color(0xFF89E219);

  /// Legacy aliases – keep existing references working.
  static const Color learningPrimary = featherGreen;
  static const Color learningPrimaryDark = featherGreenDark;

  // ── Feedback / Accent ──────────────────────────────────────
  static const Color cardinal = Color(0xFFFF4B4B);
  static const Color cardinalDark = Color(0xFFEA2B2B);
  static const Color bee = Color(0xFFFFC800);
  static const Color beeDark = Color(0xFFE5A000);
  static const Color fox = Color(0xFFFF9600);
  static const Color macaw = Color(0xFF1CB0F6);
  static const Color macawDark = Color(0xFF1899D6);

  /// Legacy aliases
  static const Color motivationAccent = bee;
  static const Color success = featherGreen;
  static const Color error = cardinal;
  static const Color warning = bee;
  static const Color info = macaw;

  // ── Neutrals (Duolingo naming) ─────────────────────────────
  static const Color snow = Color(0xFFFFFFFF);
  static const Color polar = Color(0xFFF7F7F7);
  static const Color swan = Color(0xFFE5E5E5);
  static const Color hare = Color(0xFFAFAFAF);
  static const Color wolf = Color(0xFF777777);
  static const Color eel = Color(0xFF4B4B4B);

  /// Legacy neutral aliases
  static const Color neutral0 = snow;
  static const Color neutral50 = polar;
  static const Color neutral100 = Color(0xFFF1F5F9);
  static const Color neutral200 = swan;
  static const Color neutral300 = hare;
  static const Color neutral500 = wolf;
  static const Color neutral700 = eel;
  static const Color neutral900 = Color(0xFF3C3C3C);

  // ── Semantic surfaces ──────────────────────────────────────
  static const Color correctSurface = Color(0xFFD7FFB8);
  static const Color wrongSurface = Color(0xFFFFDFE0);
}
