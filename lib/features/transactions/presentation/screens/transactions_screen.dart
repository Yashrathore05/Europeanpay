import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/extensions/number_extensions.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _selectedSource = 'All';
  String _selectedStatus = 'All';
  String _selectedTime = 'All Time';
  final _searchController = TextEditingController();

  final _mockTransactions = [
    _Transaction('TXN001', 'Café de Flore', 'QR Payment', -12.50, 'completed', DateTime.now().subtract(const Duration(hours: 2))),
    _Transaction('TXN002', 'Marie Laurent', 'EU Pay ID', 50.00, 'completed', DateTime.now().subtract(const Duration(hours: 5))),
    _Transaction('TXN003', 'Carrefour', 'QR Payment', -67.30, 'completed', DateTime.now().subtract(const Duration(days: 1))),
    _Transaction('TXN004', 'Pierre Martin', 'EU Pay ID', -25.00, 'pending', DateTime.now().subtract(const Duration(days: 1))),
    _Transaction('TXN005', 'EU Pay Points', 'Cashback', 3.50, 'completed', DateTime.now().subtract(const Duration(days: 2))),
    _Transaction('TXN006', 'BNP Paribas', 'Bank Transfer', 500.00, 'completed', DateTime.now().subtract(const Duration(days: 3))),
    _Transaction('TXN007', 'FNAC', 'QR Payment', -89.99, 'completed', DateTime.now().subtract(const Duration(days: 3))),
    _Transaction('TXN008', 'Monoprix', 'QR Payment', -34.20, 'failed', DateTime.now().subtract(const Duration(days: 4))),
    _Transaction('TXN009', 'Refund - Zara', 'Refund', 45.00, 'completed', DateTime.now().subtract(const Duration(days: 5))),
    _Transaction('TXN010', 'Invoice #2024', 'Invoice', -150.00, 'completed', DateTime.now().subtract(const Duration(days: 6))),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingH, vertical: AppSpacing.sm),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search transactions...',
                prefixIcon: const Icon(Icons.search_rounded, size: 22),
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          // Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingH, vertical: AppSpacing.sm),
            child: Row(
              children: [
                _SummaryChip(label: 'Received', amount: '€598.50', color: AppColors.success),
                const SizedBox(width: AppSpacing.sm),
                _SummaryChip(label: 'Sent', amount: '€378.99', color: AppColors.error),
              ],
            ),
          ),
          // Filter chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingH),
              children: [
                _FilterChip(label: _selectedSource, onTap: () {}),
                const SizedBox(width: 8),
                _FilterChip(label: _selectedStatus, onTap: () {}),
                const SizedBox(width: 8),
                _FilterChip(label: _selectedTime, onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Pending alert
          if (_mockTransactions.any((t) => t.status == 'pending'))
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingH, vertical: AppSpacing.xs),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: AppColors.pendingBg, borderRadius: BorderRadius.circular(AppSpacing.radiusSm)),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.pending, size: 18),
                  const SizedBox(width: AppSpacing.sm),
                  Text('1 pending transaction', style: AppTypography.bodySmall.copyWith(color: AppColors.pending, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          // Transaction list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.pagePaddingH),
              itemCount: _mockTransactions.length,
              itemBuilder: (context, index) {
                final txn = _mockTransactions[index];
                final isCredit = txn.amount > 0;
                return InkWell(
                  onTap: () => context.pushNamed(RouteNames.transactionDetail, pathParameters: {'id': txn.id}),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), border: Border.all(color: AppColors.borderLight)),
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(color: isCredit ? AppColors.successLight : AppColors.surfaceVariant, borderRadius: BorderRadius.circular(AppSpacing.radiusSm)),
                          child: Icon(isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded, color: isCredit ? AppColors.success : AppColors.textSecondary, size: 22),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(txn.name, style: AppTypography.titleSmall),
                              Text(txn.source, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${isCredit ? '+' : ''}${txn.amount.toEur}', style: AppTypography.titleSmall.copyWith(color: isCredit ? AppColors.success : AppColors.textPrimary, fontWeight: FontWeight.w600)),
                            if (txn.status != 'completed')
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: txn.status == 'pending' ? AppColors.pendingBg : AppColors.failedBg,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(txn.status.substring(0, 1).toUpperCase() + txn.status.substring(1), style: TextStyle(fontSize: 10, color: txn.status == 'pending' ? AppColors.pending : AppColors.failed, fontWeight: FontWeight.w600)),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter Transactions', style: AppTypography.headlineSmall),
            const SizedBox(height: AppSpacing.xl),
            Text('Source', style: AppTypography.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            Wrap(spacing: 8, children: ['All', 'EU Pay', 'Invoice', 'Bank'].map((s) => ChoiceChip(label: Text(s), selected: _selectedSource == s, onSelected: (v) { setState(() => _selectedSource = s); Navigator.pop(ctx); })).toList()),
            const SizedBox(height: AppSpacing.lg),
            Text('Status', style: AppTypography.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            Wrap(spacing: 8, children: ['All', 'Completed', 'Pending', 'Failed'].map((s) => ChoiceChip(label: Text(s), selected: _selectedStatus == s, onSelected: (v) { setState(() => _selectedStatus = s); Navigator.pop(ctx); })).toList()),
            const SizedBox(height: AppSpacing.lg),
            Text('Time Period', style: AppTypography.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            Wrap(spacing: 8, children: ['All Time', 'Today', 'Last 7 Days', 'This Month'].map((s) => ChoiceChip(label: Text(s), selected: _selectedTime == s, onSelected: (v) { setState(() => _selectedTime = s); Navigator.pop(ctx); })).toList()),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _Transaction {
  const _Transaction(this.id, this.name, this.source, this.amount, this.status, this.date);
  final String id, name, source, status;
  final double amount;
  final DateTime date;
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.amount, required this.color});
  final String label, amount;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(AppSpacing.radiusSm)),
        child: Row(
          children: [
            Icon(label == 'Received' ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded, color: color, size: 16),
            const SizedBox(width: 4),
            Text('$label: ', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
            Text(amount, style: AppTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(AppSpacing.radiusFull)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: AppTypography.labelSmall),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 16),
          ],
        ),
      ),
    );
  }
}
