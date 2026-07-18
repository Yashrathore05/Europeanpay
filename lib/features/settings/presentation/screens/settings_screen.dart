import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../application/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: settingsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Failed to load settings')),
        data: (settings) {
          final displayLanguage = settings.language == 'fr' ? 'Français (FR)' : 'English (US)';
          final displayCurrency = settings.primaryCurrency == 'USD' ? 'US Dollar (\$)' : 'Euro (€)';

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            children: [
              // Section: Account
              _buildSectionHeader('Account'),
              _buildSettingTile(
                icon: Icons.person_outline_rounded,
                title: 'Personal Details',
                subtitle: 'Change name, email, and phone number',
                onTap: () => context.pushNamed(RouteNames.personalDetails),
              ),
              _buildSettingTile(
                icon: Icons.notifications_none_rounded,
                title: 'Notification Preferences',
                subtitle: 'Manage push, email, and SMS alerts',
                onTap: () => context.pushNamed(RouteNames.notificationPreferences),
              ),

              const Divider(height: AppSpacing.xxl),

              // Section: Security
              _buildSectionHeader('Security'),
              _buildSettingTile(
                icon: Icons.lock_outline_rounded,
                title: 'Change Password',
                subtitle: 'Update your login password',
                onTap: () => context.pushNamed(RouteNames.changePassword),
              ),
              _buildSettingTile(
                icon: Icons.pin_outlined,
                title: 'Setup PIN Lock',
                subtitle: 'Configure a 4-digit security PIN',
                onTap: () => context.pushNamed(RouteNames.setupPin),
              ),
              _buildSettingTile(
                icon: Icons.security_rounded,
                title: 'Two-Factor Authentication',
                subtitle: 'Add an extra layer of security',
                onTap: () => context.pushNamed(RouteNames.twoFactorSetup),
              ),
              SwitchListTile(
                value: settings.biometricsEnabled,
                onChanged: (val) {
                  ref.read(settingsNotifierProvider.notifier).updateBiometrics(val);
                },
                title: Text('Biometric Authentication', style: AppTypography.bodyMedium),
                subtitle: Text(
                  'Use Face ID / Fingerprint to log in',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                ),
                secondary: const Icon(Icons.fingerprint_rounded, color: AppColors.textSecondary),
                activeColor: AppColors.primary,
              ),

              const Divider(height: AppSpacing.xxl),

              // Section: Preferences
              _buildSectionHeader('Preferences'),
              _buildSettingTile(
                icon: Icons.language_rounded,
                title: 'App Language',
                subtitle: displayLanguage,
                onTap: () => _showLanguageDialog(settings.language),
              ),
              _buildSettingTile(
                icon: Icons.euro_rounded,
                title: 'Primary Currency',
                subtitle: displayCurrency,
                onTap: () => _showCurrencyDialog(settings.primaryCurrency),
              ),
              _buildSettingTile(
                icon: Icons.access_time_rounded,
                title: 'Timezone Preference',
                subtitle: settings.timezone,
                onTap: () => _showTimezoneDialog(settings.timezone),
              ),

              const Divider(height: AppSpacing.xxl),

              // Section: Support & Legal
              _buildSectionHeader('Support & Legal'),
              _buildSettingTile(
                icon: Icons.help_outline_rounded,
                title: 'Help Center',
                subtitle: 'FAQs and customer support chat',
                onTap: () => context.pushNamed(RouteNames.support),
              ),
              _buildSettingTile(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                onTap: () => context.pushNamed(RouteNames.termsOfService),
              ),
              _buildSettingTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () => context.pushNamed(RouteNames.privacyPolicy),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Delete Account Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingH),
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                  onPressed: _showDeleteAccountDialog,
                  icon: const Icon(Icons.delete_forever_rounded),
                  label: const Text('Delete Account'),
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pagePaddingH,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.textTertiary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title, style: AppTypography.bodyMedium),
      subtitle: subtitle != null
          ? Text(subtitle, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary))
          : null,
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 20),
      onTap: onTap,
    );
  }

  void _showLanguageDialog(String currentLang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English (US)'),
              value: 'en',
              groupValue: currentLang,
              onChanged: (val) {
                if (val != null) {
                  ref.read(settingsNotifierProvider.notifier).updateLanguage(val);
                  Navigator.pop(ctx);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Français (FR)'),
              value: 'fr',
              groupValue: currentLang,
              onChanged: (val) {
                if (val != null) {
                  ref.read(settingsNotifierProvider.notifier).updateLanguage(val);
                  Navigator.pop(ctx);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyDialog(String currentCurrency) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Primary Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Euro (€)'),
              value: 'EUR',
              groupValue: currentCurrency,
              onChanged: (val) {
                if (val != null) {
                  ref.read(settingsNotifierProvider.notifier).updateCurrency(val);
                  Navigator.pop(ctx);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('US Dollar (\$)'),
              value: 'USD',
              groupValue: currentCurrency,
              onChanged: (val) {
                if (val != null) {
                  ref.read(settingsNotifierProvider.notifier).updateCurrency(val);
                  Navigator.pop(ctx);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTimezoneDialog(String currentTimezone) {
    final zones = ['CET', 'GMT', 'EST', 'PST', 'JST'];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Timezone'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: zones
              .map((z) => RadioListTile<String>(
                    title: Text(z),
                    value: z,
                    groupValue: currentTimezone,
                    onChanged: (val) {
                      if (val != null) {
                        ref.read(settingsNotifierProvider.notifier).updateTimezone(val);
                        Navigator.pop(ctx);
                      }
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action is permanent and cannot be undone. All balance and points will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              // Handle deletion simulation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion request submitted.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
