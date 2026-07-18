import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';
import '../../../../shared/widgets/inputs/eu_inputs.dart';
import '../../application/auth_provider.dart';

/// Sign up wizard with full registration fields.
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _referralController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String _countryCode = '+33';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _referralController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final success = await ref.read(authNotifierProvider.notifier).signUp(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: '$_countryCode${_phoneController.text.trim()}',
          referralCode: _referralController.text.trim().isEmpty
              ? null
              : _referralController.text.trim(),
          password: _passwordController.text,
        );
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        context.pushNamed(
          RouteNames.otpVerification,
          extra: {
            'email': _emailController.text.trim(),
            'purpose': 'registration',
          },
        );
      } else {
        final authState = ref.read(authNotifierProvider);
        String errorMsg = 'Registration failed. Please try again.';
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Account',
                  style: AppTypography.displaySmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Join European Pay and start transacting across Europe',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // Name row
                Row(
                  children: [
                    Expanded(
                      child: EuTextField(
                        controller: _firstNameController,
                        label: 'First Name',
                        hint: 'Jean',
                        validator: (v) =>
                            Validators.name(v, 'First name'),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: EuTextField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        hint: 'Dupont',
                        validator: (v) =>
                            Validators.name(v, 'Last name'),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // Email
                EuTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'jean@example.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined, size: 20),
                  validator: Validators.email,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Phone with country code
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone Number',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        // Country code selector
                        Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMd,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _countryCode,
                              items: const [
                                DropdownMenuItem(
                                  value: '+33',
                                  child: Text('🇫🇷 +33'),
                                ),
                                DropdownMenuItem(
                                  value: '+49',
                                  child: Text('🇩🇪 +49'),
                                ),
                                DropdownMenuItem(
                                  value: '+34',
                                  child: Text('🇪🇸 +34'),
                                ),
                                DropdownMenuItem(
                                  value: '+39',
                                  child: Text('🇮🇹 +39'),
                                ),
                                DropdownMenuItem(
                                  value: '+31',
                                  child: Text('🇳🇱 +31'),
                                ),
                                DropdownMenuItem(
                                  value: '+32',
                                  child: Text('🇧🇪 +32'),
                                ),
                                DropdownMenuItem(
                                  value: '+44',
                                  child: Text('🇬🇧 +44'),
                                ),
                              ],
                              onChanged: (v) =>
                                  setState(() => _countryCode = v!),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            validator: Validators.phone,
                            textInputAction: TextInputAction.next,
                            style: AppTypography.bodyLarge,
                            decoration: const InputDecoration(
                              hintText: '6 12 34 56 78',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // Referral code (optional)
                EuTextField(
                  controller: _referralController,
                  label: 'Referral Code (Optional)',
                  hint: 'Enter referral code',
                  prefixIcon: const Icon(Icons.card_giftcard_outlined, size: 20),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Password
                EuTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Min 8 characters',
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
                  validator: Validators.password,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Confirm password
                EuTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  obscureText: _obscureConfirm,
                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  validator: (v) =>
                      Validators.confirmPassword(v, _passwordController.text),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: AppSpacing.xxxl),

                EuPrimaryButton(
                  label: 'Create Account',
                  onPressed: _signUp,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: AppSpacing.xl),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.goNamed(RouteNames.login),
                        child: Text(
                          'Sign In',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
