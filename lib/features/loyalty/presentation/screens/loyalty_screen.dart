import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../domain/models/loyalty_details.dart';
import '../application/loyalty_provider.dart';

class LoyaltyScreen extends ConsumerWidget {
  const LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loyaltyState = ref.watch(loyaltyNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('EU Pay Points')),
      body: loyaltyState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Failed to load loyalty details')),
        data: (loyalty) {
          return RefreshIndicator(
            onRefresh: () => ref.read(loyaltyNotifierProvider.notifier).load(),
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.pagePaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Points card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    decoration: BoxDecoration(
                      gradient: AppColors.loyaltyGradient,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.white, size: 28),
                            const SizedBox(width: 8),
                            Text(
                              'EU Pay Points',
                              style: AppTypography.titleMedium.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          _formatPoints(loyalty.pointsBalance),
                          style: AppTypography.amountLarge.copyWith(color: Colors.white),
                        ),
                        Text(
                          'Worth €${loyalty.eurValue.toStringAsFixed(2)}',
                          style: AppTypography.bodyMedium.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          children: [
                            _PointStat('Pending', '${loyalty.pendingPoints}'),
                            const SizedBox(width: AppSpacing.xl),
                            _PointStat('This Month', '+${loyalty.earnedThisMonth}'),
                            const SizedBox(width: AppSpacing.xl),
                            _PointStat('Streak', '🔥 ${loyalty.streakDays} days'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // VIP Tier
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('VIP Tier', style: AppTypography.titleSmall),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.goldLight,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                              ),
                              child: Text(
                                loyalty.vipTier,
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '+${loyalty.cashbackExtraPercentage.toStringAsFixed(0)}% extra cashback on all payments',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        LinearProgressIndicator(
                          value: loyalty.nextTierProgress,
                          backgroundColor: AppColors.surfaceVariant,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '€${loyalty.nextTierPoints} / €${loyalty.nextTierTarget} to ${loyalty.nextTierName}',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Stats
                  Row(
                    children: [
                      _StatBox(
                        'Lifetime\nEarned',
                        _formatPoints(loyalty.lifetimeEarned),
                        Icons.trending_up_rounded,
                        AppColors.success,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _StatBox(
                        'Lifetime\nRedeemed',
                        _formatPoints(loyalty.lifetimeRedeemed),
                        Icons.redeem_rounded,
                        AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Menu
                  _MenuItem(
                    'Points History',
                    Icons.history_rounded,
                    () => context.pushNamed(RouteNames.pointsHistory),
                  ),
                  _MenuItem(
                    'Reward Rules',
                    Icons.rule_rounded,
                    () => context.pushNamed(RouteNames.rewardRules),
                  ),
                  _MenuItem(
                    'Referral Program',
                    Icons.people_outline_rounded,
                    () => context.pushNamed(RouteNames.referral),
                  ),
                  _MenuItem(
                    'Membership',
                    Icons.card_membership_rounded,
                    () => context.pushNamed(RouteNames.membership),
                  ),
                  _MenuItem(
                    'Withdraw Points',
                    Icons.account_balance_wallet_outlined,
                    () => context.pushNamed(RouteNames.withdrawal),
                  ),
                  _MenuItem(
                    'Terms & Conditions',
                    Icons.description_outlined,
                    () => context.pushNamed(RouteNames.loyaltyTerms),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Recent activity
                  Text('Recent Activity', style: AppTypography.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  if (loyalty.recentActivity.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No recent activity',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                        ),
                      ),
                    )
                  else
                    ...loyalty.recentActivity.map((activity) {
                      final isPositive = activity.points > 0;
                      final pointsColor = isPositive
                          ? AppColors.success
                          : activity.points < 0
                              ? AppColors.error
                              : AppColors.textSecondary;
                      final prefix = isPositive ? '+' : '';

                      return Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(activity.title, style: AppTypography.bodyMedium),
                                  const SizedBox(height: 2),
                                  Text(
                                    _formatDate(activity.date),
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '$prefix${activity.points} pts',
                              style: AppTypography.titleSmall.copyWith(
                                color: pointsColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  const SizedBox(height: AppSpacing.xxxl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatPoints(int points) {
    return points.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _PointStat extends StatelessWidget {
  const _PointStat(this.label, this.value);
  final String label, value;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelSmall.copyWith(color: Colors.white60)),
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox(this.label, this.value, this.icon, this.color);
  final String label, value;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: AppSpacing.sm),
            Text(value, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
            Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
          ],
        ),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
