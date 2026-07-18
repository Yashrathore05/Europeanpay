import 'package:local_auth/local_auth.dart';

class SecurityService {
  SecurityService({LocalAuthentication? localAuth})
      : _localAuth = localAuth ?? LocalAuthentication();

  final LocalAuthentication _localAuth;

  Future<bool> canUseBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticatePayment() async {
    try {
      if (!await canUseBiometrics()) return false;
      return _localAuth.authenticate(
        localizedReason: 'Confirm this European Pay transaction',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
