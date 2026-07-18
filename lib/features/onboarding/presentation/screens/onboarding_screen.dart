import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';

/// Onboarding screen with feature highlights.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPage(
      icon: Icons.qr_code_scanner_rounded,
      title: 'Scan & Pay Instantly',
      subtitle:
          'Pay at millions of merchants across Europe with a simple QR scan. Fast, secure, and effortless.',
      gradient: LinearGradient(
        colors: [Color(0xFF1B4DFF), Color(0xFF6366F1)],
      ),
    ),
    _OnboardingPage(
      icon: Icons.account_balance_rounded,
      title: 'Link Your Bank',
      subtitle:
          'Connect your European bank accounts securely. View balances, track spending, and manage finances in one place.',
      gradient: LinearGradient(
        colors: [Color(0xFF00B67A), Color(0xFF00897B)],
      ),
    ),
    _OnboardingPage(
      icon: Icons.star_rounded,
      title: 'Earn EU Pay Points',
      subtitle:
          'Every payment earns rewards. Collect points, unlock VIP tiers, and redeem for real cash value.',
      gradient: LinearGradient(
        colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
      ),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: TextButton(
                  onPressed: () => context.goNamed(RouteNames.login),
                  child: Text(
                    'Skip',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) =>
                    setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xxl,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: page.gradient,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: (page.gradient as LinearGradient)
                                    .colors
                                    .first
                                    .withValues(alpha: 0.3),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            page.icon,
                            size: 56,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.section),
                        Text(
                          page.title,
                          style: AppTypography.displaySmall.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          page.subtitle,
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) {
                final isActive = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 32 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            const SizedBox(height: AppSpacing.xxxl),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl,
              ),
              child: Column(
                children: [
                  if (_currentPage == _pages.length - 1) ...[
                    EuPrimaryButton(
                      label: 'Get Started',
                      onPressed: () =>
                          context.goNamed(RouteNames.languageSelection),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    EuSecondaryButton(
                      label: 'I Already Have an Account',
                      onPressed: () => context.goNamed(RouteNames.login),
                    ),
                  ] else ...[
                    EuPrimaryButton(
                      label: 'Next',
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Gradient gradient;
}
