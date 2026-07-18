import '../../../../core/network/api_result.dart';
import '../models/recipient.dart';

abstract class EuPayIdRepository {
  Future<ApiResult<Recipient>> validateRecipient(String euPayId);
  Future<ApiResult<bool>> executeTransfer({
    required String recipientEuPayId,
    required double amount,
    String? note,
  });
}
