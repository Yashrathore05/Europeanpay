import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';
import '../../../settings/application/settings_provider.dart';

class NotificationPreferencesScreen extends ConsumerStatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  ConsumerState<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends ConsumerState<NotificationPreferencesScreen> {
  bool _push = true;
  bool _email = true;
  bool _sms = false;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Notification Preferences')),
      body: settingsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Failed to load preferences')),
        data: (settings) {
          if (!_initialized) {
            _push = settings.pushNotificationsEnabled;
            _email = settings.emailNotificationsEnabled;
            _sms = settings.smsNotificationsEnabled;
            _initialized = true;
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.pagePaddingH),
                child: Row(
                  children: [
                    _PresetChip('Enable All', () {
                      setState(() {
                        _push = true;
                        _email = true;
                        _sms = true;
                      });
                    }),
                    const SizedBox(width: 8),
                    _PresetChip('Critical Only', () {
                      setState(() {
                        _push = true;
                        _email = false;
                        _sms = false;
                      });
                    }),
                    const SizedBox(width: 8),
                    _PresetChip('Mute All', () {
                      setState(() {
                        _push = false;
                        _email = false;
                        _sms = false;
                      });
                    }),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingH),
                  children: [
                    _buildSwitchTile(
                      title: 'Push Notifications',
                      subtitle: 'Receive real-time alerts for payments, claims, and security.',
                      value: _push,
                      onChanged: (val) => setState(() => _push = val),
                    ),
                    const Divider(),
                    _buildSwitchTile(
                      title: 'Email Notifications',
                      subtitle: 'Receive monthly statements, receipt PDFs, and news.',
                      value: _email,
                      onChanged: (val) => setState(() => _email = val),
                    ),
                    const Divider(),
                    _buildSwitchTile(
                      title: 'SMS Alerts',
                      subtitle: 'Receive urgent security warnings via SMS text messages.',
                      value: _sms,
                      onChanged: (val) => setState(() => _sms = val),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: EuPrimaryButton(
                  label: 'Save Preferences',
                  onPressed: () async {
                    final notifier = ref.read(settingsNotifierProvider.notifier);
                    await notifier.updatePush(_push);
                    await notifier.updateEmail(_email);
                    await notifier.updateSms(_sms);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Preferences saved successfully'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.success,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: AppTypography.bodyMedium),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
      ),
      activeColor: AppColors.primary,
      contentPadding: EdgeInsets.zero,
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Text(label, style: AppTypography.labelSmall),
      ),
    );
  }
}
