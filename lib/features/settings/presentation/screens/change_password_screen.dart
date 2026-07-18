import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';
import '../../../../shared/widgets/inputs/eu_inputs.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose a strong password with at least 8 characters containing letters, numbers, and symbols.',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Current Password
                EuTextField(
                  controller: _currentPasswordController,
                  label: 'Current Password',
                  hint: 'Enter your current password',
                  obscureText: _obscureCurrent,
                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCurrent ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                  validator: (v) => Validators.required(v, 'Current Password'),
                ),
                const SizedBox(height: AppSpacing.xl),

                // New Password
                EuTextField(
                  controller: _newPasswordController,
                  label: 'New Password',
                  hint: 'Min 8 characters',
                  obscureText: _obscureNew,
                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNew ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                  validator: Validators.password,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Confirm Password
                EuTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm New Password',
                  hint: 'Re-enter your new password',
                  obscureText: _obscureConfirm,
                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  validator: (v) => Validators.confirmPassword(v, _newPasswordController.text),
                ),

                const Spacer(),

                EuPrimaryButton(
                  label: 'Update Password',
                  onPressed: _updatePassword,
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
