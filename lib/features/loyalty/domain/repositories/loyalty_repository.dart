import '../../../../core/network/api_result.dart';
import '../models/loyalty_details.dart';

abstract class LoyaltyRepository {
  Future<ApiResult<LoyaltyDetails>> getLoyaltyDetails();
  Future<ApiResult<LoyaltyDetails>> withdrawPoints(int pointsAmount);
}
