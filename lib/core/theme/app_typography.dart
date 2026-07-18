import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// European Pay typography system.
/// Uses Inter as the primary typeface for clean, modern fintech aesthetics.
abstract final class AppTypography {
  // ── Display ────────────────────────────────────────────────────
  static TextStyle displayLarge = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.5,
  );

  static TextStyle displayMedium = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.29,
    letterSpacing: -0.3,
  );

  static TextStyle displaySmall = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: -0.2,
  );

  // ── Headline ───────────────────────────────────────────────────
  static TextStyle headlineLarge = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.36,
  );

  static TextStyle headlineMedium = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle headlineSmall = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.44,
  );

  // ── Title ──────────────────────────────────────────────────────
  static TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.41,
  );

  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.1,
  );

  static TextStyle titleSmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
  );

  // ── Body ───────────────────────────────────────────────────────
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.15,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.2,
  );

  // ── Label ──────────────────────────────────────────────────────
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.3,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0.4,
  );

  // ── Special ────────────────────────────────────────────────────
  static TextStyle amount = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle amountSmall = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.3,
  );

  static TextStyle amountLarge = GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.5,
  );

  static TextStyle pin = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 8,
  );

  static TextStyle otp = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 4,
  );

  static TextStyle button = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0.2,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.45,
    letterSpacing: 0.3,
  );

  static TextStyle overline = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.6,
    letterSpacing: 1.0,
  );
}
