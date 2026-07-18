import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_result.dart';
import '../domain/models/user.dart';
import '../domain/repositories/auth_repository.dart';
import '../infrastructure/repositories/mock_auth_repository.dart';

/// Provider for the AuthRepository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});

/// Sealed class representing the Authentication States.
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  const Authenticated(this.user);
  final User user;
}

class Unauthenticated extends AuthState {
  const Unauthenticated({this.error});
  final String? error;
}

/// StateNotifier to manage authentication state and handle logic.
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthInitial()) {
    _checkCurrentUser();
  }

  final AuthRepository _repository;

  Future<void> _checkCurrentUser() async {
    final result = await _repository.getAuthenticatedUser();
    result.when(
      success: (user) {
        if (user != null) {
          state = Authenticated(user);
        } else {
          state = const Unauthenticated();
        }
      },
      failure: (_) {
        state = const Unauthenticated();
      },
    );
  }

  Future<bool> login(String email, String password) async {
    state = const AuthLoading();
    final result = await _repository.login(email: email, password: password);
    return result.when(
      success: (user) {
        state = Authenticated(user);
        return true;
      },
      failure: (error) {
        state = Unauthenticated(error: error.message);
        return false;
      },
    );
  }

  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    String? referralCode,
    required String password,
  }) async {
    state = const AuthLoading();
    final result = await _repository.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      referralCode: referralCode,
      password: password,
    );
    return result.when(
      success: (user) {
        // Keeps user in loading/unverified state till OTP is done.
        state = Unauthenticated(error: 'Verification required');
        return true;
      },
      failure: (error) {
        state = Unauthenticated(error: error.message);
        return false;
      },
    );
  }

  Future<bool> verifyOtp({
    required String email,
    required String code,
    required String purpose,
  }) async {
    state = const AuthLoading();
    final result = await _repository.verifyOtp(
      email: email,
      code: code,
      purpose: purpose,
    );
    return result.when(
      success: (success) async {
        if (success) {
          // Re-fetch the authenticated user now that they are verified
          final userResult = await _repository.getAuthenticatedUser();
          userResult.when(
            success: (user) {
              if (user != null) {
                state = Authenticated(user);
              } else {
                state = const Unauthenticated();
              }
            },
            failure: (error) {
              state = Unauthenticated(error: error.message);
            },
          );
          return true;
        }
        state = const Unauthenticated(error: 'Verification failed');
        return false;
      },
      failure: (error) {
        state = Unauthenticated(error: error.message);
        return false;
      },
    );
  }

  Future<bool> verifyPhone(String code) async {
    final result = await _repository.verifyPhone(code: code);
    return result.when(
      success: (user) {
        state = Authenticated(user);
        return true;
      },
      failure: (error) {
        return false;
      },
    );
  }

  Future<bool> twoFactorChallenge(String code) async {
    state = const AuthLoading();
    final result = await _repository.twoFactorChallenge(code: code);
    return result.when(
      success: (user) {
        state = Authenticated(user);
        return true;
      },
      failure: (error) {
        state = Unauthenticated(error: error.message);
        return false;
      },
    );
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    final current = state;
    if (current is Authenticated) {
      final updated = current.user.copyWith(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );
      state = Authenticated(updated);
    }
  }

  Future<void> logout() async {
    state = const AuthLoading();
    await _repository.logout();
    state = const Unauthenticated();
  }
}

/// Provider for the AuthNotifier state management.
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
