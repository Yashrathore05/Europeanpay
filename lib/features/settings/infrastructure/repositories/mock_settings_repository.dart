import '../../domain/models/settings_model.dart';
import '../../domain/repositories/settings_repository.dart';

class MockSettingsRepository implements SettingsRepository {
  MockSettingsRepository();

  SettingsModel _settings = const SettingsModel(
    biometricsEnabled: true,
    pushNotificationsEnabled: true,
    emailNotificationsEnabled: true,
    smsNotificationsEnabled: false,
    language: 'en',
    primaryCurrency: 'EUR',
    timezone: 'CET',
  );

  @override
  Future<SettingsModel> getSettings() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _settings;
  }

  @override
  Future<void> updateSettings(SettingsModel settings) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _settings = settings;
  }
}
