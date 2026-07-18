import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});
  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  final _categories = ['All', 'Restaurant', 'Café', 'Grocery', 'Fashion', 'Electronics', 'Travel', 'Entertainment'];

  final _offers = [
    _Offer('OFF1', '20% Off', 'Le Petit Bistro', 'Restaurant', '0.8 km', '€20 min spend', 'Jul 31', true),
    _Offer('OFF2', '€5 Cashback', 'Monoprix', 'Grocery', '1.2 km', '€30 min spend', 'Aug 15', true),
    _Offer('OFF3', '15% Off', 'Zara Paris', 'Fashion', '2.5 km', '€50 min spend', 'Jul 25', true),
    _Offer('OFF4', '10% Off', 'FNAC', 'Electronics', '3.0 km', '€40 min spend', 'Aug 1', true),
    _Offer('OFF5', 'Buy 1 Get 1', 'Starbucks', 'Café', '0.5 km', 'No min', 'Jul 20', true),
    _Offer('OFF6', '30% Off', 'Amazon FR', 'Electronics', 'Online', '€25 min spend', 'Jul 30', false),
    _Offer('OFF7', '€10 Off', 'Booking.com', 'Travel', 'Online', '€100 min spend', 'Aug 31', false),
  ];

  @override
  void initState() { super.initState(); _tabController = TabController(length: 2, vsync: this); }
  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Offers & Deals'),
        bottom: TabBar(controller: _tabController, tabs: const [Tab(text: 'Nearby'), Tab(text: 'Online')]),
      ),
      body: Column(children: [
        // Stats
        Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePaddingH),
          child: Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs), decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(AppSpacing.radiusFull)), child: Text('12 active offers', style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600))),
            const Spacer(),
            TextButton.icon(onPressed: () {}, icon: const Icon(Icons.location_on_outlined, size: 18), label: const Text('Paris')),
          ]),
        ),
        // Category filter
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingH),
            children: _categories.map((c) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(label: Text(c), selected: _selectedCategory == c, onSelected: (_) => setState(() => _selectedCategory = c)),
            )).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Offers list
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOffersList(_offers.where((o) => o.isNearby).toList()),
              _buildOffersList(_offers.where((o) => !o.isNearby).toList()),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildOffersList(List<_Offer> offers) {
    return RefreshIndicator(
      onRefresh: () async { await Future.delayed(const Duration(seconds: 1)); },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.pagePaddingH),
        itemCount: offers.length,
        itemBuilder: (ctx, i) {
          final o = offers[i];
          return InkWell(
            onTap: () => context.pushNamed(RouteNames.offerDetail, pathParameters: {'id': o.id}),
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), border: Border.all(color: AppColors.borderLight)),
              child: Row(children: [
                Container(width: 56, height: 56, decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(AppSpacing.radiusMd)), child: Center(child: Text(o.value.split(' ')[0], style: AppTypography.titleSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)))),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(o.value, style: AppTypography.titleSmall),
                  Text(o.merchant, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1), decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(4)), child: Text(o.category, style: AppTypography.labelSmall.copyWith(fontSize: 10))),
                    const SizedBox(width: 6),
                    Text(o.distance, style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
                    const SizedBox(width: 6),
                    Text('• ${o.minSpend}', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
                  ]),
                ])),
                Column(children: [
                  Text('Valid till', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, fontSize: 10)),
                  Text(o.validTill, style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w600)),
                ]),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class _Offer {
  const _Offer(this.id, this.value, this.merchant, this.category, this.distance, this.minSpend, this.validTill, this.isNearby);
  final String id, value, merchant, category, distance, minSpend, validTill;
  final bool isNearby;
}
