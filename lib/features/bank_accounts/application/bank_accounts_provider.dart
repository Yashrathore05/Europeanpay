import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/bank_account.dart';
import '../domain/repositories/bank_account_repository.dart';
import '../infrastructure/repositories/mock_bank_account_repository.dart';

final bankAccountRepositoryProvider = Provider<BankAccountRepository>((ref) {
  return MockBankAccountRepository();
});

class BankAccountsNotifier extends StateNotifier<AsyncValue<List<BankAccount>>> {
  BankAccountsNotifier(this._repository) : super(const AsyncValue.loading()) {
    load();
  }

  final BankAccountRepository _repository;

  Future<void> load() async {
    state = const AsyncValue.loading();
    final result = await _repository.getBankAccounts();
    result.when(
      success: (data) => state = AsyncValue.data(data),
      failure: (error) => state = AsyncValue.error(error, StackTrace.current),
    );
  }

  Future<bool> sync() async {
    // Keep showing existing data if we have it while syncing
    final previousState = state;
    final result = await _repository.syncBankAccounts();
    return result.when(
      success: (data) {
        state = AsyncValue.data(data);
        return true;
      },
      failure: (error) {
        state = previousState; // restore previous data if sync failed
        return false;
      },
    );
  }

  Future<bool> setPrimary(String accountId) async {
    final result = await _repository.updatePrimaryStatus(accountId, true);
    return result.when(
      success: (updatedAccount) {
        // Refresh local state list
        load();
        return true;
      },
      failure: (_) => false,
    );
  }

  Future<bool> disconnect(String accountId) async {
    final result = await _repository.disconnectBankAccount(accountId);
    return result.when(
      success: (_) {
        load();
        return true;
      },
      failure: (_) => false,
    );
  }
}

final bankAccountsNotifierProvider =
    StateNotifierProvider<BankAccountsNotifier, AsyncValue<List<BankAccount>>>((ref) {
  final repo = ref.watch(bankAccountRepositoryProvider);
  return BankAccountsNotifier(repo);
});
