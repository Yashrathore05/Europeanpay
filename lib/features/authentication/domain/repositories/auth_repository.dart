import '../../../../core/network/api_result.dart';
import '../models/user.dart';

abstract class AuthRepository {
  Future<ApiResult<User>> login({
    required String email,
    required String password,
  });

  Future<ApiResult<User>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    String? referralCode,
    required String password,
  });

  Future<ApiResult<bool>> verifyOtp({
    required String email,
    required String code,
    required String purpose,
  });

  Future<ApiResult<void>> forgotPassword({
    required String email,
  });

  Future<ApiResult<void>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  Future<ApiResult<User>> verifyPhone({
    required String code,
  });

  Future<ApiResult<User>> twoFactorChallenge({
    required String code,
  });

  Future<ApiResult<void>> logout();

  Future<ApiResult<User?>> getAuthenticatedUser();
}
