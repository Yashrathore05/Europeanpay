import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';
import '../../../authentication/application/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    if (authState is! Authenticated) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = authState.user;
    final initials = (user.firstName.isNotEmpty ? user.firstName[0] : '') +
        (user.lastName.isNotEmpty ? user.lastName[0] : '');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              // Reload user session
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primarySurface,
              child: Text(
                initials.toUpperCase(),
                style: AppTypography.displaySmall.copyWith(color: AppColors.primary),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(user.fullName, style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: user.isVerified ? AppColors.successLight : AppColors.errorLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        user.isVerified ? Icons.verified_rounded : Icons.warning_amber_rounded,
                        size: 14,
                        color: user.isVerified ? AppColors.success : AppColors.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user.isVerified ? 'Verified' : 'Unverified',
                        style: AppTypography.labelSmall.copyWith(
                          color: user.isVerified ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            _ProfileRow('Email', user.email, Icons.email_outlined, copyable: true),
            _ProfileRow('Phone', user.phoneNumber, Icons.phone_outlined, copyable: true),
            _ProfileRow('Customer ID', user.id, Icons.badge_outlined, copyable: true),
            _ProfileRow('EU Pay ID', user.euPayId, Icons.qr_code_rounded, copyable: true),
            const SizedBox(height: AppSpacing.xxl),
            _MenuItem(
              'Personal Details',
              Icons.person_outline_rounded,
              () => context.pushNamed(RouteNames.personalDetails),
            ),
            _MenuItem(
              'Bank Accounts (${user.linkedBanksCount})',
              Icons.account_balance_outlined,
              () => context.pushNamed(RouteNames.bankAccounts),
            ),
            _MenuItem(
              'Notifications',
              Icons.notifications_outlined,
              () => context.pushNamed(RouteNames.notifications),
            ),
            _MenuItem(
              'Change PIN',
              Icons.pin_outlined,
              () => context.pushNamed(RouteNames.setupPin),
            ),
            _MenuItem(
              'Language Preferences',
              Icons.language_rounded,
              () => context.pushNamed(RouteNames.settings),
            ),
            _MenuItem(
              'Help & Support',
              Icons.help_outline_rounded,
              () {},
            ),
            _MenuItem(
              'Privacy Policy',
              Icons.privacy_tip_outlined,
              () {},
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Version 1.0.0',
              style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
            ),
            const SizedBox(height: AppSpacing.lg),
            EuTextButton(
              label: 'Sign Out',
              onPressed: () async {
                await ref.read(authNotifierProvider.notifier).logout();
                if (context.mounted) {
                  context.goNamed(RouteNames.login);
                }
              },
              icon: Icons.logout_rounded,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow(this.label, this.value, this.icon, {this.copyable = false});
  final String label, value;
  final IconData icon;
  final bool copyable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textTertiary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
                Text(
                  value,
                  style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (copyable)
            IconButton(
              icon: const Icon(Icons.copy_rounded, size: 16, color: AppColors.primary),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$label copied to clipboard'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem(this.label, this.icon, this.onTap);
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary, size: 22),
      title: Text(label, style: AppTypography.bodyMedium),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textTertiary),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
