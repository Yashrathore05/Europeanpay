import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../authentication/application/auth_provider.dart';
import '../../../dashboard/application/dashboard_provider.dart';

class MyQrScreen extends ConsumerWidget {
  const MyQrScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final dashboardState = ref.watch(dashboardNotifierProvider);

    final name = authState is Authenticated ? authState.user.fullName : 'Jean Dupont';
    final euPayId = dashboardState.maybeWhen(
      data: (data) => data.euPayId,
      orElse: () => 'EUAB12CD34EF',
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My QR Code'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('QR Code link shared successfully')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.print_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: const Icon(
                        Icons.qr_code_2_rounded,
                        size: 180,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(name, style: AppTypography.titleLarge),
                    const SizedBox(height: AppSpacing.xs),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: euPayId));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('EU Pay ID copied to clipboard')),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            euPayId,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.primary,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.copy_rounded, size: 16, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Text(
                'Show this QR code to receive payments',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Refresh QR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
