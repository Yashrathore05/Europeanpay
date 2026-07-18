import '../constants/app_constants.dart';

/// Form validators for European Pay.
abstract final class Validators {
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? name(String? value, [String fieldName = 'Name']) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    if (value.trim().length < AppConstants.minNameLength) {
      return '$fieldName must be at least ${AppConstants.minNameLength} characters';
    }
    if (value.trim().length > AppConstants.maxNameLength) {
      return '$fieldName must be at most ${AppConstants.maxNameLength} characters';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    final cleaned = value.replaceAll(RegExp(r'[\s\-()]'), '');
    if (!RegExp(r'^\+?[1-9]\d{6,14}$').hasMatch(cleaned)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? otp(String? value) {
    if (value == null || value.isEmpty) return 'OTP is required';
    if (value.length != AppConstants.otpLength) {
      return 'OTP must be ${AppConstants.otpLength} digits';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'OTP must contain only digits';
    }
    return null;
  }

  static String? pin(String? value) {
    if (value == null || value.isEmpty) return 'PIN is required';
    if (value.length != AppConstants.pinLength) {
      return 'PIN must be ${AppConstants.pinLength} digits';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'PIN must contain only digits';
    }
    return null;
  }

  static String? amount(String? value, {double min = 0.01, double? max}) {
    if (value == null || value.trim().isEmpty) return 'Amount is required';
    final amount = double.tryParse(value.replaceAll(',', ''));
    if (amount == null) return 'Please enter a valid amount';
    if (amount < min) return 'Minimum amount is €${min.toStringAsFixed(2)}';
    if (max != null && amount > max) {
      return 'Maximum amount is €${max.toStringAsFixed(2)}';
    }
    return null;
  }

  static String? iban(String? value) {
    if (value == null || value.trim().isEmpty) return 'IBAN is required';
    final cleaned = value.replaceAll(' ', '').toUpperCase();
    if (cleaned.length < 15 || cleaned.length > 34) {
      return 'Please enter a valid IBAN';
    }
    if (!RegExp(r'^[A-Z]{2}\d{2}[A-Z0-9]+$').hasMatch(cleaned)) {
      return 'Please enter a valid IBAN format';
    }
    return null;
  }

  static String? euPayId(String? value) {
    if (value == null || value.trim().isEmpty) return 'EU Pay ID is required';
    if (!RegExp(r'^EU[A-Z0-9]{8,12}$').hasMatch(value.toUpperCase())) {
      return 'Please enter a valid EU Pay ID';
    }
    return null;
  }
}
