import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';

class LoyaltyTermsScreen extends StatelessWidget {
  const LoyaltyTermsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Points Terms')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('Version 2.1', style: AppTypography.labelMedium.copyWith(color: AppColors.textTertiary)),
            const Spacer(),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(4)), child: Text('Accepted', style: AppTypography.labelSmall.copyWith(color: AppColors.success))),
          ]),
          Text('Effective: Jul 1, 2026', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: AppSpacing.xxl),
          Text('EU Pay Points Program Terms and Conditions', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.xl),
          _Section('1. Program Overview', 'The EU Pay Points program rewards users for qualifying transactions made through the European Pay platform.'),
          _Section('2. Earning Points', 'Points are earned at a rate of 3% on all qualifying QR payments. VIP members earn additional bonus points.'),
          _Section('3. Redeeming Points', 'Points can be redeemed at a rate of €0.01 per point. Minimum withdrawal is 500 points.'),
          _Section('4. Expiry', 'Points expire 12 months after being earned if not redeemed.'),
          _Section('5. Eligibility', 'All registered EU Pay users with a verified account are eligible to participate.'),
          const SizedBox(height: AppSpacing.xxl),
          EuPrimaryButton(label: 'Accept Updated Terms', onPressed: () => Navigator.pop(context)),
        ]),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title, this.body);
  final String title, body;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: AppSpacing.xl), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: AppTypography.titleSmall),
      const SizedBox(height: AppSpacing.sm),
      Text(body, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.6)),
    ]));
  }
}
