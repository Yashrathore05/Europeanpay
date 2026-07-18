import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

/// General helper utilities for European Pay.
abstract final class Helpers {
  static const _uuid = Uuid();

  /// Generate a unique ID
  static String generateId() => _uuid.v4();

  /// Generate a mock EU Pay ID
  static String generateEuPayId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final buffer = StringBuffer('EU');
    for (int i = 0; i < 10; i++) {
      buffer.write(chars[(DateTime.now().microsecond + i * 7) % chars.length]);
    }
    return buffer.toString();
  }

  /// Generate a mock transaction reference
  static String generateTxnRef() {
    return 'TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
  }

  /// Copy text to clipboard
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  /// Delay helper for animations and mock API calls
  static Future<void> delay([int ms = 300]) async {
    await Future.delayed(Duration(milliseconds: ms));
  }

  /// Simulate API latency for mock repositories
  static Future<T> simulateApiCall<T>(T result, {int delayMs = 800}) async {
    await Future.delayed(Duration(milliseconds: delayMs));
    return result;
  }
}
