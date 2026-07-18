class SettingsModel {
  const SettingsModel({
    required this.biometricsEnabled,
    required this.pushNotificationsEnabled,
    required this.emailNotificationsEnabled,
    required this.smsNotificationsEnabled,
    required this.language,
    required this.primaryCurrency,
    required this.timezone,
  });

  final bool biometricsEnabled;
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool smsNotificationsEnabled;
  final String language; // 'en', 'fr'
  final String primaryCurrency; // 'EUR', 'USD'
  final String timezone; // 'CET', 'GMT'

  SettingsModel copyWith({
    bool? biometricsEnabled,
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? smsNotificationsEnabled,
    String? language,
    String? primaryCurrency,
    String? timezone,
  }) {
    return SettingsModel(
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled: emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      smsNotificationsEnabled: smsNotificationsEnabled ?? this.smsNotificationsEnabled,
      language: language ?? this.language,
      primaryCurrency: primaryCurrency ?? this.primaryCurrency,
      timezone: timezone ?? this.timezone,
    );
  }
}
