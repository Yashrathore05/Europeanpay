import '../../../../core/network/api_result.dart';
import '../../domain/models/matched_transaction.dart';
import '../../domain/repositories/linked_bank_payments_repository.dart';

class MockLinkedBankPaymentsRepository implements LinkedBankPaymentsRepository {
  MockLinkedBankPaymentsRepository();

  final List<MatchedTransaction> _matches = [
    MatchedTransaction(
      id: 'm1',
      bankTxnName: 'FR BNP DEBIT',
      bankTxnAmount: 25.00,
      bankTxnDate: DateTime.now().subtract(const Duration(days: 1)),
      euPayTxnName: 'EU Pay Café de Flore',
      euPayTxnAmount: 25.00,
      euPayTxnDate: DateTime.now().subtract(const Duration(days: 1)),
      confidence: 92,
      status: 'pending',
    ),
    MatchedTransaction(
      id: 'm2',
      bankTxnName: 'FR BNP DEBIT 2',
      bankTxnAmount: 50.00,
      bankTxnDate: DateTime.now().subtract(const Duration(days: 2)),
      euPayTxnName: 'EU Pay Boulangerie',
      euPayTxnAmount: 50.00,
      euPayTxnDate: DateTime.now().subtract(const Duration(days: 2)),
      confidence: 87,
      status: 'pending',
    ),
    MatchedTransaction(
      id: 'm3',
      bankTxnName: 'FR BNP DEBIT 3',
      bankTxnAmount: 75.00,
      bankTxnDate: DateTime.now().subtract(const Duration(days: 3)),
      euPayTxnName: 'EU Pay Supermarche',
      euPayTxnAmount: 75.00,
      euPayTxnDate: DateTime.now().subtract(const Duration(days: 3)),
      confidence: 75,
      status: 'pending',
    ),
  ];

  @override
  Future<ApiResult<List<MatchedTransaction>>> getMatchedTransactions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResult.success(List.unmodifiable(_matches));
  }

  @override
  Future<ApiResult<MatchedTransaction>> confirmMatch(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _matches.indexWhere((m) => m.id == id);
    if (index != -1) {
      _matches[index] = _matches[index].copyWith(status: 'matched');
      return ApiResult.success(_matches[index]);
    }
    return ApiResult.success(_matches.first);
  }

  @override
  Future<ApiResult<MatchedTransaction>> rejectMatch(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _matches.indexWhere((m) => m.id == id);
    if (index != -1) {
      _matches[index] = _matches[index].copyWith(status: 'rejected');
      return ApiResult.success(_matches[index]);
    }
    return ApiResult.success(_matches.first);
  }
}
