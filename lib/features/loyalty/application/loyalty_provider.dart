import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/loyalty_details.dart';
import '../domain/repositories/loyalty_repository.dart';
import '../infrastructure/repositories/mock_loyalty_repository.dart';

final loyaltyRepositoryProvider = Provider<LoyaltyRepository>((ref) {
  return MockLoyaltyRepository();
});

class LoyaltyNotifier extends StateNotifier<AsyncValue<LoyaltyDetails>> {
  LoyaltyNotifier(this._repository) : super(const AsyncValue.loading()) {
    load();
  }

  final LoyaltyRepository _repository;

  Future<void> load() async {
    state = const AsyncValue.loading();
    final result = await _repository.getLoyaltyDetails();
    result.when(
      success: (data) => state = AsyncValue.data(data),
      failure: (error) => state = AsyncValue.error(error, StackTrace.current),
    );
  }

  Future<bool> withdraw(int pointsAmount) async {
    final result = await _repository.withdrawPoints(pointsAmount);
    return result.when(
      success: (updated) {
        state = AsyncValue.data(updated);
        return true;
      },
      failure: (_) => false,
    );
  }
}

final loyaltyNotifierProvider =
    StateNotifierProvider<LoyaltyNotifier, AsyncValue<LoyaltyDetails>>((ref) {
  final repo = ref.watch(loyaltyRepositoryProvider);
  return LoyaltyNotifier(repo);
});
