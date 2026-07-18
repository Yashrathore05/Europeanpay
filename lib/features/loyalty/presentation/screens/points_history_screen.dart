import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class PointsHistoryScreen extends StatelessWidget {
  const PointsHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Cashback', 'VIP', 'Bonus', 'Referral', 'Withdrawal', 'Expiry'];
    final items = [
      ('Cashback - Café de Flore', '+12 pts', 'Jul 18', AppColors.success),
      ('VIP Monthly Bonus', '+25 pts', 'Jul 17', AppColors.gold),
      ('Cashback - Monoprix', '+18 pts', 'Jul 16', AppColors.success),
      ('Streak Bonus (7 days)', '+50 pts', 'Jul 15', AppColors.primary),
      ('Referral - Pierre M.', '+100 pts', 'Jul 14', AppColors.secondary),
      ('Withdrawal to Bank', '-500 pts', 'Jul 10', AppColors.error),
      ('Birthday Bonus', '+200 pts', 'Jul 5', AppColors.gold),
      ('First Payment Bonus', '+50 pts', 'Jul 1', AppColors.primary),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Points History')),
      body: Column(children: [
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingH),
            children: filters.map((f) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(label: Text(f), selected: f == 'All', onSelected: (_) {}),
            )).toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.pagePaddingH),
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              final item = items[i];
              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), border: Border.all(color: AppColors.borderLight)),
                child: Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.$1, style: AppTypography.titleSmall),
                    Text(item.$3, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
                  ])),
                  Text(item.$2, style: AppTypography.titleSmall.copyWith(color: item.$4, fontWeight: FontWeight.w600)),
                ]),
              );
            },
          ),
        ),
      ]),
    );
  }
}
