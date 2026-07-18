import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';

/// Language selection screen — first launch.
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.section),
              Text(
                'Choose Your Language',
                style: AppTypography.displaySmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Select your preferred language to continue',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              _LanguageOption(
                flag: '🇬🇧',
                language: 'English',
                code: 'en',
                isSelected: _selectedLanguage == 'en',
                onTap: () => setState(() => _selectedLanguage = 'en'),
              ),
              const SizedBox(height: AppSpacing.md),
              _LanguageOption(
                flag: '🇫🇷',
                language: 'Français',
                code: 'fr',
                isSelected: _selectedLanguage == 'fr',
                onTap: () => setState(() => _selectedLanguage = 'fr'),
              ),
              const Spacer(),
              EuPrimaryButton(
                label: 'Continue',
                onPressed: () => context.goNamed(RouteNames.signUp),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.flag,
    required this.language,
    required this.code,
    required this.isSelected,
    required this.onTap,
  });

  final String flag;
  final String language;
  final String code;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySurface : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                  Text(
                    code.toUpperCase(),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
