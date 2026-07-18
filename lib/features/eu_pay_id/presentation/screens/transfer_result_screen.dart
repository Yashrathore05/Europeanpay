import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';

class TransferResultScreen extends StatelessWidget {
  const TransferResultScreen({super.key, required this.resultData});
  final Map<String, dynamic> resultData;

  @override
  Widget build(BuildContext context) {
    final amount = (resultData['amount'] as num?)?.toDouble() ?? 0;
    final recipientName = resultData['recipientName'] as String? ?? 'Recipient';
    final recipientId = resultData['recipientId'] as String? ?? 'EU Pay ID';
    final status = resultData['status'] as String? ?? 'completed';
    final transactionId = resultData['transactionId'] as String? ?? 'EUP-SIMULATED';
    final bankReference = resultData['bankReference'] as String? ?? 'BNK-SIMULATED';
    final schemeReference = resultData['schemeReference'] as String? ?? 'EU Pay ID';
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
              Text(isPending ? 'Transfer Pending' : 'Transfer Successful', style: AppTypography.headlineMedium),
              const SizedBox(height: AppSpacing.sm),
              Text('€${amount.toStringAsFixed(2)} sent to $recipientName', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.sm),
              Text(settlementEta, textAlign: TextAlign.center, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                child: Column(children: [
                  _InfoRow('Transaction ID', transactionId),
                  _InfoRow('Bank Transfer ID', bankReference),
                  _InfoRow('Recipient', recipientId),
                  _InfoRow('Reference', schemeReference),
                  _InfoRow('Status', status.toUpperCase()),
                ]),
              ),
              const Spacer(),
              EuPrimaryButton(label: 'Done', onPressed: () => context.goNamed(RouteNames.dashboard)),
              const SizedBox(height: AppSpacing.md),
              Row(children: [
                Expanded(child: OutlinedButton(onPressed: () => context.goNamed(RouteNames.euPayIdTransfer), child: const Text('Send Again'))),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: OutlinedButton(onPressed: () => context.goNamed(RouteNames.euPayIdTransfer), child: const Text('Search Again'))),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label, value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
        Row(children: [Text(value, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500)), const SizedBox(width: 4), const Icon(Icons.copy_rounded, size: 14, color: AppColors.primary)]),
      ]),
    );
  }
}
