import '../../../transactions/domain/models/transaction_model.dart';

class DashboardData {
  const DashboardData({
    required this.walletBalance,
    required this.loyaltyPoints,
    required this.pointsCashValue,
    required this.euPayId,
    required this.linkedBanksCount,
    required this.totalReceived,
    required this.totalSent,
    required this.recentTransactions,
  });

  final double walletBalance;
  final int loyaltyPoints;
  final double pointsCashValue;
  final String euPayId;
  final int linkedBanksCount;
  final double totalReceived;
  final double totalSent;
  final List<TransactionModel> recentTransactions;

  DashboardData copyWith({
    double? walletBalance,
    int? loyaltyPoints,
    double? pointsCashValue,
    String? euPayId,
    int? linkedBanksCount,
    double? totalReceived,
    double? totalSent,
    List<TransactionModel>? recentTransactions,
  }) {
    return DashboardData(
      walletBalance: walletBalance ?? this.walletBalance,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      pointsCashValue: pointsCashValue ?? this.pointsCashValue,
      euPayId: euPayId ?? this.euPayId,
      linkedBanksCount: linkedBanksCount ?? this.linkedBanksCount,
      totalReceived: totalReceived ?? this.totalReceived,
      totalSent: totalSent ?? this.totalSent,
      recentTransactions: recentTransactions ?? this.recentTransactions,
    );
  }
}
