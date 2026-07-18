import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';
import '../../features/authentication/domain/models/user.dart';

class SessionStore {
  const SessionStore({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) : _storage = storage;

  final FlutterSecureStorage _storage;

  Future<void> saveUser(User user) async {
    await _storage.write(
      key: AppConstants.storageKeyUser,
      value: jsonEncode(user.toJson()),
    );
    await _storage.write(key: AppConstants.storageKeyAccessToken, value: 'sim_access_${DateTime.now().millisecondsSinceEpoch}');
    await _storage.write(key: AppConstants.storageKeyRefreshToken, value: 'sim_refresh_${DateTime.now().millisecondsSinceEpoch}');
    await _storage.write(key: AppConstants.storageKeyRememberMe, value: 'true');
    await _storage.write(key: AppConstants.storageKeyPin, value: '1234');
    await _storage.write(key: AppConstants.storageKeyBiometricEnabled, value: 'true');
  }

  Future<User?> readUser() async {
    final raw = await _storage.read(key: AppConstants.storageKeyUser);
    if (raw == null || raw.isEmpty) return null;

    try {
      return User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      await clear();
      return null;
    }
  }

  Future<String> readPin() async {
    return await _storage.read(key: AppConstants.storageKeyPin) ?? '1234';
  }

  Future<bool> isBiometricEnabled() async {
    return await _storage.read(key: AppConstants.storageKeyBiometricEnabled) == 'true';
  }

  Future<void> clear() async {
    await _storage.delete(key: AppConstants.storageKeyUser);
    await _storage.delete(key: AppConstants.storageKeyAccessToken);
    await _storage.delete(key: AppConstants.storageKeyRefreshToken);
    await _storage.delete(key: AppConstants.storageKeyRememberMe);
  }
}
