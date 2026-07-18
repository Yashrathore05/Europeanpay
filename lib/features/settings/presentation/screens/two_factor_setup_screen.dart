import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';
import '../../../../shared/widgets/inputs/eu_inputs.dart';

class TwoFactorSetupScreen extends StatefulWidget {
  const TwoFactorSetupScreen({super.key});

  @override
  State<TwoFactorSetupScreen> createState() => _TwoFactorSetupScreenState();
}

class _TwoFactorSetupScreenState extends State<TwoFactorSetupScreen> {
  bool _isSmsEnabled = false;
  bool _isAuthAppEnabled = false;
  int _step = 0; // 0: setup choices, 1: verify app otp
  final _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.length < 6) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isAuthAppEnabled = true;
        _step = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Two-factor authenticator app enabled successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Two-Factor Auth (2FA)'),
      ),
      body: SafeArea(
        child: _step == 0 ? _buildSetupChoices() : _buildVerifyOtp(),
      ),
    );
  }

  Widget _buildSetupChoices() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: AppColors.primarySurface,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.security_rounded,
            size: 36,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Keep Your Account Secure',
          style: AppTypography.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Add an extra layer of protection by requiring a security code when you log in or complete sensitive operations.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xxxl),

        // SMS Option
        _buildMethodCard(
          title: 'SMS Verification',
          description: 'Receive a code via SMS to your registered phone number.',
          icon: Icons.sms_outlined,
          isEnabled: _isSmsEnabled,
          onChanged: (val) {
            setState(() => _isSmsEnabled = val);
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Auth App Option
        _buildMethodCard(
          title: 'Authenticator App',
          description: 'Use an app like Google Authenticator or Authy to generate codes.',
          icon: Icons.phonelink_setup_rounded,
          isEnabled: _isAuthAppEnabled,
          onChanged: (val) {
            if (val) {
              setState(() => _step = 1);
            } else {
              setState(() => _isAuthAppEnabled = false);
            }
          },
        ),
      ],
    );
  }

  Widget _buildVerifyOtp() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Link Authenticator App',
            style: AppTypography.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '1. Install Google Authenticator or Authy.\n2. Scan the barcode below, or enter the setup key manually.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Mock QR Code placeholder
          Center(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Image.network(
                'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=otpauth://totp/EuropeanPay:jean.dupont@email.com?secret=JBSWY3DPEHPK3PXP&issuer=EuropeanPay',
                width: 150,
                height: 150,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.qr_code_2_rounded,
                  size: 150,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Setup Key
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Setup Key', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
                      Text('JBSW Y3DP EHPK 3PXP', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, color: AppColors.primary, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Code Verification Input
          EuTextField(
            controller: _otpController,
            label: 'Enter Authenticator Code',
            hint: '6-digit code',
            keyboardType: TextInputType.number,
            prefixIcon: const Icon(Icons.security, size: 20),
            maxLength: 6,
          ),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _step = 0),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: EuPrimaryButton(
                  label: 'Verify & Enable',
                  onPressed: _verifyOtp,
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildMethodCard({
    required String title,
    required String description,
    required IconData icon,
    required bool isEnabled,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: isEnabled ? AppColors.primary : AppColors.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: isEnabled ? AppColors.primary : AppColors.textSecondary, size: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(description, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
