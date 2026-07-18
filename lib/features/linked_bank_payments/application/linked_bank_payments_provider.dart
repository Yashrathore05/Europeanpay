import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/matched_transaction.dart';
import '../domain/repositories/linked_bank_payments_repository.dart';
import '../infrastructure/repositories/mock_linked_bank_payments_repository.dart';

final linkedBankPaymentsRepositoryProvider = Provider<LinkedBankPaymentsRepository>((ref) {
  return MockLinkedBankPaymentsRepository();
});

class LinkedBankPaymentsNotifier extends StateNotifier<AsyncValue<List<MatchedTransaction>>> {
  LinkedBankPaymentsNotifier(this._repository) : super(const AsyncValue.loading()) {
    load();
  }

  final LinkedBankPaymentsRepository _repository;

  Future<void> load() async {
    state = const AsyncValue.loading();
    final result = await _repository.getMatchedTransactions();
    result.when(
      success: (data) => state = AsyncValue.data(data),
      failure: (error) => state = AsyncValue.error(error, StackTrace.current),
    );
  }

  Future<bool> confirm(String id) async {
    final result = await _repository.confirmMatch(id);
    return result.when(
      success: (updatedMatch) {
        state.whenData((list) {
          state = AsyncValue.data(
            list.map((m) => m.id == id ? updatedMatch : m).toList(),
          );
        });
        return true;
      },
      failure: (_) => false,
    );
  }

  Future<bool> reject(String id) async {
    final result = await _repository.rejectMatch(id);
    return result.when(
      success: (updatedMatch) {
        state.whenData((list) {
          state = AsyncValue.data(
            list.map((m) => m.id == id ? updatedMatch : m).toList(),
          );
        });
        return true;
      },
      failure: (_) => false,
    );
  }
}

final linkedBankPaymentsNotifierProvider =
    StateNotifierProvider<LinkedBankPaymentsNotifier, AsyncValue<List<MatchedTransaction>>>((ref) {
  final repo = ref.watch(linkedBankPaymentsRepositoryProvider);
  return LinkedBankPaymentsNotifier(repo);
});
