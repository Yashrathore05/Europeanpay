import '../../../../core/network/api_exceptions.dart';
import '../../../../core/network/api_result.dart';
import '../domain/models/loyalty_details.dart';
import '../domain/repositories/loyalty_repository.dart';

class MockLoyaltyRepository implements LoyaltyRepository {
  MockLoyaltyRepository();

  late LoyaltyDetails _loyalty = LoyaltyDetails(
    pointsBalance: 1250,
    pendingPoints: 85,
    earnedThisMonth: 320,
    streakDays: 7,
    vipTier: 'Gold',
    lifetimeEarned: 5280,
    lifetimeRedeemed: 4030,
    cashbackExtraPercentage: 5.0,
    nextTierProgress: 0.65,
    nextTierPoints: 650,
    nextTierTarget: 1000,
    nextTierName: 'Platinum',
    recentActivity: [
      PointActivity(
        id: 'act1',
        title: 'Cashback - Café de Flore',
        points: 12,
        type: 'cashback',
        date: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      PointActivity(
        id: 'act2',
        title: 'VIP Bonus',
        points: 25,
        type: 'vip_bonus',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      PointActivity(
        id: 'act3',
        title: 'Cashback - Monoprix',
        points: 18,
        type: 'cashback',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      PointActivity(
        id: 'act4',
        title: 'Streak Bonus (7 days)',
        points: 50,
        type: 'streak_bonus',
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ],
  );

  @override
  Future<ApiResult<LoyaltyDetails>> getLoyaltyDetails() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResult.success(_loyalty);
  }

  @override
  Future<ApiResult<LoyaltyDetails>> withdrawPoints(int pointsAmount) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (pointsAmount < 500) {
      return const ApiResult.failure(
        ApiException(
          message: 'Minimum withdrawal is 500 points.',
          statusCode: 400,
        ),
      );
    }
    if (pointsAmount > _loyalty.pointsBalance) {
      return const ApiResult.failure(
        ApiException(
          message: 'Insufficient points balance.',
          statusCode: 400,
        ),
      );
    }

    // Add withdrawal log to activities
    final newActivity = PointActivity(
      id: 'act_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Withdrawal to BNP Paribas',
      points: -pointsAmount,
      type: 'withdrawal',
      date: DateTime.now(),
    );

    _loyalty = _loyalty.copyWith(
      pointsBalance: _loyalty.pointsBalance - pointsAmount,
      lifetimeRedeemed: _loyalty.lifetimeRedeemed + pointsAmount,
      recentActivity: [newActivity, ..._loyalty.recentActivity],
    );

    return ApiResult.success(_loyalty);
  }
}
