import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/inputs/eu_inputs.dart';

class TwoFactorScreen extends StatefulWidget {
  const TwoFactorScreen({super.key});
  @override
  State<TwoFactorScreen> createState() => _TwoFactorScreenState();
}

class _TwoFactorScreenState extends State<TwoFactorScreen> {
  bool _isLoading = false;
  bool _canResend = false;
  int _resendSeconds = AppConstants.otpResendSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _resendSeconds = AppConstants.otpResendSeconds;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        setState(() => _canResend = true);
        t.cancel();
      }
    });
  }

  Future<void> _verify(String code) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() => _isLoading = false);
      context.goNamed(RouteNames.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xxl),
              Container(
                width: 72, height: 72,
                decoration: const BoxDecoration(color: AppColors.primarySurface, shape: BoxShape.circle),
                child: const Icon(Icons.security_rounded, size: 36, color: AppColors.primary),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('Two-Factor Authentication', style: AppTypography.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.sm),
              Text('Enter the 6-digit code sent to your phone.', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xxxl),
              EuOtpField(length: AppConstants.otpLength, onCompleted: _verify),
              const SizedBox(height: AppSpacing.xxl),
              if (_isLoading) const CircularProgressIndicator(),
              const Spacer(),
              GestureDetector(
                onTap: _canResend ? _startTimer : null,
                child: Text(_canResend ? 'Resend Code' : 'Resend in ${_resendSeconds}s', style: AppTypography.bodyMedium.copyWith(color: _canResend ? AppColors.primary : AppColors.textTertiary, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }
}
