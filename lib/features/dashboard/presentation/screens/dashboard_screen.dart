import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../shared/widgets/branding/eu_brand_mark.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';
import '../../../authentication/application/auth_provider.dart';
import '../../../transactions/domain/models/transaction_model.dart';
import '../../application/dashboard_provider.dart';
import '../../domain/models/dashboard_data.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Future<void> _onRefresh() async {
    await ref.read(dashboardNotifierProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final dashboardState = ref.watch(dashboardNotifierProvider);

    final String greetingName = authState is Authenticated ? authState.user.fullName : 'Jean Dupont';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              backgroundColor: AppColors.surface,
              elevation: 0,
              leading: Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const EuBrandMark(size: 28),
                  const SizedBox(width: 8),
                  Text('EU Pay', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
              actions: [
                IconButton(
                  icon: Stack(
                    children: [
                      const Icon(Icons.notifications_outlined),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () => context.pushNamed(RouteNames.notifications),
                ),
              ],
            ),

            // Content Loading or Data
            dashboardState.when(
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
                      const SizedBox(height: AppSpacing.md),
                      Text('Failed to load dashboard data', style: AppTypography.titleMedium),
                      const SizedBox(height: AppSpacing.sm),
                      EuPrimaryButton(
                        label: 'Retry',
                        onPressed: () => ref.read(dashboardNotifierProvider.notifier).load(),
                      ),
                    ],
                  ),
                ),
              ),
              data: (data) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingH),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.lg),
                      // Greeting
                      Text('Good evening,', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      Text(greetingName, style: AppTypography.headlineMedium),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          const Icon(Icons.verified_user_rounded, size: 16, color: AppColors.success),
                          const SizedBox(width: 6),
                          Text(
                            'Simulated live banking workspace',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Wallet Balance Card
                      _WalletCard(
                        balance: data.walletBalance,
                        points: data.loyaltyPoints,
                        pointsValue: data.pointsCashValue,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // EU Pay ID
                      _EuPayIdBanner(euPayId: data.euPayId),
                      const SizedBox(height: AppSpacing.lg),

                      // Bank Link Status
                      _BankLinkBanner(banksCount: data.linkedBanksCount),
                      const SizedBox(height: AppSpacing.xxl),

                      // Quick Actions
                      Text('Quick Actions', style: AppTypography.titleMedium),
                      const SizedBox(height: AppSpacing.md),
                      _QuickActions(),
                      const SizedBox(height: AppSpacing.xxl),

                      // Loyalty Card
                      _LoyaltyCard(),
                      const SizedBox(height: AppSpacing.lg),

                      // Offers Card
                      _OffersCard(),
                      const SizedBox(height: AppSpacing.xxl),

                      // Transaction Summary
                      _TransactionSummary(
                        received: data.totalReceived,
                        sent: data.totalSent,
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Recent Transactions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recent Transactions', style: AppTypography.titleMedium),
                          TextButton(
                            onPressed: () => context.go('/transactions'),
                            child: const Text('See All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      ...data.recentTransactions.map((txn) => _TransactionTile(data: txn)),
                      const SizedBox(height: AppSpacing.xxxl),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  const _WalletCard({
    required this.balance,
    required this.points,
    required this.pointsValue,
  });

  final double balance;
  final int points;
  final double pointsValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Available balance', style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                ),
                child: Text('SEPA Instant', style: AppTypography.labelSmall.copyWith(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(balance.toEur, style: AppTypography.amountLarge.copyWith(color: Colors.white)),
          const SizedBox(height: AppSpacing.sm),
          Text('Main account • FR76 **** **** 0189', style: AppTypography.bodySmall.copyWith(color: Colors.white60)),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 16, color: AppColors.gold),
                    const SizedBox(width: 4),
                    Text('$points pts', style: AppTypography.labelSmall.copyWith(color: Colors.white)),
                    Text(' • ${pointsValue.toEur}', style: AppTypography.labelSmall.copyWith(color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EuPayIdBanner extends StatelessWidget {
  const _EuPayIdBanner({required this.euPayId});
  final String euPayId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(Icons.badge_outlined, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('EU Pay ID', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
                Text(euPayId, style: AppTypography.titleSmall.copyWith(letterSpacing: 0.5)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded, size: 20, color: AppColors.primary),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: euPayId));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('EU Pay ID copied to clipboard'),
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

class _BankLinkBanner extends StatelessWidget {
  const _BankLinkBanner({required this.banksCount});
  final int banksCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.secondarySurface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance_outlined, color: AppColors.secondaryDark, size: 22),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              '$banksCount bank accounts linked',
              style: AppTypography.bodySmall.copyWith(color: AppColors.secondaryDark, fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () => context.pushNamed(RouteNames.bankAccounts),
            child: const Text('Manage'),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(Icons.qr_code_rounded, 'My QR', () => context.pushNamed(RouteNames.myQr)),
      _QuickAction(Icons.send_rounded, 'Send', () => context.pushNamed(RouteNames.euPayIdTransfer)),
      _QuickAction(Icons.people_outline_rounded, 'Network', () => context.pushNamed(RouteNames.myNetwork)),
      _QuickAction(Icons.account_balance_outlined, 'Banks', () => context.pushNamed(RouteNames.bankAccounts)),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions
          .map((a) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: a.onTap,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                            ),
                            child: Icon(a.icon, color: AppColors.primary, size: 22),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(a.label, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _QuickAction {
  const _QuickAction(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

class _LoyaltyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(RouteNames.loyalty),
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: AppColors.loyaltyGradient,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Row(
          children: [
            const Icon(Icons.star_rounded, color: Colors.white, size: 32),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('EU Pay Loyalty', style: AppTypography.titleSmall.copyWith(color: Colors.white)),
                  Text('Earn 3% cashback on every payment', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 16),
          ],
        ),
      ),
    );
  }
}

class _OffersCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(RouteNames.offers),
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: const Icon(Icons.local_offer_rounded, color: AppColors.error, size: 24),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('12 Offers Near You', style: AppTypography.titleSmall),
                  Text('Save up to 25% at local merchants', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textTertiary, size: 16),
          ],
        ),
      ),
    );
  }
}

class _TransactionSummary extends StatelessWidget {
  const _TransactionSummary({
    required this.received,
    required this.sent,
  });

  final double received;
  final double sent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryItem(
            icon: Icons.arrow_downward_rounded,
            label: 'Received',
            amount: received.toEur,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _SummaryItem(
            icon: Icons.arrow_upward_rounded,
            label: 'Sent',
            amount: sent.toEur,
            color: AppColors.error,
          ),
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.icon, required this.label, required this.amount, required this.color});
  final IconData icon;
  final String label;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
                Text(
                  amount,
                  style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.data});
  final TransactionModel data;

  @override
  Widget build(BuildContext context) {
    final isCredit = data.amount > 0;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isCredit ? AppColors.successLight : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(
              isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: isCredit ? AppColors.success : AppColors.textSecondary,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.counterparty, style: AppTypography.titleSmall),
                Text(data.type, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isCredit ? '+' : ''}${data.amount.toEur}',
                style: AppTypography.titleSmall.copyWith(
                  color: isCredit ? AppColors.success : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (data.status == 'pending')
                Text('Pending', style: AppTypography.labelSmall.copyWith(color: AppColors.pending)),
            ],
          ),
        ],
      ),
    );
  }
}
