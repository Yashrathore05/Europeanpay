import '../../../../core/network/api_result.dart';
import '../domain/models/bank_account.dart';
import '../domain/repositories/bank_account_repository.dart';

class MockBankAccountRepository implements BankAccountRepository {
  MockBankAccountRepository();

  final List<BankAccount> _accounts = [
    BankAccount(
      id: 'acc1',
      bankName: 'BNP Paribas',
      accountName: 'Current Account',
      iban: 'FR76 1234 5678 9012 3456 7890 123',
      accountNumber: '1234567890123',
      balance: 8750.30,
      available: 8650.30,
      pending: 100.00,
      type: 'Checking',
      lastSynced: DateTime.now().subtract(const Duration(minutes: 2)),
      isPrimary: true,
    ),
    BankAccount(
      id: 'acc2',
      bankName: 'BNP Paribas',
      accountName: 'Savings Account',
      iban: 'FR76 9876 5432 1098 7654 3210 987',
      accountNumber: '9876543210987',
      balance: 6480.15,
      available: 6480.15,
      pending: 0.00,
      type: 'Savings',
      lastSynced: DateTime.now().subtract(const Duration(minutes: 2)),
      isPrimary: false,
    ),
  ];

  @override
  Future<ApiResult<List<BankAccount>>> getBankAccounts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResult.success(List.unmodifiable(_accounts));
  }

  @override
  Future<ApiResult<List<BankAccount>>> syncBankAccounts() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    for (int i = 0; i < _accounts.length; i++) {
      _accounts[i] = _accounts[i].copyWith(
        lastSynced: DateTime.now(),
        balance: _accounts[i].balance + (i == 0 ? 5.50 : 0.0), // simulate minor balance change on sync
      );
    }
    return ApiResult.success(List.unmodifiable(_accounts));
  }

  @override
  Future<ApiResult<BankAccount>> updatePrimaryStatus(String accountId, bool isPrimary) async {
    await Future.delayed(const Duration(milliseconds: 500));
    for (int i = 0; i < _accounts.length; i++) {
      if (_accounts[i].id == accountId) {
        _accounts[i] = _accounts[i].copyWith(isPrimary: isPrimary);
      } else if (isPrimary) {
        // Only one account can be primary
        _accounts[i] = _accounts[i].copyWith(isPrimary: false);
      }
    }
    final updated = _accounts.firstWhere((element) => element.id == accountId);
    return ApiResult.success(updated);
  }

  @override
  Future<ApiResult<bool>> disconnectBankAccount(String accountId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _accounts.removeWhere((element) => element.id == accountId);
    return const ApiResult.success(true);
  }
}
