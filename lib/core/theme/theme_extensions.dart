import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

/// Custom theme extension for accessing European Pay design tokens
/// directly from BuildContext via Theme.of(context).extension<EuPayTheme>().
class EuPayTheme extends ThemeExtension<EuPayTheme> {
  const EuPayTheme({
    required this.cardGradient,
    required this.loyaltyGradient,
    required this.successGradient,
    required this.primaryGradient,
    required this.statusPending,
    required this.statusPendingBg,
    required this.statusCompleted,
    required this.statusCompletedBg,
    required this.statusFailed,
    required this.statusFailedBg,
    required this.statusRejected,
    required this.statusRejectedBg,
    required this.statusExpired,
    required this.statusExpiredBg,
    required this.gold,
    required this.goldLight,
  });

  final LinearGradient cardGradient;
  final LinearGradient loyaltyGradient;
  final LinearGradient successGradient;
  final LinearGradient primaryGradient;
  final Color statusPending;
  final Color statusPendingBg;
  final Color statusCompleted;
  final Color statusCompletedBg;
  final Color statusFailed;
  final Color statusFailedBg;
  final Color statusRejected;
  final Color statusRejectedBg;
  final Color statusExpired;
  final Color statusExpiredBg;
  final Color gold;
  final Color goldLight;

  static const EuPayTheme light = EuPayTheme(
    cardGradient: AppColors.cardGradient,
    loyaltyGradient: AppColors.loyaltyGradient,
    successGradient: AppColors.successGradient,
    primaryGradient: AppColors.primaryGradient,
    statusPending: AppColors.pending,
    statusPendingBg: AppColors.pendingBg,
    statusCompleted: AppColors.completed,
    statusCompletedBg: AppColors.completedBg,
    statusFailed: AppColors.failed,
    statusFailedBg: AppColors.failedBg,
    statusRejected: AppColors.rejected,
    statusRejectedBg: AppColors.rejectedBg,
    statusExpired: AppColors.expired,
    statusExpiredBg: AppColors.expiredBg,
    gold: AppColors.gold,
    goldLight: AppColors.goldLight,
  );

  @override
  ThemeExtension<EuPayTheme> copyWith({
    LinearGradient? cardGradient,
    LinearGradient? loyaltyGradient,
    LinearGradient? successGradient,
    LinearGradient? primaryGradient,
    Color? statusPending,
    Color? statusPendingBg,
    Color? statusCompleted,
    Color? statusCompletedBg,
    Color? statusFailed,
    Color? statusFailedBg,
    Color? statusRejected,
    Color? statusRejectedBg,
    Color? statusExpired,
    Color? statusExpiredBg,
    Color? gold,
    Color? goldLight,
  }) {
    return EuPayTheme(
      cardGradient: cardGradient ?? this.cardGradient,
      loyaltyGradient: loyaltyGradient ?? this.loyaltyGradient,
      successGradient: successGradient ?? this.successGradient,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      statusPending: statusPending ?? this.statusPending,
      statusPendingBg: statusPendingBg ?? this.statusPendingBg,
      statusCompleted: statusCompleted ?? this.statusCompleted,
      statusCompletedBg: statusCompletedBg ?? this.statusCompletedBg,
      statusFailed: statusFailed ?? this.statusFailed,
      statusFailedBg: statusFailedBg ?? this.statusFailedBg,
      statusRejected: statusRejected ?? this.statusRejected,
      statusRejectedBg: statusRejectedBg ?? this.statusRejectedBg,
      statusExpired: statusExpired ?? this.statusExpired,
      statusExpiredBg: statusExpiredBg ?? this.statusExpiredBg,
      gold: gold ?? this.gold,
      goldLight: goldLight ?? this.goldLight,
    );
  }

  @override
  ThemeExtension<EuPayTheme> lerp(
    covariant ThemeExtension<EuPayTheme>? other,
    double t,
  ) {
    if (other is! EuPayTheme) return this;
    return EuPayTheme(
      cardGradient: LinearGradient.lerp(cardGradient, other.cardGradient, t)!,
      loyaltyGradient:
          LinearGradient.lerp(loyaltyGradient, other.loyaltyGradient, t)!,
      successGradient:
          LinearGradient.lerp(successGradient, other.successGradient, t)!,
      primaryGradient:
          LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      statusPending: Color.lerp(statusPending, other.statusPending, t)!,
      statusPendingBg: Color.lerp(statusPendingBg, other.statusPendingBg, t)!,
      statusCompleted:
          Color.lerp(statusCompleted, other.statusCompleted, t)!,
      statusCompletedBg:
          Color.lerp(statusCompletedBg, other.statusCompletedBg, t)!,
      statusFailed: Color.lerp(statusFailed, other.statusFailed, t)!,
      statusFailedBg: Color.lerp(statusFailedBg, other.statusFailedBg, t)!,
      statusRejected: Color.lerp(statusRejected, other.statusRejected, t)!,
      statusRejectedBg:
          Color.lerp(statusRejectedBg, other.statusRejectedBg, t)!,
      statusExpired: Color.lerp(statusExpired, other.statusExpired, t)!,
      statusExpiredBg: Color.lerp(statusExpiredBg, other.statusExpiredBg, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      goldLight: Color.lerp(goldLight, other.goldLight, t)!,
    );
  }
}
