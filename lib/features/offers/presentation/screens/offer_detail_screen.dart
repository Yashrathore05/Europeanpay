import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';

class OfferDetailScreen extends StatelessWidget {
  const OfferDetailScreen({super.key, required this.offerId});
  final String offerId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Offer Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity, padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
            child: Column(children: [
              Text('20% Off', style: AppTypography.displayMedium.copyWith(color: Colors.white)),
              Text('Le Petit Bistro', style: AppTypography.titleMedium.copyWith(color: Colors.white70)),
            ]),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text('Offer Details', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.md),
          _Row('Category', 'Restaurant'),
          _Row('Minimum Spend', '€20.00'),
          _Row('Valid Until', 'Jul 31, 2026'),
          _Row('Location', '0.8 km away'),
          const SizedBox(height: AppSpacing.xxl),
          Text('Merchant Information', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.md),
          Text('Le Petit Bistro is a charming French restaurant in the heart of Paris, known for its authentic cuisine and cozy atmosphere.', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.xxl),
          Text('How to Redeem', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.md),
          _Step('1', 'Visit Le Petit Bistro'),
          _Step('2', 'Scan the merchant QR code'),
          _Step('3', 'The discount is applied automatically'),
          const SizedBox(height: AppSpacing.xxxl),
          EuPrimaryButton(label: 'Pay with EU Pay', onPressed: () {}),
          const SizedBox(height: AppSpacing.md),
          Row(children: [
            Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.map_outlined, size: 18), label: const Text('Directions'))),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.store_outlined, size: 18), label: const Text('Visit Store'))),
          ]),
        ]),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);
  final String label, value;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary)), Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500))]));
  }
}

class _Step extends StatelessWidget {
  const _Step(this.number, this.text);
  final String number, text;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
      Container(width: 28, height: 28, decoration: const BoxDecoration(color: AppColors.primarySurface, shape: BoxShape.circle), child: Center(child: Text(number, style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)))),
      const SizedBox(width: AppSpacing.md),
      Text(text, style: AppTypography.bodyMedium),
    ]));
  }
}
