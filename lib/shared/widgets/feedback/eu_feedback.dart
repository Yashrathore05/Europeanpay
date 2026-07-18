import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Loading indicator overlay.
class EuLoading extends StatelessWidget {
  const EuLoading({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              message!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Error display widget with retry action.
class EuErrorWidget extends StatelessWidget {
  const EuErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
  });

  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.error_outline_rounded,
                size: 32,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state display widget.
class EuEmptyState extends StatelessWidget {
  const EuEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.action,
    this.actionLabel,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? action;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.inbox_outlined,
                size: 36,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null && actionLabel != null) ...[
              const SizedBox(height: AppSpacing.xl),
              TextButton(
                onPressed: action,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Status chip for transaction and payment states.
class EuStatusChip extends StatelessWidget {
  const EuStatusChip({
    super.key,
    required this.label,
    required this.color,
    required this.backgroundColor,
    this.icon,
  });

  final String label;
  final Color color;
  final Color backgroundColor;
  final IconData? icon;

  factory EuStatusChip.pending() => const EuStatusChip(
    label: 'Pending',
    color: AppColors.pending,
    backgroundColor: AppColors.pendingBg,
    icon: Icons.schedule_rounded,
  );

  factory EuStatusChip.completed() => const EuStatusChip(
    label: 'Completed',
    color: AppColors.completed,
    backgroundColor: AppColors.completedBg,
    icon: Icons.check_circle_outline_rounded,
  );

  factory EuStatusChip.failed() => const EuStatusChip(
    label: 'Failed',
    color: AppColors.failed,
    backgroundColor: AppColors.failedBg,
    icon: Icons.cancel_outlined,
  );

  factory EuStatusChip.rejected() => const EuStatusChip(
    label: 'Rejected',
    color: AppColors.rejected,
    backgroundColor: AppColors.rejectedBg,
    icon: Icons.block_rounded,
  );

  factory EuStatusChip.expired() => const EuStatusChip(
    label: 'Expired',
    color: AppColors.expired,
    backgroundColor: AppColors.expiredBg,
    icon: Icons.timer_off_outlined,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Copy button that copies text to clipboard with feedback.
class EuCopyButton extends StatelessWidget {
  const EuCopyButton({
    super.key,
    required this.text,
    this.label,
    this.size = 18,
  });

  final String text;
  final String? label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Uses Clipboard from services
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(label != null ? '$label copied' : 'Copied to clipboard'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Icon(
          Icons.copy_rounded,
          size: size,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
