import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/matched_transaction.dart';
import '../../application/linked_bank_payments_provider.dart';

class LinkedBankPaymentsScreen extends ConsumerStatefulWidget {
  const LinkedBankPaymentsScreen({super.key});

  @override
  ConsumerState<LinkedBankPaymentsScreen> createState() => _LinkedBankPaymentsScreenState();
}

class _LinkedBankPaymentsScreenState extends ConsumerState<LinkedBankPaymentsScreen> {
  String _selectedFilter = 'Pending'; // 'All', 'Pending', 'Confirmed', 'Rejected'

  @override
  Widget build(BuildContext context) {
    final matchesState = ref.watch(linkedBankPaymentsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Match Payments'),
        centerTitle: false,
      ),
      body: matchesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Failed to load transaction matches')),
        data: (allMatches) {
          // Calculate counts
          final pendingCount = allMatches.where((m) => m.status == 'pending').length;
          final matchedCount = allMatches.where((m) => m.status == 'matched').length;
          final rejectedCount = allMatches.where((m) => m.status == 'rejected').length;

          // Filter list
          final filteredMatches = allMatches.where((m) {
            if (_selectedFilter == 'All') return true;
            if (_selectedFilter == 'Pending') return m.status == 'pending';
            if (_selectedFilter == 'Confirmed') return m.status == 'matched';
            if (_selectedFilter == 'Rejected') return m.status == 'rejected';
            return true;
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.pagePaddingH),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Grid
                Row(
                  children: [
                    _StatCard('Matched', '$matchedCount', AppColors.success),
                    const SizedBox(width: AppSpacing.sm),
                    _StatCard('Pending', '$pendingCount', AppColors.pending),
                    const SizedBox(width: AppSpacing.sm),
                    _StatCard('Rejected', '$rejectedCount', AppColors.error),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // Horizontal Filter Chips
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: ['All', 'Pending', 'Confirmed', 'Rejected'].map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: InkWell(
                          onTap: () {
                            setState(() => _selectedFilter = filter);
                          },
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.surface,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.border,
                              ),
                            ),
                            child: Text(
                              filter,
                              style: AppTypography.labelMedium.copyWith(
                                color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                if (filteredMatches.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'No matches found in this category.',
                        style: AppTypography.bodyLarge.copyWith(color: AppColors.textTertiary),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredMatches.length,
                    itemBuilder: (context, index) {
                      final match = filteredMatches[index];
                      return _MatchCard(
                        match: match,
                        onConfirm: () => _confirmMatch(match.id),
                        onReject: () => _rejectMatch(match.id),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmMatch(String id) async {
    final success = await ref.read(linkedBankPaymentsNotifierProvider.notifier).confirm(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Payment reconciled and points rewarded!' : 'Failed to reconcile match'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _rejectMatch(String id) async {
    final success = await ref.read(linkedBankPaymentsNotifierProvider.notifier).reject(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Match marked as rejected' : 'Failed to reject match'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(this.label, this.value, this.color);
  final String label, value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTypography.headlineMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({
    required this.match,
    required this.onConfirm,
    required this.onReject,
  });

  final MatchedTransaction match;
  final VoidCallback onConfirm;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final isPending = match.status == 'pending';
    final isMatched = match.status == 'matched';

    Color matchColor = AppColors.pending;
    Color matchBgColor = AppColors.pendingBg;
    if (match.confidence >= 90) {
      matchColor = AppColors.success;
      matchBgColor = AppColors.successLight;
    } else if (match.confidence < 80) {
      matchColor = AppColors.error;
      matchBgColor = AppColors.failedBg;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Match Ref: ${match.id.toUpperCase()}',
                style: AppTypography.mono.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: matchBgColor,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  '${match.confidence}% match',
                  style: AppTypography.labelSmall.copyWith(
                    color: matchColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: PSD2 Bank Transaction Data
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bank (PSD2)',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textTertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '€${match.bankTxnAmount.toStringAsFixed(2)}',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        match.bankTxnName,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xl),
                child: Icon(Icons.compare_arrows_rounded, color: AppColors.primary, size: 20),
              ),
              // Right: EU Pay wallet payment request
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EU Pay Wallet',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '€${match.euPayTxnAmount.toStringAsFixed(2)}',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        match.euPayTxnName,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (isPending) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    child: Text(
                      'Reject Match',
                      style: AppTypography.button.copyWith(color: AppColors.error),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onConfirm,
                    icon: const Icon(Icons.star_rounded, size: 16),
                    label: const Text('Confirm & Claim'),
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: AppSpacing.md),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isMatched ? AppColors.successLight : AppColors.failedBg,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(
                    color: isMatched ? AppColors.success.withValues(alpha: 0.3) : AppColors.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  isMatched ? 'Reconciled & Points Credited' : 'Match Rejected',
                  style: AppTypography.bodySmall.copyWith(
                    color: isMatched ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
