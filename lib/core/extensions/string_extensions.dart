/// String extension methods for European Pay.
extension StringExtensions on String {
  String get capitalize =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';

  String get capitalizeWords =>
      split(' ').map((word) => word.capitalize).join(' ');

  bool get isValidEmail =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);

  bool get isValidPhone =>
      RegExp(r'^\+?[1-9]\d{6,14}$').hasMatch(replaceAll(' ', ''));

  bool get isValidEuPayId =>
      RegExp(r'^EU[A-Z0-9]{8,12}$').hasMatch(toUpperCase());

  String get masked {
    if (length <= 4) return '••••';
    return '${'•' * (length - 4)}${substring(length - 4)}';
  }

  String get maskedEmail {
    final parts = split('@');
    if (parts.length != 2) return this;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return '••@$domain';
    return '${name[0]}${'•' * (name.length - 2)}${name[name.length - 1]}@$domain';
  }

  String get maskedPhone {
    final cleaned = replaceAll(' ', '');
    if (cleaned.length <= 4) return cleaned;
    return '${'•' * (cleaned.length - 4)}${cleaned.substring(cleaned.length - 4)}';
  }

  String get maskedIban {
    if (length <= 4) return this;
    return '${substring(0, 4)} •••• •••• ${substring(length - 4)}';
  }

  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  String get initials {
    final words = trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[words.length - 1][0]}'.toUpperCase();
  }
}
