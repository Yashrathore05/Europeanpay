import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _filter = 'All';
  final _filters = ['All', 'Payments', 'Transfers', 'Offers', 'Loyalty', 'System'];
  final _notifications = [
    _Notif('Payment Received', 'You received €50.00 from Marie Laurent', 'payment', 'high', false, '2m ago'),
    _Notif('Points Earned', '+12 EU Pay Points from Café de Flore', 'loyalty', 'normal', false, '1h ago'),
    _Notif('New Offer', '20% off at Le Petit Bistro nearby', 'offer', 'normal', true, '3h ago'),
    _Notif('Security Alert', 'New login detected from Paris, France', 'system', 'high', true, '5h ago'),
    _Notif('Transfer Complete', '€25.00 sent to Pierre Martin', 'payment', 'normal', true, 'Yesterday'),
    _Notif('Gold Status', 'Congrats! You reached Gold tier', 'loyalty', 'high', true, '2d ago'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(onPressed: () => setState(() { for (var n in _notifications) n.isRead = true; }), child: const Text('Mark all read')),
          IconButton(icon: const Icon(Icons.settings_outlined, size: 22), onPressed: () => context.pushNamed(RouteNames.notificationPreferences)),
        ],
      ),
      body: Column(children: [
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingH),
            children: _filters.map((f) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(f),
                selected: _filter == f,
                onSelected: (_) => setState(() => _filter = f),
              ),
            )).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: () {
            final filtered = _notifications.where((n) {
              if (_filter == 'All') return true;
              if (_filter == 'Payments') return n.type == 'payment' && n.title.contains('Received');
              if (_filter == 'Transfers') return n.type == 'payment' && n.title.contains('Sent') || n.title.contains('Transfer');
              if (_filter == 'Offers') return n.type == 'offer';
              if (_filter == 'Loyalty') return n.type == 'loyalty';
              if (_filter == 'System') return n.type == 'system';
              return true;
            }).toList();

            if (filtered.isEmpty) {
              return Center(
                child: Text(
                  'No notifications in this category',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingH),
              itemCount: filtered.length,
              itemBuilder: (ctx, i) {
                final n = filtered[i];
                return InkWell(
                  onTap: () => setState(() => n.isRead = true),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: n.isRead ? AppColors.surface : AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(
                        color: n.isRead
                            ? AppColors.borderLight
                            : AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _typeColor(n.type).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(_typeIcon(n.type), color: _typeColor(n.type), size: 20),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      n.title,
                                      style: AppTypography.titleSmall.copyWith(
                                        fontWeight: n.isRead ? FontWeight.w500 : FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  if (n.priority == 'high')
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: AppColors.error,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(n.body, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                              const SizedBox(height: 4),
                              Text(n.time, style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }(),
        ),
      ]),
    );
  }

  IconData _typeIcon(String type) => switch (type) { 'payment' => Icons.payment_rounded, 'loyalty' => Icons.star_rounded, 'offer' => Icons.local_offer_rounded, 'system' => Icons.security_rounded, _ => Icons.notifications_rounded };
  Color _typeColor(String type) => switch (type) { 'payment' => AppColors.primary, 'loyalty' => AppColors.gold, 'offer' => AppColors.secondary, 'system' => AppColors.error, _ => AppColors.textSecondary };
}

class _Notif {
  _Notif(this.title, this.body, this.type, this.priority, this.isRead, this.time);
  final String title, body, type, priority, time;
  bool isRead;
}
