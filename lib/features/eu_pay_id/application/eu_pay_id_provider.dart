import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/recipient.dart';
import '../domain/repositories/eu_pay_id_repository.dart';
import '../infrastructure/repositories/mock_eu_pay_id_repository.dart';

final euPayIdRepositoryProvider = Provider<EuPayIdRepository>((ref) {
  return MockEuPayIdRepository();
});

/// Sealed class representing the recipient validation states.
sealed class RecipientValidationState {
  const RecipientValidationState();
}

class RecipientValidationInitial extends RecipientValidationState {
  const RecipientValidationInitial();
}

class RecipientValidationLoading extends RecipientValidationState {
  const RecipientValidationLoading();
}

class RecipientValidationSuccess extends RecipientValidationState {
  const RecipientValidationSuccess(this.recipient);
  final Recipient recipient;
}

class RecipientValidationFailure extends RecipientValidationState {
  const RecipientValidationFailure(this.error);
  final String error;
}

class RecipientValidationNotifier extends StateNotifier<RecipientValidationState> {
  RecipientValidationNotifier(this._repository) : super(const RecipientValidationInitial());

  final EuPayIdRepository _repository;

  void reset() {
    state = const RecipientValidationInitial();
  }

  Future<bool> lookup(String euPayId) async {
    if (euPayId.trim().isEmpty) {
      state = const RecipientValidationFailure('Please enter an ID.');
      return false;
    }
    state = const RecipientValidationLoading();
    final result = await _repository.validateRecipient(euPayId);
    return result.when(
      success: (recipient) {
        state = RecipientValidationSuccess(recipient);
        return true;
      },
      failure: (error) {
        state = RecipientValidationFailure(error.message);
        return false;
      },
    );
  }
}

final recipientValidationProvider =
    StateNotifierProvider<RecipientValidationNotifier, RecipientValidationState>((ref) {
  final repo = ref.watch(euPayIdRepositoryProvider);
  return RecipientValidationNotifier(repo);
});
