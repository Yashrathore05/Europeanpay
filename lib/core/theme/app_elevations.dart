import 'package:flutter/material.dart';

/// European Pay elevation system.
/// Subtle, modern elevation hierarchy for depth and layering.
abstract final class AppElevations {
  /// No elevation
  static const double none = 0;

  /// Subtle elevation for cards - 1dp
  static const double xs = 1;

  /// Default card elevation - 2dp
  static const double sm = 2;

  /// Raised components - 4dp
  static const double md = 4;

  /// Floating elements (FAB, dialogs) - 8dp
  static const double lg = 8;

  /// Modal / overlay elevation - 16dp
  static const double xl = 16;

  /// Top-level overlay - 24dp
  static const double xxl = 24;

  // ── Box Shadows ────────────────────────────────────────────────
  static const List<BoxShadow> shadowNone = [];

  static const List<BoxShadow> shadowXs = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x05000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x05000000),
      blurRadius: 3,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> shadowXl = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      offset: Offset(0, 6),
    ),
  ];

  /// Primary-tinted shadow for branded components
  static const List<BoxShadow> shadowPrimary = [
    BoxShadow(
      color: Color(0x331B4DFF),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x1A1B4DFF),
      blurRadius: 6,
      offset: Offset(0, 3),
    ),
  ];
}
