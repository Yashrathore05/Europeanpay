import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/feedback/eu_feedback.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key, required this.transactionId});
  final String transactionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Transaction Detail'), actions: [IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {})]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            Container(
              width: 72, height: 72,
              decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_rounded, size: 40, color: AppColors.success),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Payment Completed', style: AppTypography.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text('-€12.50', style: AppTypography.amountLarge.copyWith(color: AppColors.textPrimary)),
            const SizedBox(height: AppSpacing.xxxl),
            _DetailRow('Transaction ID', transactionId, copyable: true),
            _DetailRow('Date', 'Jul 18, 2026 at 14:30'),
            _DetailRow('Recipient', 'Café de Flore'),
            _DetailRow('Source', 'QR Payment'),
            _DetailRow('Status', 'Completed'),
            _DetailRow('Points Earned', '+12 pts'),
            const SizedBox(height: AppSpacing.xxxl),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Pay Again'))),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('Share Receipt'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value, {this.copyable = false});
  final String label, value;
  final bool copyable;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary)),
          Row(
            children: [
              Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
              if (copyable) ...[const SizedBox(width: 4), const Icon(Icons.copy_rounded, size: 16, color: AppColors.primary)],
            ],
          ),
        ],
      ),
    );
  }
}
