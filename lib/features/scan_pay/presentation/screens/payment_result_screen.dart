import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';

class PaymentResultScreen extends StatelessWidget {
  const PaymentResultScreen({super.key, required this.resultData});
  final Map<String, dynamic> resultData;

  @override
  Widget build(BuildContext context) {
    final amount = (resultData['amount'] as num?)?.toDouble() ?? 0;
    final merchant = resultData['merchant'] as String? ?? 'Merchant';
    final status = resultData['status'] as String? ?? 'completed';
    final transactionId = resultData['transactionId'] as String? ?? 'EUP-SIMULATED';
    final bankReference = resultData['bankReference'] as String? ?? 'BNK-SIMULATED';
    final schemeReference = resultData['schemeReference'] as String? ?? 'SEPA Instant';
    final points = resultData['pointsEarned'] as int? ?? amount.floor();
    final settlementEta = resultData['settlementEta'] as String? ?? 'Instantly settled';
    final isPending = status == 'pending';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(width: 96, height: 96, decoration: BoxDecoration(color: isPending ? AppColors.pendingBg : AppColors.successLight, shape: BoxShape.circle), child: Icon(isPending ? Icons.schedule_rounded : Icons.check_circle_rounded, size: 56, color: isPending ? AppColors.pending : AppColors.success)),
              const SizedBox(height: AppSpacing.xxl),
              Text(isPending ? 'Payment Pending' : 'Payment Successful', style: AppTypography.headlineMedium),
              const SizedBox(height: AppSpacing.sm),
              Text('€${amount.toStringAsFixed(2)} paid to $merchant', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.sm),
              Text(settlementEta, textAlign: TextAlign.center, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(color: AppColors.goldLight, borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.star_rounded, color: AppColors.gold, size: 20),
                  const SizedBox(width: 8),
                  Text('+$points EU Pay Points earned', style: AppTypography.titleSmall.copyWith(color: AppColors.gold)),
                ]),
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), border: Border.all(color: AppColors.borderLight)),
                child: Column(
                  children: [
                    _ReceiptRow('Transaction ID', transactionId),
                    _ReceiptRow('Bank reference', bankReference),
                    _ReceiptRow('Payment rail', schemeReference),
                    _ReceiptRow('Status', status.toUpperCase()),
                  ],
                ),
              ),
              const Spacer(),
              EuPrimaryButton(label: 'Done', onPressed: () => context.goNamed(RouteNames.dashboard)),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Pay Again'))),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: OutlinedButton(onPressed: () => context.goNamed(RouteNames.transactions), child: const Text('Transactions'))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
