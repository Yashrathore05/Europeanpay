import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';
import '../../../../shared/widgets/inputs/eu_inputs.dart';

/// Forgot password screen — request OTP for password reset.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _requestReset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() => _isLoading = false);
      context.pushNamed(
        RouteNames.otpVerification,
        extra: {
          'email': _emailController.text,
          'purpose': 'forgot_password',
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xxl),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    size: 36,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  'Forgot Password?',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Enter your email address and we\'ll send you a verification code to reset your password.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                EuTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'Enter your registered email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined, size: 20),
                  validator: Validators.email,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _requestReset(),
                ),
                const Spacer(),
                EuPrimaryButton(
                  label: 'Send Reset Code',
                  onPressed: _requestReset,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
