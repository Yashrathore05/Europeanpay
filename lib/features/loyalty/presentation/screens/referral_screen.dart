import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Referral Program')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(width: 80, height: 80, decoration: const BoxDecoration(color: AppColors.primarySurface, shape: BoxShape.circle), child: const Icon(Icons.people_rounded, size: 40, color: AppColors.primary)),
          const SizedBox(height: AppSpacing.xl),
          Text('Invite Friends, Earn Points', style: AppTypography.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),
          Text('Earn 100 points for each friend who joins and makes their first payment.', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xxxl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Your Referral Code', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
                Text('EUPAY-JEAN2026', style: AppTypography.titleLarge.copyWith(letterSpacing: 1)),
              ])),
              IconButton(icon: const Icon(Icons.copy_rounded, color: AppColors.primary), onPressed: () {}),
            ]),
          ),
          const SizedBox(height: AppSpacing.xxl),
          EuPrimaryButton(label: 'Share Invite Link', onPressed: () {}, icon: Icons.share_rounded),
          const Spacer(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(children: [Text('3', style: AppTypography.headlineMedium.copyWith(color: AppColors.primary)), Text('Friends Invited', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary))]),
            Column(children: [Text('300', style: AppTypography.headlineMedium.copyWith(color: AppColors.success)), Text('Points Earned', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary))]),
          ]),
          const SizedBox(height: AppSpacing.xxl),
        ]),
      ),
    );
  }
}
