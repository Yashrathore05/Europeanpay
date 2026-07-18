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
  String _activeFilter = 'All-time';
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final List<_Transaction> _allTransactions = [
    _Transaction('TXN001', 'Starbucks', 'QR Payment', -4.50, 'Success', DateTime.now().subtract(const Duration(hours: 1))),
    _Transaction('TXN002', 'Alice Dupont', 'EU Pay ID', 120.00, 'Success', DateTime.now().subtract(const Duration(hours: 3))),
    _Transaction('TXN003', 'Qonto Invoice', 'Invoice', -450.00, 'Pending', DateTime.now().subtract(const Duration(days: 1))),
    _Transaction('TXN004', 'BNP Paribas Sync', 'Bank Sync', 1200.00, 'Success', DateTime.now().subtract(const Duration(days: 1, hours: 4))),
    _Transaction('TXN005', 'Apple Store', 'QR Payment', -1149.00, 'Failed', DateTime.now().subtract(const Duration(days: 3))),
    _Transaction('TXN006', 'Monoprix Paris', 'Card Payment', -68.40, 'Success', DateTime.now().subtract(const Duration(days: 4))),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_Transaction> get _filteredTransactions {
    return _allTransactions.where((txn) {
      // Filter by search query
      final matchesSearch = txn.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          txn.type.toLowerCase().contains(_searchQuery.toLowerCase());
      
      if (!matchesSearch) return false;

      // Filter by category chip
      switch (_activeFilter) {
        case 'This Month':
          final oneMonthAgo = DateTime.now().subtract(const Duration(days: 30));
          return txn.date.isAfter(oneMonthAgo);
        case 'Bank':
          return txn.type == 'Bank Sync' || txn.type == 'Invoice';
        case 'Pending':
          return txn.status == 'Pending';
        case 'All-time':
        default:
          return true;
      }
    }).toList();
  }

  double get _totalReceived {
    return _filteredTransactions
        .where((t) => t.amount > 0 && t.status != 'Failed')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get _totalSent {
    return _filteredTransactions
        .where((t) => t.amount < 0 && t.status != 'Failed')
        .fold(0.0, (sum, t) => sum + t.amount.abs());
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTransactions;
    
    // Group transactions
    final todayTxns = filtered.where((t) => _isToday(t.date)).toList();
    final yesterdayTxns = filtered.where((t) => _isYesterday(t.date)).toList();
    final earlierTxns = filtered.where((t) => !_isToday(t.date) && !_isYesterday(t.date)).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transactions'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Advanced filters option coming soon')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingH, vertical: AppSpacing.sm),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search merchant or type...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              ),
            ),
          ),

          // Performance Metrics
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingH, vertical: AppSpacing.sm),
            child: Row(
              children: [
                _MetricCard(
                  label: 'Total Received',
                  amount: _totalReceived.toEur,
                  isIncome: true,
                ),
                const SizedBox(width: AppSpacing.md),
                _MetricCard(
                  label: 'Total Sent',
                  amount: _totalSent.toEur,
                  isIncome: false,
                ),
              ],
            ),
          ),

          // Horizontal Filter Chips
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingH),
              children: ['All-time', 'This Month', 'Bank', 'Pending'].map((filterName) {
                final isSelected = _activeFilter == filterName;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _activeFilter = filterName;
                      });
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
                        filterName,
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
          const SizedBox(height: AppSpacing.md),

          // Grouped Ledger
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'No transactions found',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingH),
                    children: [
                      if (todayTxns.isNotEmpty) ...[
                        _buildSectionHeader('Today'),
                        ...todayTxns.map((t) => _buildTransactionRow(t)),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      if (yesterdayTxns.isNotEmpty) ...[
                        _buildSectionHeader('Yesterday'),
                        ...yesterdayTxns.map((t) => _buildTransactionRow(t)),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      if (earlierTxns.isNotEmpty) ...[
                        _buildSectionHeader('Earlier'),
                        ...earlierTxns.map((t) => _buildTransactionRow(t)),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Text(
        title,
        style: AppTypography.titleSmall.copyWith(
          color: AppColors.textTertiary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTransactionRow(_Transaction txn) {
    final isCredit = txn.amount > 0;
    
    // Status Badge color
    Color statusColor;
    Color statusBg;
    if (txn.status == 'Success') {
      statusColor = AppColors.success;
      statusBg = AppColors.successLight;
    } else if (txn.status == 'Pending') {
      statusColor = AppColors.pending;
      statusBg = AppColors.pendingBg;
    } else {
      statusColor = AppColors.failed;
      statusBg = AppColors.failedBg;
    }

    return InkWell(
      onTap: () => context.pushNamed(RouteNames.transactionDetail, pathParameters: {'id': txn.id}),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
            // Direction Icon Container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCredit ? AppColors.successLight : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(
                isCredit ? Icons.add_rounded : Icons.remove_rounded,
                color: isCredit ? AppColors.success : AppColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Merchant Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txn.name,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    txn.type,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
            // Amount & Status Badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isCredit ? '+' : ''}${txn.amount.toEur}',
                  style: AppTypography.bodyLarge.copyWith(
                    color: isCredit ? AppColors.success : AppColors.textPrimary,
                    fontWeight: FontWeight.w750,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    txn.status,
                    style: AppTypography.labelSmall.copyWith(
                      color: statusColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
  }
}

class _Transaction {
  const _Transaction(this.id, this.name, this.type, this.amount, this.status, this.date);
  final String id, name, type, status;
  final double amount;
  final DateTime date;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.amount,
    required this.isIncome,
  });

  final String label;
  final String amount;
  final bool isIncome;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                  color: isIncome ? AppColors.success : AppColors.textSecondary,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              amount,
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
