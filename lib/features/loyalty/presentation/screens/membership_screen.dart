import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Membership')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(children: [
          _TierCard('Standard', 'Free', ['3% cashback', 'Basic rewards', 'Standard support'], false, AppColors.textSecondary),
          const SizedBox(height: AppSpacing.lg),
          _TierCard('Gold', '€0 (Auto)', ['5% cashback', 'VIP bonuses', 'Priority support', 'Birthday rewards'], true, AppColors.gold),
          const SizedBox(height: AppSpacing.lg),
          _TierCard('Platinum', '€1,000+ spend', ['8% cashback', 'Premium bonuses', 'Dedicated support', 'Exclusive offers', 'Early access'], false, AppColors.platinum),
          const SizedBox(height: AppSpacing.xxl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: AppColors.goldLight, borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Your Progress', style: AppTypography.titleSmall.copyWith(color: AppColors.gold)),
              const SizedBox(height: AppSpacing.sm),
              Text('Spend €350 more to reach Platinum tier', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.sm),
              LinearProgressIndicator(value: 0.65, backgroundColor: Colors.white, valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold)),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard(this.name, this.price, this.benefits, this.isCurrent, this.color);
  final String name, price;
  final List<String> benefits;
  final bool isCurrent;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: isCurrent ? color : AppColors.borderLight, width: isCurrent ? 2 : 1),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(name, style: AppTypography.titleLarge.copyWith(color: color)),
          if (isCurrent) ...[const Spacer(), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppSpacing.radiusFull)), child: Text('Current', style: AppTypography.labelSmall.copyWith(color: color)))],
        ]),
        Text(price, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
        const SizedBox(height: AppSpacing.md),
        ...benefits.map((b) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [Icon(Icons.check_rounded, size: 16, color: color), const SizedBox(width: 8), Text(b, style: AppTypography.bodySmall)]))),
      ]),
    );
  }
}
