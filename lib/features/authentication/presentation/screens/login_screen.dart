import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/security_service.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/branding/eu_brand_mark.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';
import '../../../../shared/widgets/inputs/eu_inputs.dart';
import '../../application/auth_provider.dart';

/// Login screen with email/password, remember me, and forgot password.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _isBiometricLoading = false;
  final _securityService = SecurityService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final success = await ref.read(authNotifierProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text,
        );
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        context.goNamed(RouteNames.dashboard);
      } else {
        final authState = ref.read(authNotifierProvider);
        String errorMsg = 'Login failed. Please check your credentials.';
        if (authState is Unauthenticated && authState.error != null) {
          errorMsg = authState.error!;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _unlockWithBiometrics() async {
    setState(() => _isBiometricLoading = true);
    final verified = await _securityService.authenticatePayment();
    if (!mounted) return;

    setState(() => _isBiometricLoading = false);
    final authState = ref.read(authNotifierProvider);
    if (verified && authState is Authenticated) {
      context.goNamed(RouteNames.dashboard);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No saved secure session found. Sign in once to enable biometric unlock.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.section),
                const EuBrandMark(size: 54, showWordmark: true),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  'Welcome back',
                  style: AppTypography.displaySmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Sign in to your European Pay account',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // Email
                EuTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined, size: 20),
                  validator: Validators.email,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Password
                EuTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) => Validators.required(v, 'Password'),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _login(),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Remember me & Forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (v) =>
                                setState(() => _rememberMe = v ?? false),
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Remember me',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () =>
                          context.pushNamed(RouteNames.forgotPassword),
                      child: Text(
                        'Forgot Password?',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Login button
                EuPrimaryButton(
                  label: 'Sign In',
                  onPressed: _login,
                  isLoading: _isLoading,
                  icon: Icons.lock_open_rounded,
                ),
                const SizedBox(height: AppSpacing.md),
                EuSecondaryButton(
                  label: 'Use fingerprint',
                  onPressed: _unlockWithBiometrics,
                  isLoading: _isBiometricLoading,
                  icon: Icons.fingerprint_rounded,
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Sign up link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.goNamed(RouteNames.signUp),
                        child: Text(
                          'Sign Up',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
