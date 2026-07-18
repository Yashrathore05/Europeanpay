import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Primary action button with gradient background.
class EuPrimaryButton extends StatelessWidget {
  const EuPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.width,
    this.height,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? AppSpacing.buttonHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isEnabled && !isLoading
              ? AppColors.primaryGradient
              : null,
          color: !isEnabled || isLoading
              ? AppColors.primary.withValues(alpha: 0.4)
              : null,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: isEnabled && !isLoading
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: isEnabled && !isLoading ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Text(label, style: AppTypography.button),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Secondary outlined button.
class EuSecondaryButton extends StatelessWidget {
  const EuSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: AppSpacing.buttonHeight,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(label, style: AppTypography.button.copyWith(
                    color: AppColors.primary,
                  )),
                ],
              ),
      ),
    );
  }
}

/// Text-only button with optional icon.
class EuTextButton extends StatelessWidget {
  const EuTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: color ?? AppColors.primary),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: AppTypography.button.copyWith(
              color: color ?? AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
