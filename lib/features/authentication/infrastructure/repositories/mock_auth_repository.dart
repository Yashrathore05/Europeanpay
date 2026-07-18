import '../../../../core/network/api_result.dart';
import '../../../../core/services/session_store.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  MockAuthRepository({SessionStore sessionStore = const SessionStore()})
      : _sessionStore = sessionStore;

  final SessionStore _sessionStore;
  User? _currentUser;

  final _mockUser = const User(
    id: 'CUST-2026-001',
    firstName: 'Jean',
    lastName: 'Dupont',
    email: 'jean.dupont@email.com',
    phoneNumber: '+33 6 12 34 56 78',
    euPayId: 'EUAB12CD34EF',
    isVerified: true,
    loyaltyPoints: 1250,
    loyaltyTier: 'Gold',
    linkedBanksCount: 2,
  );

  @override
  Future<ApiResult<User>> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (email.contains('fail')) {
      return ApiResult.failure(const ApiException(
        message: 'Invalid email or password',
        code: 'INVALID_CREDENTIALS',
        statusCode: 400,
      ));
    }
    _currentUser = _mockUser.copyWith(email: email);
    await _sessionStore.saveUser(_currentUser!);
    return ApiResult.success(_currentUser!);
  }

  @override
  Future<ApiResult<User>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    String? referralCode,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _currentUser = User(
      id: 'CUST-${DateTime.now().year}-${(DateTime.now().millisecondsSinceEpoch % 1000).toString().padLeft(3, '0')}',
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      euPayId: 'EUPAY-${firstName.toUpperCase()}${DateTime.now().second}',
      isVerified: false,
      loyaltyPoints: referralCode != null ? 100 : 0,
      loyaltyTier: 'Standard',
      linkedBanksCount: 0,
    );
    await _sessionStore.saveUser(_currentUser!);
    return ApiResult.success(_currentUser!);
  }

  @override
  Future<ApiResult<bool>> verifyOtp({
    required String email,
    required String code,
    required String purpose,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (code == '123456' || code == '000000') {
      if (_currentUser != null && _currentUser!.email == email) {
        _currentUser = _currentUser!.copyWith(isVerified: true);
        await _sessionStore.saveUser(_currentUser!);
      }
      return ApiResult.success(true);
    }
    return ApiResult.failure(const ApiException(
      message: 'Invalid OTP code. Please try again.',
      code: 'INVALID_OTP',
      statusCode: 400,
    ));
  }

  @override
  Future<ApiResult<void>> forgotPassword({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (email.isEmpty || !email.contains('@')) {
      return ApiResult.failure(const ApiException(
        message: 'Invalid email address',
        code: 'INVALID_EMAIL',
        statusCode: 400,
      ));
    }
    return ApiResult.success(null);
  }

  @override
  Future<ApiResult<void>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (code != '123456') {
      return ApiResult.failure(const ApiException(
        message: 'Invalid OTP code',
        code: 'INVALID_OTP',
      ));
    }
    return ApiResult.success(null);
  }

  @override
  Future<ApiResult<User>> verifyPhone({required String code}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (code != '123456') {
      return ApiResult.failure(const ApiException(
        message: 'Invalid OTP code',
        code: 'INVALID_OTP',
      ));
    }
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(isVerified: true);
      await _sessionStore.saveUser(_currentUser!);
      return ApiResult.success(_currentUser!);
    }
    return ApiResult.failure(const ApiException(
      message: 'No active session',
      code: 'NO_SESSION',
    ));
  }

  @override
  Future<ApiResult<User>> twoFactorChallenge({required String code}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (code != '123456' && code != '000000') {
      return ApiResult.failure(const ApiException(
        message: 'Invalid two-factor code',
        code: 'INVALID_2FA',
      ));
    }
    _currentUser = _mockUser;
    await _sessionStore.saveUser(_currentUser!);
    return ApiResult.success(_currentUser!);
  }

  @override
  Future<ApiResult<void>> logout() async {
    await Future.delayed(const Duration(milliseconds: 400));
    _currentUser = null;
    await _sessionStore.clear();
    return ApiResult.success(null);
  }

  @override
  Future<ApiResult<User?>> getAuthenticatedUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _currentUser ??= await _sessionStore.readUser();
    return ApiResult.success(_currentUser);
  }
}
