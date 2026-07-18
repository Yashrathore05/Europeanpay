import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/bank_accounts_provider.dart';

class AccountDetailScreen extends ConsumerWidget {
  const AccountDetailScreen({super.key, required this.accountId});
  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsState = ref.watch(bankAccountsNotifierProvider);

    final account = accountsState.maybeWhen(
      data: (list) {
        final matches = list.where((acc) => acc.id == accountId);
        return matches.isNotEmpty ? matches.first : null;
      },
      orElse: () => null,
    );

    if (account == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Account Details')),
        body: const Center(
          child: Text('Account not found or has been disconnected.'),
        ),
      );
    }

    final lastSyncedStr = _formatTimeAgo(account.lastSynced);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Account Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xxl),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(account.accountName, style: AppTypography.titleLarge),
                  Text(
                    '${account.bankName} • ${account.type}',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _Row('Balance', '€${account.balance.toStringAsFixed(2)}'),
                  _Row('Available', '€${account.available.toStringAsFixed(2)}'),
                  _Row('Pending', '€${account.pending.toStringAsFixed(2)}'),
                  _Row('Currency', 'EUR'),
                  _Row('IBAN', account.iban, copyable: true),
                  _Row('Account #', account.accountNumber),
                  _Row('Last Synced', lastSyncedStr),
                  _Row('Primary Account', account.isPrimary ? 'Yes' : 'No'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final success =
                          await ref.read(bankAccountsNotifierProvider.notifier).sync();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                success ? 'Account details updated' : 'Update failed'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Refresh'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: account.isPrimary
                        ? null
                        : () async {
                            final success = await ref
                                .read(bankAccountsNotifierProvider.notifier)
                                .setPrimary(accountId);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(success
                                      ? 'Set as primary account'
                                      : 'Failed to update primary status'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                    icon: Icon(
                      account.isPrimary ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 18,
                    ),
                    label: const Text('Set Primary'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Disconnect Account'),
                    content: const Text(
                        'Are you sure you want to disconnect this account? You will not see its transactions anymore.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text(
                          'Disconnect',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  final success = await ref
                      .read(bankAccountsNotifierProvider.notifier)
                      .disconnect(accountId);
                  if (context.mounted) {
                    if (success) {
                      context.pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bank account disconnected'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to disconnect account'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  }
                }
              },
              icon: const Icon(Icons.link_off_rounded, size: 18, color: AppColors.error),
              label: const Text(
                'Remove Account',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        ),
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

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.copyable = false});
  final String label, value;
  final bool copyable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: copyable
                    ? () {
                        Clipboard.setData(ClipboardData(text: value));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$label copied to clipboard'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        value,
                        style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (copyable) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.copy_rounded, size: 14, color: AppColors.primary),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
