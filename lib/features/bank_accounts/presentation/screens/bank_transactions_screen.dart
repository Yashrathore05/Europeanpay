import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class BankTransactionsScreen extends StatelessWidget {
  const BankTransactionsScreen({super.key, this.accountId});
  final String? accountId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Bank Transactions')),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.pagePaddingH),
        itemCount: 8,
        itemBuilder: (ctx, i) {
          final names = ['Salary Credit', 'Rent Payment', 'EDF Electricity', 'Amazon FR', 'SNCF Ticket', 'Uber Eats', 'Netflix', 'Gym Membership'];
          final amounts = [3200.0, -1100.0, -85.40, -45.99, -32.00, -18.50, -12.99, -39.90];
          final isCredit = amounts[i] > 0;
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), border: Border.all(color: AppColors.borderLight)),
            child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: isCredit ? AppColors.successLight : AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8)), child: Icon(isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded, color: isCredit ? AppColors.success : AppColors.textSecondary, size: 20)),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(names[i], style: AppTypography.titleSmall),
                Text('Jul ${18 - i}, 2026', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
              ])),
              Text('${isCredit ? "+" : ""}€${amounts[i].abs().toStringAsFixed(2)}', style: AppTypography.titleSmall.copyWith(color: isCredit ? AppColors.success : AppColors.textPrimary, fontWeight: FontWeight.w600)),
            ]),
          );
        },
      ),
    );
  }
}
