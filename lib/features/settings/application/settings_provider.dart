import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/settings_model.dart';
import '../domain/repositories/settings_repository.dart';
import '../infrastructure/repositories/mock_settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return MockSettingsRepository();
});

class SettingsNotifier extends StateNotifier<AsyncValue<SettingsModel>> {
  SettingsNotifier(this._repository) : super(const AsyncValue.loading()) {
    load();
  }

  final SettingsRepository _repository;

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getSettings();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateBiometrics(bool enabled) async {
    final current = state.value;
    if (current == null) return;
    final updated = current.copyWith(biometricsEnabled: enabled);
    state = AsyncValue.data(updated);
    await _repository.updateSettings(updated);
  }

  Future<void> updatePush(bool enabled) async {
    final current = state.value;
    if (current == null) return;
    final updated = current.copyWith(pushNotificationsEnabled: enabled);
    state = AsyncValue.data(updated);
    await _repository.updateSettings(updated);
  }

  Future<void> updateEmail(bool enabled) async {
    final current = state.value;
    if (current == null) return;
    final updated = current.copyWith(emailNotificationsEnabled: enabled);
    state = AsyncValue.data(updated);
    await _repository.updateSettings(updated);
  }

  Future<void> updateSms(bool enabled) async {
    final current = state.value;
    if (current == null) return;
    final updated = current.copyWith(smsNotificationsEnabled: enabled);
    state = AsyncValue.data(updated);
    await _repository.updateSettings(updated);
  }

  Future<void> updateLanguage(String lang) async {
    final current = state.value;
    if (current == null) return;
    final updated = current.copyWith(language: lang);
    state = AsyncValue.data(updated);
    await _repository.updateSettings(updated);
  }

  Future<void> updateCurrency(String curr) async {
    final current = state.value;
    if (current == null) return;
    final updated = current.copyWith(primaryCurrency: curr);
    state = AsyncValue.data(updated);
    await _repository.updateSettings(updated);
  }

  Future<void> updateTimezone(String tz) async {
    final current = state.value;
    if (current == null) return;
    final updated = current.copyWith(timezone: tz);
    state = AsyncValue.data(updated);
    await _repository.updateSettings(updated);
  }
}

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, AsyncValue<SettingsModel>>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return SettingsNotifier(repo);
});
