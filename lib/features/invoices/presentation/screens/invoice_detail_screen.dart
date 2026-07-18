import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';

class InvoiceDetailScreen extends StatelessWidget {
  const InvoiceDetailScreen({super.key, required this.invoiceId});
  final String invoiceId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Invoice')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(children: [
          Container(
            width: double.infinity, padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSpacing.radiusLg), border: Border.all(color: AppColors.borderLight)),
            child: Column(children: [
              const Icon(Icons.receipt_long_rounded, size: 48, color: AppColors.primary),
              const SizedBox(height: AppSpacing.lg),
              Text('Invoice #$invoiceId', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.xl),
              _Row('Merchant', 'Tech Solutions SAS'),
              _Row('Amount', '€150.00'),
              _Row('Due Date', 'Jul 25, 2026'),
              _Row('Status', 'Unpaid'),
              _Row('Type', 'EN16931'),
            ]),
          ),
          const Spacer(),
          EuPrimaryButton(label: 'Pay €150.00', onPressed: () {}),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.picture_as_pdf_rounded), label: const Text('Download PDF')),
          const SizedBox(height: AppSpacing.lg),
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
