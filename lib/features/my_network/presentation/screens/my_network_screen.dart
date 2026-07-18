import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';

class MyNetworkScreen extends StatefulWidget {
  const MyNetworkScreen({super.key});
  @override
  State<MyNetworkScreen> createState() => _MyNetworkScreenState();
}

class _MyNetworkScreenState extends State<MyNetworkScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  final _people = [
    _Person('Marie Laurent', 'EUXY98ZW76VU', true, 3, 2),
    _Person('Pierre Martin', 'EUCD56EF78GH', false, 1, 4),
    _Person('Sophie Dubois', 'EUIJ90KL12MN', true, 5, 1),
    _Person('Lucas Bernard', 'EUOP34QR56ST', false, 2, 3),
  ];

  @override
  void initState() { super.initState(); _tabController = TabController(length: 2, vsync: this); }
  @override
  void dispose() { _tabController.dispose(); _searchController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filteredPeople = _people.where((p) =>
        p.name.toLowerCase().contains(query) ||
        p.euPayId.toLowerCase().contains(query)).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Network'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'All People'), Tab(text: 'Favorites')],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.pagePaddingH),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by name or EU Pay ID',
                prefixIcon: Icon(Icons.search_rounded, size: 22),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPeopleList(filteredPeople),
                _buildPeopleList(filteredPeople.where((p) => p.isFavorite).toList()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {}, icon: const Icon(Icons.person_add_rounded), label: const Text('Add Person')),
    );
  }

  Widget _buildPeopleList(List<_Person> people) {
    if (people.isEmpty) return Center(child: Text('No contacts found', style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary)));
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingH),
      itemCount: people.length,
      itemBuilder: (ctx, i) {
        final p = people[i];
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), border: Border.all(color: AppColors.borderLight)),
          child: Row(
            children: [
              CircleAvatar(radius: 22, backgroundColor: AppColors.primarySurface, child: Text(p.name.split(' ').map((w) => w[0]).join(), style: AppTypography.titleSmall.copyWith(color: AppColors.primary))),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.name, style: AppTypography.titleSmall),
                Text(p.euPayId, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
                const SizedBox(height: 4),
                Row(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(4)), child: Text('${p.paid} paid', style: const TextStyle(fontSize: 10, color: AppColors.success))),
                  const SizedBox(width: 4),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(4)), child: Text('${p.received} received', style: const TextStyle(fontSize: 10, color: AppColors.primary))),
                ]),
              ])),
              Column(children: [
                IconButton(icon: Icon(p.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded, color: p.isFavorite ? AppColors.gold : AppColors.textTertiary, size: 22), onPressed: () => setState(() => p.isFavorite = !p.isFavorite)),
                IconButton(
                  icon: const Icon(Icons.send_rounded, size: 20, color: AppColors.primary),
                  onPressed: () => context.pushNamed(
                    RouteNames.euPayIdTransfer,
                    extra: {'recipientId': p.euPayId},
                  ),
                ),
              ]),
            ],
          ),
        );
      },
    );
  }
}

class _Person {
  _Person(this.name, this.euPayId, this.isFavorite, this.paid, this.received);
  final String name, euPayId;
  bool isFavorite;
  final int paid, received;
}
