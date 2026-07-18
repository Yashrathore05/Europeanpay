import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/dashboard_data.dart';
import '../domain/repositories/dashboard_repository.dart';
import '../infrastructure/repositories/mock_dashboard_repository.dart';

/// Provider for the DashboardRepository.
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return MockDashboardRepository();
});

/// StateNotifier to manage dashboard loading, refreshing, and error states.
class DashboardNotifier extends StateNotifier<AsyncValue<DashboardData>> {
  DashboardNotifier(this._repository) : super(const AsyncValue.loading()) {
    load();
  }

  final DashboardRepository _repository;

  Future<void> load() async {
    state = const AsyncValue.loading();
    final result = await _repository.getDashboardData();
    result.when(
      success: (data) => state = AsyncValue.data(data),
      failure: (error) => state = AsyncValue.error(error, StackTrace.current),
    );
  }

  Future<void> refresh() async {
    final result = await _repository.refreshDashboardData();
    result.when(
      success: (data) => state = AsyncValue.data(data),
      failure: (error) => state = AsyncValue.error(error, StackTrace.current),
    );
  }
}

/// Provider for the dashboard state notifier.
final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardData>>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return DashboardNotifier(repository);
});
