import '../../../../core/network/api_result.dart';
import '../models/dashboard_data.dart';

abstract class DashboardRepository {
  Future<ApiResult<DashboardData>> getDashboardData();
  Future<ApiResult<DashboardData>> refreshDashboardData();
}
