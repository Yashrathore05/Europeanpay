import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/inputs/eu_inputs.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';

class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  int _step = 0; // 0: enter pin, 1: confirm pin
  String _pin = '';
  String _confirmPin = '';
  String _errorText = '';

  void _onKeyTap(String key) {
    if (_step == 0) {
      if (_pin.length >= AppConstants.pinLength) return;
      setState(() {
        _pin += key;
        _errorText = '';
      });
      if (_pin.length == AppConstants.pinLength) {
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            _step = 1;
          });
        });
      }
    } else {
      if (_confirmPin.length >= AppConstants.pinLength) return;
      setState(() {
        _confirmPin += key;
        _errorText = '';
      });
      if (_confirmPin.length == AppConstants.pinLength) {
        _verifyAndSave();
      }
    }
  }

  void _onDelete() {
    if (_step == 0) {
      if (_pin.isEmpty) return;
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _errorText = '';
      });
    } else {
      if (_confirmPin.isEmpty) return;
      setState(() {
        _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        _errorText = '';
      });
    }
  }

  Future<void> _verifyAndSave() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_pin == _confirmPin) {
      // Mock: Save PIN successfully
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PIN configured successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } else {
      setState(() {
        _confirmPin = '';
        _errorText = 'PINs do not match. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentInput = _step == 0 ? _pin : _confirmPin;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Setup PIN'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Icon(
              _step == 0 ? Icons.pin_outlined : Icons.lock_outline_rounded,
              size: 48,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              _step == 0 ? 'Create a Security PIN' : 'Confirm Security PIN',
              style: AppTypography.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _step == 0
                  ? 'Set a 4-digit PIN for quick app access and verification.'
                  : 'Re-enter your 4-digit PIN to confirm.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),

            // PIN Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(AppConstants.pinLength, (i) {
                final isFilled = i < currentInput.length;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 16,
                  height: 16,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? AppColors.primary : AppColors.surfaceVariant,
                    border: _errorText.isNotEmpty
                        ? Border.all(color: AppColors.warning, width: 2)
                        : null,
                  ),
                );
              }),
            ),
            const SizedBox(height: AppSpacing.md),
            if (_errorText.isNotEmpty)
              Text(
                _errorText,
                style: AppTypography.bodySmall.copyWith(color: AppColors.warning),
              ),

            const Spacer(),

            // Keypad
            _buildKeypad(),
            const SizedBox(height: AppSpacing.xxxl),
          ],
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
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.5,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: keys.length,
        itemBuilder: (context, index) {
          final key = keys[index];
          if (key.isEmpty) return const SizedBox();
          if (key == 'del') {
            return InkWell(
              onTap: _onDelete,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              child: const Center(
                child: Icon(Icons.backspace_outlined, size: 24, color: AppColors.textPrimary),
              ),
            );
          }
          return InkWell(
            onTap: () => _onKeyTap(key),
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            child: Center(
              child: Text(
                key,
                style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          );
        },
      ),
    );
  }
}
