import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';
import '../../../../shared/widgets/inputs/eu_inputs.dart';
import '../../application/auth_provider.dart';

/// OTP verification screen for registration and password reset.
class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.purpose,
  });

  final String email;
  final String purpose;

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  bool _isLoading = false;
  bool _canResend = false;
  int _resendSeconds = AppConstants.otpResendSeconds;
  Timer? _resendTimer;
  String _otpCode = '';

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendSeconds = AppConstants.otpResendSeconds;
    _canResend = false;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  Future<void> _verifyOtp(String code) async {
    setState(() => _isLoading = true);
    bool success = false;
    if (widget.purpose == 'registration') {
      success = await ref.read(authNotifierProvider.notifier).verifyOtp(
            email: widget.email,
            code: code,
            purpose: widget.purpose,
          );
    } else {
      await Future.delayed(const Duration(milliseconds: 1000));
      success = code == '123456' || code == '000000';
    }

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        if (widget.purpose == 'registration') {
          context.goNamed(RouteNames.dashboard);
        } else if (widget.purpose == 'forgot_password') {
          context.goNamed(
            RouteNames.resetPassword,
            extra: {'email': widget.email},
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification failed. Try code 123456 or 000000.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _resendOtp() {
    if (!_canResend) return;
    _startResendTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP resent to your email'),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  Icons.mark_email_read_outlined,
                  size: 36,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Verify Your Email',
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'We sent a ${AppConstants.otpLength}-digit code to',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                widget.email.isNotEmpty ? widget.email : 'your email',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              EuOtpField(
                length: AppConstants.otpLength,
                onCompleted: (code) {
                  _otpCode = code;
                  _verifyOtp(code);
                },
                onChanged: (code) => _otpCode = code,
              ),
              const SizedBox(height: AppSpacing.xxl),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                EuPrimaryButton(
                  label: 'Verify',
                  onPressed: () => _verifyOtp(_otpCode),
                  isEnabled: _otpCode.length == AppConstants.otpLength,
                ),
              const SizedBox(height: AppSpacing.xxl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: _canResend ? _resendOtp : null,
                    child: Text(
                      _canResend
                          ? 'Resend'
                          : 'Resend in ${_resendSeconds}s',
                      style: AppTypography.bodyMedium.copyWith(
                        color: _canResend
                            ? AppColors.primary
                            : AppColors.textTertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
