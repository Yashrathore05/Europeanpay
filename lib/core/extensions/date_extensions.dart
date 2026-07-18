import 'package:intl/intl.dart';

/// DateTime extension methods for European Pay.
extension DateExtensions on DateTime {
  /// Format: Jan 15, 2025
  String get formatted => DateFormat('MMM d, y').format(this);

  /// Format: 15 Jan 2025
  String get formattedShort => DateFormat('d MMM y').format(this);

  /// Format: January 15, 2025
  String get formattedLong => DateFormat('MMMM d, y').format(this);

  /// Format: 15/01/2025
  String get formattedNumeric => DateFormat('dd/MM/y').format(this);

  /// Format: 14:30
  String get formattedTime => DateFormat('HH:mm').format(this);

  /// Format: 2:30 PM
  String get formattedTime12 => DateFormat('h:mm a').format(this);

  /// Format: Jan 15, 2025 at 14:30
  String get formattedDateTime => DateFormat('MMM d, y \'at\' HH:mm').format(this);

  /// Format: 15 Jan 14:30
  String get formattedCompact => DateFormat('d MMM HH:mm').format(this);

  /// Returns relative time string: "Just now", "5m ago", "2h ago", "Yesterday", etc.
  String get relative {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return formatted;
  }

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return isAfter(startOfWeek.subtract(const Duration(days: 1)));
  }

  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Group header: "Today", "Yesterday", "Jan 15, 2025"
  String get groupHeader {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    if (isThisWeek) return DateFormat('EEEE').format(this);
    return formatted;
  }
}
