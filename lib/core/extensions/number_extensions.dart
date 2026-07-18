import 'package:intl/intl.dart';

/// Number extension methods for European Pay.
extension NumberExtensions on num {
  /// Format as EUR currency: €1,234.56
  String get toEur => '€${NumberFormat('#,##0.00', 'en_US').format(this)}';

  /// Format as EUR without cents: €1,234
  String get toEurCompact => '€${NumberFormat('#,##0', 'en_US').format(this)}';

  /// Format as points: 1,234 pts
  String get toPoints =>
      '${NumberFormat('#,##0', 'en_US').format(this)} pts';

  /// Format as compact number: 1.2K, 3.4M
  String get toCompact => NumberFormat.compact().format(this);

  /// Format with thousand separators
  String get formatted => NumberFormat('#,##0', 'en_US').format(this);

  /// Format with decimal places
  String toDecimal(int places) =>
      NumberFormat('#,##0.${'0' * places}', 'en_US').format(this);

  /// Convert points to EUR value
  double get pointsToEur => (this * 0.01).toDouble();
}
