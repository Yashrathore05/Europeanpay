import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/payment_simulator.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';
import '../../../../shared/widgets/inputs/eu_inputs.dart';
import '../../application/eu_pay_id_provider.dart';
import '../../domain/models/recipient.dart';

class EuPayIdTransferScreen extends ConsumerStatefulWidget {
  const EuPayIdTransferScreen({super.key, this.initialRecipientId});
  final String? initialRecipientId;

  @override
  ConsumerState<EuPayIdTransferScreen> createState() => _EuPayIdTransferScreenState();
}

class _EuPayIdTransferScreenState extends ConsumerState<EuPayIdTransferScreen> {
  int _step = 0; // 0: lookup, 1: amount, 2: review
  final _idController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isSending = false;
  Recipient? _verifiedRecipient;
  final _paymentSimulator = PaymentSimulator();

  @override
  void initState() {
    super.initState();
    if (widget.initialRecipientId != null) {
      _idController.text = widget.initialRecipientId!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _lookupRecipient();
      });
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _lookupRecipient() async {
    final success = await ref.read(recipientValidationProvider.notifier).lookup(_idController.text);
    if (mounted) {
      final searchState = ref.read(recipientValidationProvider);
      if (success && searchState is RecipientValidationSuccess) {
        setState(() {
          _verifiedRecipient = searchState.recipient;
        });
      } else if (searchState is RecipientValidationFailure) {
        setState(() {
          _verifiedRecipient = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(searchState.error),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _executeTransfer() async {
    if (_verifiedRecipient == null) return;
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount greater than €0.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSending = true);
    final result = await ref.read(euPayIdRepositoryProvider).executeTransfer(
          recipientEuPayId: _verifiedRecipient!.euPayId,
          amount: amount,
          note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        );

    if (mounted) {
      setState(() => _isSending = false);
      result.when(
        success: (_) {
          _paymentSimulator.authorize(amount: amount, rail: 'EU Pay ID').then((receipt) {
            if (!mounted) return;
            context.pushNamed(RouteNames.transferResult, extra: {
              'amount': amount,
              'recipientName': _verifiedRecipient!.fullName,
              'recipientId': _verifiedRecipient!.euPayId,
              'note': _noteController.text.trim(),
              ...receipt.toJson(),
            });
          });
        },
        failure: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_step == 0
            ? 'Send Money'
            : _step == 1
                ? 'Enter Amount'
                : 'Review Transfer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (_step > 0) {
              setState(() => _step--);
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: _step == 0
              ? _buildLookup()
              : _step == 1
                  ? _buildAmount()
                  : _buildReview(),
        ),
      ),
    );
  }

  Widget _buildLookup() {
    final searchState = ref.watch(recipientValidationProvider);
    final isLoading = searchState is RecipientValidationLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Enter EU Pay ID', style: AppTypography.headlineMedium),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Enter the recipient\'s EU Pay ID to send money.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xxl),
        EuTextField(
          controller: _idController,
          hint: 'e.g. EUXY98ZW76VU',
          prefixIcon: const Icon(Icons.person_search_outlined, size: 20),
          onSubmitted: (_) => _lookupRecipient(),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (isLoading) const Center(child: CircularProgressIndicator()),
        if (_verifiedRecipient != null && !isLoading)
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.primary),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primarySurface,
                  child: Text(
                    _verifiedRecipient!.fullName.substring(0, 2).toUpperCase(),
                    style: AppTypography.titleMedium.copyWith(color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_verifiedRecipient!.fullName, style: AppTypography.titleSmall),
                      Text(
                        '${_verifiedRecipient!.type} • ${_verifiedRecipient!.euPayId}',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle_rounded, color: AppColors.success),
              ],
            ),
          ),
        const Spacer(),
        if (_verifiedRecipient == null)
          EuPrimaryButton(
            label: 'Find Recipient',
            onPressed: _lookupRecipient,
            isLoading: isLoading,
          )
        else
          EuPrimaryButton(
            label: 'Continue',
            onPressed: () => setState(() => _step = 1),
          ),
      ],
    );
  }

  Widget _buildAmount() {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.section),
        Text(
          'Send to ${_verifiedRecipient?.fullName ?? ""}',
          style: AppTypography.titleMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xxl),
        EuAmountField(controller: _amountController, autofocus: true),
        const SizedBox(height: AppSpacing.xxl),
        EuTextField(controller: _noteController, hint: 'Add a note (optional)', maxLines: 2),
        const Spacer(),
        EuPrimaryButton(
          label: 'Review Transfer',
          onPressed: () {
            if (double.tryParse(_amountController.text) != null) {
              setState(() => _step = 2);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter an amount')),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildReview() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xxl),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: [
              Text('Transfer Summary', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.xxl),
              _Row('To', _verifiedRecipient?.fullName ?? ''),
              _Row('EU Pay ID', _verifiedRecipient?.euPayId ?? ''),
              _Row('Amount', '€${double.tryParse(_amountController.text)?.toStringAsFixed(2) ?? "0.00"}'),
              if (_noteController.text.isNotEmpty) _Row('Note', _noteController.text),
            ],
          ),
        ),
        const Spacer(),
        EuPrimaryButton(
          label: 'Confirm & Send',
          onPressed: _executeTransfer,
          isLoading: _isSending,
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);
  final String label, value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary)),
          Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
