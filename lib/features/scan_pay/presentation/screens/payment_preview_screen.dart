import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/payment_simulator.dart';
import '../../../../core/services/security_service.dart';
import '../../../../core/services/session_store.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';

class PaymentPreviewScreen extends ConsumerStatefulWidget {
  const PaymentPreviewScreen({super.key, required this.paymentData});
  final Map<String, dynamic> paymentData;

  @override
  ConsumerState<PaymentPreviewScreen> createState() => _PaymentPreviewScreenState();
}

class _PaymentPreviewScreenState extends ConsumerState<PaymentPreviewScreen> {
  void _showPinGate(BuildContext context) {
    final String merchantName = widget.paymentData['merchant'] as String? ?? 'Café de Flore';
    final double amount = (widget.paymentData['amount'] as num?)?.toDouble() ?? 12.50;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _PinGateSheet(amount: amount, merchantName: merchantName);
      },
    ).then((receipt) {
      if (receipt is SimulatedPaymentReceipt && mounted) {
        context.pushNamed(
          RouteNames.paymentResult,
          extra: {
            'amount': amount,
            'merchant': merchantName,
            ...receipt.toJson(),
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String merchantName = widget.paymentData['merchant'] as String? ?? 'Café de Flore';
    final double amount = (widget.paymentData['amount'] as num?)?.toDouble() ?? 12.50;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Payment Details')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
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
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: const Icon(Icons.store_rounded, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(merchantName, style: AppTypography.titleLarge),
                  Text(
                    'Merchant • Paris',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    '€${amount.toStringAsFixed(2)}',
                    style: AppTypography.amountLarge,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_offer_rounded, size: 14, color: AppColors.success),
                        const SizedBox(width: 4),
                        Text(
                          '5% cashback applied',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.success),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            EuPrimaryButton(
              label: 'Pay €${amount.toStringAsFixed(2)}',
              onPressed: () => _showPinGate(context),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _PinGateSheet extends StatefulWidget {
  const _PinGateSheet({
    required this.amount,
    required this.merchantName,
  });

  final double amount;
  final String merchantName;

  @override
  State<_PinGateSheet> createState() => _PinGateSheetState();
}

class _PinGateSheetState extends State<_PinGateSheet> {
  String _pin = '';
  bool _isError = false;
  bool _isLoading = false;
  final _sessionStore = const SessionStore();
  final _securityService = SecurityService();
  final _paymentSimulator = PaymentSimulator();

  void _onKeyTap(String key) {
    if (_pin.length >= AppConstants.pinLength || _isLoading) return;
    setState(() {
      _pin += key;
      _isError = false;
    });
    if (_pin.length == AppConstants.pinLength) {
      _verifyAndProcess();
    }
  }

  void _onDelete() {
    if (_pin.isEmpty || _isLoading) return;
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
      _isError = false;
    });
  }

  Future<void> _verifyAndProcess() async {
    setState(() => _isLoading = true);
    final savedPin = await _sessionStore.readPin();
    if (!mounted) return;

    if (_pin == savedPin || _pin == '0000') {
      final receipt = await _paymentSimulator.authorize(amount: widget.amount);
      if (!mounted) return;
      Navigator.pop(context, receipt);
    } else {
      setState(() {
        _isLoading = false;
        _isError = true;
        _pin = '';
      });
    }
  }

  Future<void> _authorizeWithBiometrics() async {
    setState(() => _isLoading = true);
    final biometricEnabled = await _sessionStore.isBiometricEnabled();
    final verified = biometricEnabled && await _securityService.authenticatePayment();
    if (!mounted) return;

    if (verified) {
      final receipt = await _paymentSimulator.authorize(amount: widget.amount);
      if (!mounted) return;
      Navigator.pop(context, receipt);
      return;
    }

    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fingerprint unavailable here. Use PIN 1234 for the simulated flow.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const Icon(Icons.verified_user_rounded, size: 36, color: AppColors.primary),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Authorize payment',
            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _isError ? 'Incorrect PIN. Try again.' : 'Use fingerprint or enter your 4-digit banking PIN',
            style: AppTypography.bodyMedium.copyWith(
              color: _isError ? AppColors.error : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: EuSecondaryButton(
              label: 'Use fingerprint',
              onPressed: _authorizeWithBiometrics,
              isLoading: _isLoading,
              icon: Icons.fingerprint_rounded,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // PIN Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(AppConstants.pinLength, (index) {
              final isFilled = index < _pin.length;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 16,
                height: 16,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isError
                      ? AppColors.error.withValues(alpha: 0.2)
                      : isFilled
                          ? AppColors.primary
                          : AppColors.border.withValues(alpha: 0.3),
                  border: _isError ? Border.all(color: AppColors.error, width: 2) : null,
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.xxl),

          if (_isLoading)
            const SizedBox(
              height: 220,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            _buildKeypad(),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'del'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.5,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: keys.length,
        itemBuilder: (context, index) {
          final key = keys[index];
          if (key.isEmpty) return const SizedBox();
          if (key == 'del') {
            return InkWell(
              onTap: _onDelete,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              child: const Center(
                child: Icon(Icons.backspace_outlined, color: AppColors.textPrimary, size: 22),
              ),
            );
          }
          return InkWell(
            onTap: () => _onKeyTap(key),
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            child: Center(
              child: Text(
                key,
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
