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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(width: 96, height: 96, decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle), child: const Icon(Icons.check_circle_rounded, size: 56, color: AppColors.success)),
              const SizedBox(height: AppSpacing.xxl),
              Text('Transfer Successful', style: AppTypography.headlineMedium),
              const SizedBox(height: AppSpacing.sm),
              Text('€50.00 sent to Marie Laurent', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                child: Column(children: [
                  _InfoRow('Transaction ID', 'TXN20260718002'),
                  _InfoRow('Bank Transfer ID', 'BNK98765432'),
                  _InfoRow('Reference', 'EUPAY-REF-001'),
                  _InfoRow('Status', 'Completed'),
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
