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
              Text('Payment Successful', style: AppTypography.headlineMedium),
              const SizedBox(height: AppSpacing.sm),
              Text('€12.50 paid to Café de Flore', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(color: AppColors.goldLight, borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.star_rounded, color: AppColors.gold, size: 20),
                  const SizedBox(width: 8),
                  Text('+12 EU Pay Points earned', style: AppTypography.titleSmall.copyWith(color: AppColors.gold)),
                ]),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Transaction ID: ', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
                  Text('TXN20260718001', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 4),
                  const Icon(Icons.copy_rounded, size: 14, color: AppColors.primary),
                ],
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
