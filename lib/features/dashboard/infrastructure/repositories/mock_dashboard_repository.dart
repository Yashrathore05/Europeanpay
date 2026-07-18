import '../../../../core/network/api_result.dart';
import '../../../transactions/domain/models/transaction_model.dart';
import '../../domain/models/dashboard_data.dart';
import '../../domain/repositories/dashboard_repository.dart';

class MockDashboardRepository implements DashboardRepository {
  MockDashboardRepository();

  DashboardData _data = DashboardData(
    walletBalance: 2847.50,
    loyaltyPoints: 1250,
    pointsCashValue: 12.50,
    euPayId: 'EUAB12CD34EF',
    linkedBanksCount: 2,
    totalReceived: 1250.00,
    totalSent: 890.30,
    recentTransactions: [
      TransactionModel(
        id: 'TXN-101',
        counterparty: 'Café de Flore',
        type: 'Payment',
        amount: -12.50,
        status: 'completed',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        category: 'Food & Dining',
        reference: 'REF-FLORE-88',
        source: 'EU Pay',
      ),
      TransactionModel(
        id: 'TXN-102',
        counterparty: 'Marie Laurent',
        type: 'Received',
        amount: 50.00,
        status: 'completed',
        date: DateTime.now().subtract(const Duration(hours: 5)),
        category: 'Transfer',
        reference: 'REF-MARIE-P2P',
        source: 'EU Pay',
      ),
      TransactionModel(
        id: 'TXN-103',
        counterparty: 'Carrefour',
        type: 'Payment',
        amount: -67.30,
        status: 'completed',
        date: DateTime.now().subtract(const Duration(days: 1)),
        category: 'Groceries',
        reference: 'REF-CARR-726',
        source: 'EU Pay',
      ),
      TransactionModel(
        id: 'TXN-104',
        counterparty: 'Pierre Martin',
        type: 'Transfer',
        amount: -25.00,
        status: 'pending',
        date: DateTime.now().subtract(const Duration(days: 1)),
        category: 'Transfer',
        reference: 'REF-PIERRE-ID',
        source: 'EU Pay',
      ),
      TransactionModel(
        id: 'TXN-105',
        counterparty: 'EU Pay Points',
        type: 'Cashback',
        amount: 3.50,
        status: 'completed',
        date: DateTime.now().subtract(const Duration(days: 2)),
        category: 'Loyalty',
        reference: 'REF-LOYALTY-001',
        source: 'EU Pay',
      ),
    ],
  );

  @override
  Future<ApiResult<DashboardData>> getDashboardData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResult.success(_data);
  }

  @override
  Future<ApiResult<DashboardData>> refreshDashboardData() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // Simulate some update during refresh
    _data = _data.copyWith(
      walletBalance: _data.walletBalance + 10.0,
      totalReceived: _data.totalReceived + 10.0,
    );
    return ApiResult.success(_data);
  }
}
