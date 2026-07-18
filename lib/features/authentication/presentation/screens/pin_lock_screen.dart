import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/constants/app_constants.dart';

/// PIN lock screen for app cold start and resume.
class PinLockScreen extends StatefulWidget {
  const PinLockScreen({super.key});
  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  String _pin = '';
  int _attempts = 0;
  bool _isError = false;

  void _onKeyTap(String key) {
    if (_pin.length >= AppConstants.pinLength) return;
    setState(() {
      _pin += key;
      _isError = false;
    });
    if (_pin.length == AppConstants.pinLength) _verifyPin();
  }

  void _onDelete() {
    if (_pin.isEmpty) return;
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
      _isError = false;
    });
  }

  Future<void> _verifyPin() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock: accept "1234"
    if (_pin == '1234') {
      if (mounted) context.goNamed(RouteNames.dashboard);
    } else {
      setState(() {
        _attempts++;
        _isError = true;
        _pin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLocked = _attempts >= AppConstants.maxPinAttempts;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.cardGradient),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              const Icon(Icons.lock_rounded, size: 48, color: Colors.white),
              const SizedBox(height: AppSpacing.xl),
              Text('Enter PIN', style: AppTypography.headlineMedium.copyWith(color: Colors.white)),
              const SizedBox(height: AppSpacing.sm),
              if (isLocked)
                Text('Too many attempts. Try again later.', style: AppTypography.bodyMedium.copyWith(color: Colors.white70))
              else if (_isError)
                Text('Incorrect PIN. ${AppConstants.maxPinAttempts - _attempts} attempts left.', style: AppTypography.bodyMedium.copyWith(color: AppColors.warning))
              else
                Text('Enter your 4-digit PIN', style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
              const SizedBox(height: AppSpacing.xxxl),
              // PIN dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(AppConstants.pinLength, (i) {
                  final isFilled = i < _pin.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 16, height: 16,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFilled ? Colors.white : Colors.white24,
                      border: _isError ? Border.all(color: AppColors.warning, width: 2) : null,
                    ),
                  );
                }),
              ),
              const Spacer(flex: 2),
              // Keypad
              if (!isLocked) _buildKeypad(),
              const SizedBox(height: AppSpacing.xxl),
              TextButton(
                onPressed: () => context.goNamed(RouteNames.login),
                child: Text('Use Password Instead', style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
              ),
              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'del'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.5, mainAxisSpacing: 8, crossAxisSpacing: 8),
        itemCount: keys.length,
        itemBuilder: (context, index) {
          final key = keys[index];
          if (key.isEmpty) return const SizedBox();
          if (key == 'del') {
            return InkWell(
              onTap: _onDelete,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              child: const Center(child: Icon(Icons.backspace_outlined, color: Colors.white, size: 24)),
            );
          }
          return InkWell(
            onTap: () => _onKeyTap(key),
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            child: Center(child: Text(key, style: AppTypography.amount.copyWith(color: Colors.white))),
          );
        },
      ),
    );
  }
}
