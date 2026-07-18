import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class RewardRulesScreen extends StatelessWidget {
  const RewardRulesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final rules = [
      _Rule('Welcome Bonus', '50 pts on first registration', 'Bonus', true),
      _Rule('First Payment', '50 pts on first QR payment', 'Bonus', true),
      _Rule('Standard Cashback', '3% cashback on all payments', 'Cashback', true),
      _Rule('VIP Gold Bonus', '+5% extra cashback', 'VIP', true),
      _Rule('7-Day Streak', '50 pts for 7 consecutive days', 'Bonus', true),
      _Rule('Birthday Reward', '200 pts on your birthday', 'Bonus', true),
      _Rule('Referral Reward', '100 pts per successful referral', 'Referral', true),
      _Rule('Monthly Milestone', '25 pts for 10+ transactions/month', 'Bonus', true),
      _Rule('Merchant Cashback', 'Up to 10% at partner merchants', 'Merchant', true),
    ];
    final filters = ['All', 'Cashback', 'VIP', 'Bonus', 'Referral', 'Merchant'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Reward Rules')),
      body: Column(children: [
        SizedBox(height: 40, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingH), children: filters.map((f) => Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(f), selected: f == 'All', onSelected: (_) {}))).toList())),
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.pagePaddingH),
          itemCount: rules.length,
          itemBuilder: (ctx, i) {
            final r = rules[i];
            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), border: Border.all(color: AppColors.borderLight)),
              child: Row(children: [
                Container(width: 8, height: 40, decoration: BoxDecoration(color: r.isActive ? AppColors.success : AppColors.textTertiary, borderRadius: BorderRadius.circular(4))),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(r.title, style: AppTypography.titleSmall),
                  Text(r.description, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                ])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(4)), child: Text(r.type, style: AppTypography.labelSmall)),
              ]),
            );
          },
        )),
      ]),
    );
  }
}

class _Rule {
  const _Rule(this.title, this.description, this.type, this.isActive);
  final String title, description, type;
  final bool isActive;
}
