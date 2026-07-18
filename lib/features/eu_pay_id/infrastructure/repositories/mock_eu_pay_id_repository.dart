import '../../../../core/network/api_exceptions.dart';
import '../../../../core/network/api_result.dart';
import '../domain/models/recipient.dart';
import '../domain/repositories/eu_pay_id_repository.dart';

class MockEuPayIdRepository implements EuPayIdRepository {
  MockEuPayIdRepository();

  @override
  Future<ApiResult<Recipient>> validateRecipient(String euPayId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final normalizedId = euPayId.trim().toUpperCase();

    if (normalizedId == 'EUXY98ZW76VU') {
      return const ApiResult.success(
        Recipient(
          fullName: 'Marie Laurent',
          euPayId: 'EUXY98ZW76VU',
          type: 'Customer',
        ),
      );
    } else if (normalizedId.startsWith('EU') && normalizedId.length == 12) {
      // Return a generated recipient for other valid-looking IDs
      final suffix = normalizedId.substring(2);
      return ApiResult.success(
        Recipient(
          fullName: 'Recipient $suffix',
          euPayId: normalizedId,
          type: 'Customer',
        ),
      );
    } else {
      return const ApiResult.failure(
        ApiException(
          message: 'Recipient not found. Please check the EU Pay ID.',
          statusCode: 404,
        ),
      );
    }
  }

  @override
  Future<ApiResult<bool>> executeTransfer({
    required String recipientEuPayId,
    required double amount,
    String? note,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (amount <= 0) {
      return const ApiResult.failure(
        ApiException(
          message: 'Amount must be greater than zero.',
          statusCode: 400,
        ),
      );
    }
    return const ApiResult.success(true);
  }
}
