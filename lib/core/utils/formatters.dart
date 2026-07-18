import 'package:intl/intl.dart';

/// Formatters utility for European Pay.
abstract final class Formatters {
  static String currency(double amount, {String symbol = '€'}) {
    return '$symbol${NumberFormat('#,##0.00', 'en_US').format(amount)}';
  }

  static String currencyCompact(double amount, {String symbol = '€'}) {
    if (amount >= 1000000) {
      return '$symbol${(amount / 1000000).toStringAsFixed(1)}M';
    }
    if (amount >= 1000) {
      return '$symbol${(amount / 1000).toStringAsFixed(1)}K';
    }
    return currency(amount, symbol: symbol);
  }

  static String points(int points) {
    return '${NumberFormat('#,##0').format(points)} pts';
  }

  static String pointsToEur(int points) {
    final eurValue = points * 0.01;
    return currency(eurValue);
  }

  static String percentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  static String distance(double meters) {
    if (meters < 1000) return '${meters.toInt()}m';
    return '${(meters / 1000).toStringAsFixed(1)}km';
  }

  static String phoneNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.length >= 12) {
      return '${cleaned.substring(0, 3)} ${cleaned.substring(3, 5)} ${cleaned.substring(5, 7)} ${cleaned.substring(7, 9)} ${cleaned.substring(9)}';
    }
    return cleaned;
  }

  static String ibanFormat(String iban) {
    final cleaned = iban.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < cleaned.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(cleaned[i]);
    }
    return buffer.toString();
  }

  static String transactionId(String id) {
    if (id.length <= 8) return id.toUpperCase();
    return '${id.substring(0, 4)}...${id.substring(id.length - 4)}'.toUpperCase();
  }

  static String duration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
