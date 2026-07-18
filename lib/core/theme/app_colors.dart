import 'package:flutter/material.dart';

/// European Pay color system.
/// Designed for a premium fintech application with a clean, trustworthy palette.
abstract final class AppColors {
  // ── Brand Primary ──────────────────────────────────────────────
  static const Color primary = Color(0xFF1B4DFF);
  static const Color primaryLight = Color(0xFF4D7AFF);
  static const Color primaryDark = Color(0xFF0033CC);
  static const Color primarySurface = Color(0xFFEBF0FF);

  // ── Brand Secondary ────────────────────────────────────────────
  static const Color secondary = Color(0xFF00C2A8);
  static const Color secondaryLight = Color(0xFF33D4C0);
  static const Color secondaryDark = Color(0xFF009680);
  static const Color secondarySurface = Color(0xFFE6FAF6);

  // ── Neutrals ───────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F2F5);
  static const Color border = Color(0xFFE2E5EB);
  static const Color borderLight = Color(0xFFF0F2F5);
  static const Color divider = Color(0xFFE8EAED);

  // ── Text ───────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0F1419);
  static const Color textSecondary = Color(0xFF536471);
  static const Color textTertiary = Color(0xFF8899A6);
  static const Color textInverse = Color(0xFFFFFFFF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Semantic ───────────────────────────────────────────────────
  static const Color success = Color(0xFF00B67A);
  static const Color successLight = Color(0xFFE6F9F1);
  static const Color successDark = Color(0xFF008F5E);

  static const Color warning = Color(0xFFFFAA00);
  static const Color warningLight = Color(0xFFFFF5E0);
  static const Color warningDark = Color(0xFFCC8800);

  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color errorDark = Color(0xFFC62828);

  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFE3F2FD);
  static const Color infoDark = Color(0xFF1565C0);

  // ── Status ─────────────────────────────────────────────────────
  static const Color pending = Color(0xFFFFAA00);
  static const Color pendingBg = Color(0xFFFFF8E8);
  static const Color completed = Color(0xFF00B67A);
  static const Color completedBg = Color(0xFFE8F8F0);
  static const Color failed = Color(0xFFE53935);
  static const Color failedBg = Color(0xFFFFF0F0);
  static const Color rejected = Color(0xFFAB47BC);
  static const Color rejectedBg = Color(0xFFF8EFF9);
  static const Color expired = Color(0xFF78909C);
  static const Color expiredBg = Color(0xFFF2F4F5);

  // ── Loyalty / Points ───────────────────────────────────────────
  static const Color gold = Color(0xFFFFB300);
  static const Color goldLight = Color(0xFFFFF3CD);
  static const Color platinum = Color(0xFF90A4AE);
  static const Color platinumLight = Color(0xFFECEFF1);

  // ── Gradients ──────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B4DFF), Color(0xFF6366F1)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B4DFF), Color(0xFF0033CC)],
  );

  static const LinearGradient loyaltyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00B67A), Color(0xFF00897B)],
  );

  // ── Shimmer ────────────────────────────────────────────────────
  static const Color shimmerBase = Color(0xFFE8EAED);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // ── Overlay ────────────────────────────────────────────────────
  static const Color overlay = Color(0x80000000);
  static const Color scrim = Color(0x33000000);
}
