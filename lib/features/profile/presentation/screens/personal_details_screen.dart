import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';
import '../../../../shared/widgets/inputs/eu_inputs.dart';
import '../../../authentication/application/auth_provider.dart';

class PersonalDetailsScreen extends ConsumerStatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  ConsumerState<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends ConsumerState<PersonalDetailsScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _initialized = false;
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final authState = ref.watch(authNotifierProvider);
      if (authState is Authenticated) {
        _firstNameController = TextEditingController(text: authState.user.firstName);
        _lastNameController = TextEditingController(text: authState.user.lastName);
        _emailController = TextEditingController(text: authState.user.email);
        _phoneController = TextEditingController(text: authState.user.phoneNumber);
        _initialized = true;
      }
    }
  }

  @override
  void dispose() {
    if (_initialized) {
      _firstNameController.dispose();
      _lastNameController.dispose();
      _emailController.dispose();
      _phoneController.dispose();
    }
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);
    await ref.read(authNotifierProvider.notifier).updateProfile(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
        );
    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile details updated successfully!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  void _showPhoneVerifyDialog() {
    final codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Verify Phone Number'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the 6-digit code sent to ${_phoneController.text}',
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            EuTextField(
              controller: codeController,
              label: 'Verification Code',
              hint: 'Enter 123456',
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (codeController.text == '123456') {
                final success = await ref
                    .read(authNotifierProvider.notifier)
                    .verifyPhone(codeController.text);
                if (success && ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Phone number verified!'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Invalid code. Try "123456"'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final authState = ref.watch(authNotifierProvider);
    final userVerified = authState is Authenticated ? authState.user.isVerified : false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Personal Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: EuTextField(
                    controller: _firstNameController,
                    label: 'First Name',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: EuTextField(
                    controller: _lastNameController,
                    label: 'Last Name',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            EuTextField(
              controller: _emailController,
              label: 'Email',
              enabled: false,
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: EuTextField(
                    controller: _phoneController,
                    label: 'Phone',
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  height: 48,
                  margin: const EdgeInsets.only(bottom: 2),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: userVerified ? AppColors.successLight : AppColors.primary,
                      foregroundColor: userVerified ? AppColors.success : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                    ),
                    onPressed: userVerified ? null : _showPhoneVerifyDialog,
                    child: Text(userVerified ? 'Verified' : 'Verify'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxxl),
            EuPrimaryButton(
              label: 'Save Changes',
              isLoading: _isSaving,
              onPressed: _saveChanges,
            ),
          ],
        ),
      ),
    );
  }
}
