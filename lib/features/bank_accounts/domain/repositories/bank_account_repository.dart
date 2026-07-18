import '../../../../core/network/api_result.dart';
import '../models/bank_account.dart';

abstract class BankAccountRepository {
  Future<ApiResult<List<BankAccount>>> getBankAccounts();
  Future<ApiResult<List<BankAccount>>> syncBankAccounts();
  Future<ApiResult<BankAccount>> updatePrimaryStatus(String accountId, bool isPrimary);
  Future<ApiResult<bool>> disconnectBankAccount(String accountId);
  Future<ApiResult<BankAccount>> addBankAccount(BankAccount account);
}
