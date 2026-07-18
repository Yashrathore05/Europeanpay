import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';
import '../../domain/models/bank_account.dart';
import '../../application/bank_accounts_provider.dart';

class BankAccountsScreen extends ConsumerStatefulWidget {
  const BankAccountsScreen({super.key});

  @override
  ConsumerState<BankAccountsScreen> createState() => _BankAccountsScreenState();
}

class _BankAccountsScreenState extends ConsumerState<BankAccountsScreen> {
  bool _isSyncing = false;

  Future<void> _syncAccounts() async {
    setState(() => _isSyncing = true);
    final success = await ref.read(bankAccountsNotifierProvider.notifier).sync();
    if (mounted) {
      setState(() => _isSyncing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Bank accounts synchronized' : 'Synchronization failed'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountsState = ref.watch(bankAccountsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Connected Banks'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: _isSyncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  )
                : const Icon(Icons.sync_rounded),
            onPressed: _isSyncing ? null : _syncAccounts,
          ),
        ],
      ),
      body: accountsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
              const SizedBox(height: AppSpacing.md),
              const Text('Failed to load linked bank accounts'),
              const SizedBox(height: AppSpacing.md),
              EuPrimaryButton(
                label: 'Retry',
                onPressed: () => ref.read(bankAccountsNotifierProvider.notifier).load(),
              ),
            ],
          ),
        ),
        data: (accounts) {
          final totalBalance = accounts.fold<double>(0, (sum, acc) => sum + acc.balance);
          final lastSyncedStr = accounts.isNotEmpty
              ? _formatTimeAgo(accounts.first.lastSynced)
              : 'Never';

          return RefreshIndicator(
            onRefresh: _syncAccounts,
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.pagePaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total balance overview card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Linked Balance',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '€${totalBalance.toStringAsFixed(2)}',
                          style: AppTypography.amountLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '${accounts.length} active open banking connections',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  if (accounts.isEmpty) ...[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          'No bank accounts linked yet.',
                          style: AppTypography.bodyLarge.copyWith(color: AppColors.textTertiary),
                        ),
                      ),
                    ),
                  ] else ...[
                    Text(
                      'Connection Ledger',
                      style: AppTypography.titleMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: accounts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final acc = accounts[index];
                        return _AccountCard(
                          name: acc.accountName,
                          bankName: acc.bankName,
                          iban: acc.iban,
                          balance: acc.balance,
                          type: acc.type,
                          onTap: () => context.pushNamed(
                            RouteNames.accountDetail,
                            pathParameters: {'id': acc.id},
                          ),
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: AppSpacing.xxl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Bank Transactions', style: AppTypography.titleMedium),
                      TextButton(
                        onPressed: () => context.pushNamed(RouteNames.bankTransactions),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextButton.icon(
                    onPressed: () => context.pushNamed(RouteNames.linkedBankPayments),
                    icon: const Icon(Icons.compare_arrows_rounded),
                    label: const Text('Linked Bank Payments'),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  EuPrimaryButton(
                    label: 'Connect New Bank Connection',
                    onPressed: () {
                      context.pushNamed(RouteNames.bankConnect);
                    },
                    icon: Icons.add_rounded,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: Text(
                      'Last synced: $lastSyncedStr',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else {
      return '${diff.inHours}h ago';
    }
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.name,
    required this.bankName,
    required this.iban,
    required this.balance,
    required this.type,
    required this.onTap,
  });

  final String name, bankName, iban, type;
  final double balance;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: const Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$bankName - $name',
                    style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '$type • ${iban.replaceAll(' ', '').substring(0, 7)}...',
                    style: AppTypography.mono.copyWith(color: AppColors.textTertiary, fontSize: 11),
                  ),
                ],
              ),
            ),
            Text(
              '€${balance.toStringAsFixed(2)}',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w750,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
