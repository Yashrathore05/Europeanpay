import 'package:flutter/material.dart';

/// European Pay color system.
/// Designed for a premium fintech application with a clean, trustworthy palette.
abstract final class AppColors {
  // ── Brand Primary ──────────────────────────────────────────────
  static const Color ink = Color(0xFF09090B);
  static const Color brandLine = Color(0xFF27272A);
  static const Color primary = Color(0xFF3B82F6);
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primarySurface = Color(0x1A3B82F6); // 10% opacity blue

  // ── Brand Secondary ────────────────────────────────────────────
  static const Color secondary = Color(0xFF10B981);
  static const Color secondaryLight = Color(0xFF34D399);
  static const Color secondaryDark = Color(0xFF047857);
  static const Color secondarySurface = Color(0x1A10B981); // 10% opacity green

  // ── Neutrals ───────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFF09090B);
  static const Color surface = Color(0xFF121214);
  static const Color surfaceVariant = Color(0xFF1A1A1E); // Level 2 surfaces/modal/inputs
  static const Color border = Color(0xFF27272A);
  static const Color borderLight = Color(0xFF27272A);
  static const Color divider = Color(0xFF27272A);

  // ── Text ───────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF4F4F5);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textTertiary = Color(0xFF71717A);
  static const Color textInverse = Color(0xFF09090B);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Semantic ───────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0x1A10B981);
  static const Color successDark = Color(0xFF047857);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0x1AF59E0B);
  static const Color warningDark = Color(0xFFB45309);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0x1AEF4444);
  static const Color errorDark = Color(0xFFB91C1C);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0x1A3B82F6);
  static const Color infoDark = Color(0xFF1D4ED8);

  // ── Status ─────────────────────────────────────────────────────
  static const Color pending = Color(0xFFF59E0B);
  static const Color pendingBg = Color(0x1AF59E0B);
  static const Color completed = Color(0xFF10B981);
  static const Color completedBg = Color(0x1A10B981);
  static const Color failed = Color(0xFFEF4444);
  static const Color failedBg = Color(0x1AEF4444);
  static const Color rejected = Color(0xFFEC4899);
  static const Color rejectedBg = Color(0x1AEC4899);
  static const Color expired = Color(0xFF71717A);
  static const Color expiredBg = Color(0x1A71717A);

  // ── Loyalty / Points ───────────────────────────────────────────
  static const Color gold = Color(0xFFF59E0B);
  static const Color goldLight = Color(0x1AF59E0B);
  static const Color platinum = Color(0xFF94A3B8);
  static const Color platinumLight = Color(0x1A94A3B8);

  // ── Gradients ──────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF09090B), Color(0xFF1E3A8A)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF121214), Color(0xFF1E293B)],
  );

  static const LinearGradient loyaltyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB45309), Color(0xFF78350F)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF047857), Color(0xFF065F46)],
  );

  // ── Shimmer ────────────────────────────────────────────────────
  static const Color shimmerBase = Color(0xFF1A1A1E);
  static const Color shimmerHighlight = Color(0xFF27272A);

  // ── Overlay ────────────────────────────────────────────────────
  static const Color overlay = Color(0x80000000);
  static const Color scrim = Color(0x33000000);
}
