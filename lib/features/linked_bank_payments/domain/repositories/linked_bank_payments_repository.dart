import '../../../../core/network/api_result.dart';
import '../models/matched_transaction.dart';

abstract class LinkedBankPaymentsRepository {
  Future<ApiResult<List<MatchedTransaction>>> getMatchedTransactions();
  Future<ApiResult<MatchedTransaction>> confirmMatch(String id);
  Future<ApiResult<MatchedTransaction>> rejectMatch(String id);
}
