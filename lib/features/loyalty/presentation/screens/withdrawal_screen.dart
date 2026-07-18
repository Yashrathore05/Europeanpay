import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';
import '../../../../shared/widgets/inputs/eu_inputs.dart';
import '../../../bank_accounts/application/bank_accounts_provider.dart';
import '../../application/loyalty_provider.dart';

class WithdrawalScreen extends ConsumerStatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  ConsumerState<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends ConsumerState<WithdrawalScreen> {
  int _selectedPreset = -1;
  final _presets = [500, 1000, 2000, 5000];
  final _amountController = TextEditingController();
  bool _isWithdrawing = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _executeWithdrawal(int pointsToWithdraw) async {
    setState(() => _isWithdrawing = true);
    final success =
        await ref.read(loyaltyNotifierProvider.notifier).withdraw(pointsToWithdraw);
    if (mounted) {
      setState(() => _isWithdrawing = false);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Withdrew $pointsToWithdraw points (€${(pointsToWithdraw * 0.01).toStringAsFixed(2)}) successfully!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Withdrawal failed. Check your points balance.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loyaltyState = ref.watch(loyaltyNotifierProvider);
    final bankAccountsState = ref.watch(bankAccountsNotifierProvider);

    final pointsBalance = loyaltyState.maybeWhen(
      data: (data) => data.pointsBalance,
      orElse: () => 0,
    );

    final primaryBank = bankAccountsState.maybeWhen(
      data: (list) {
        final matches = list.where((acc) => acc.isPrimary);
        return matches.isNotEmpty ? matches.first : (list.isNotEmpty ? list.first : null);
      },
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Withdraw Points')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Eligible for withdrawal (€75 merchant spend)',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.successDark),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Available: $pointsBalance pts (€${(pointsBalance * 0.01).toStringAsFixed(2)})',
              style: AppTypography.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_presets.length, (index) {
                final preset = _presets[index];
                return ChoiceChip(
                  label: Text('$preset pts'),
                  selected: _selectedPreset == index,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedPreset = index;
                        _amountController.text = preset.toString();
                      });
                    }
                  },
                );
              }),
            ),
            const SizedBox(height: AppSpacing.xl),
            EuTextField(
              controller: _amountController,
              label: 'Points Amount',
              hint: 'Min 500',
              keyboardType: TextInputType.number,
              onChanged: (_) {
                setState(() => _selectedPreset = -1);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            if (_amountController.text.isNotEmpty)
              Text(
                'EUR Value: €${((int.tryParse(_amountController.text) ?? 0) * 0.01).toStringAsFixed(2)}',
                style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
              ),
            const SizedBox(height: AppSpacing.xl),
            Text('Withdraw to bank account', style: AppTypography.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            if (primaryBank != null)
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_outlined, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${primaryBank.bankName} - ${primaryBank.accountName}',
                              style: AppTypography.titleSmall),
                          Text(
                            primaryBank.iban,
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.error),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.error),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'No linked bank account. Connect a bank first.',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),
            const Spacer(),
            EuPrimaryButton(
              label: 'Withdraw Points',
              isLoading: _isWithdrawing,
              onPressed: primaryBank == null
                  ? null
                  : () {
                      final amount = int.tryParse(_amountController.text) ?? 0;
                      if (amount < 500) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Minimum withdrawal is 500 points.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      if (amount > pointsBalance) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Insufficient points balance.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      _executeWithdrawal(amount);
                    },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
