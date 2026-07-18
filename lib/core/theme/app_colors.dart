import 'package:flutter/material.dart';

/// European Pay color system.
/// Designed for a premium fintech application with a clean, trustworthy palette.
abstract final class AppColors {
  // ── Brand Primary ──────────────────────────────────────────────
  static const Color ink = Color(0xFF07111F);
  static const Color brandLine = Color(0xFF1B2A41);
  static const Color primary = Color(0xFF10233F);
  static const Color primaryLight = Color(0xFF28405F);
  static const Color primaryDark = Color(0xFF07111F);
  static const Color primarySurface = Color(0xFFEFF4F8);

  // ── Brand Secondary ────────────────────────────────────────────
  static const Color secondary = Color(0xFF0F8B6F);
  static const Color secondaryLight = Color(0xFF38A98E);
  static const Color secondaryDark = Color(0xFF08654F);
  static const Color secondarySurface = Color(0xFFE8F5F1);

  // ── Neutrals ───────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF4F6F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFECEFF3);
  static const Color border = Color(0xFFD8DEE6);
  static const Color borderLight = Color(0xFFE8EDF2);
  static const Color divider = Color(0xFFE1E6EC);

  // ── Text ───────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF526070);
  static const Color textTertiary = Color(0xFF7C8998);
  static const Color textInverse = Color(0xFFFFFFFF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Semantic ───────────────────────────────────────────────────
  static const Color success = Color(0xFF087A5B);
  static const Color successLight = Color(0xFFE7F5F0);
  static const Color successDark = Color(0xFF055E45);

  static const Color warning = Color(0xFFB7791F);
  static const Color warningLight = Color(0xFFFFF6E6);
  static const Color warningDark = Color(0xFF8A5A14);

  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color errorDark = Color(0xFFC62828);

  static const Color info = Color(0xFF2B6CB0);
  static const Color infoLight = Color(0xFFE8F1FA);
  static const Color infoDark = Color(0xFF1A4F85);

  // ── Status ─────────────────────────────────────────────────────
  static const Color pending = Color(0xFFFFAA00);
  static const Color pendingBg = Color(0xFFFFF8E8);
  static const Color completed = Color(0xFF087A5B);
  static const Color completedBg = Color(0xFFE8F8F0);
  static const Color failed = Color(0xFFE53935);
  static const Color failedBg = Color(0xFFFFF0F0);
  static const Color rejected = Color(0xFFAB47BC);
  static const Color rejectedBg = Color(0xFFF8EFF9);
  static const Color expired = Color(0xFF78909C);
  static const Color expiredBg = Color(0xFFF2F4F5);

  // ── Loyalty / Points ───────────────────────────────────────────
  static const Color gold = Color(0xFFC8942E);
  static const Color goldLight = Color(0xFFFFF6DF);
  static const Color platinum = Color(0xFF90A4AE);
  static const Color platinumLight = Color(0xFFECEFF1);

  // ── Gradients ──────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10233F), Color(0xFF1E5B4F)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF07111F), Color(0xFF17324D)],
  );

  static const LinearGradient loyaltyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC8942E), Color(0xFF8B611B)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF087A5B), Color(0xFF0F8B6F)],
  );

  // ── Shimmer ────────────────────────────────────────────────────
  static const Color shimmerBase = Color(0xFFE8EAED);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // ── Overlay ────────────────────────────────────────────────────
  static const Color overlay = Color(0x80000000);
  static const Color scrim = Color(0x33000000);
}
