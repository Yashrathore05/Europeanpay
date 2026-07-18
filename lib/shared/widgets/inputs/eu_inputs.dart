import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Standard text field with European Pay styling.
class EuTextField extends StatelessWidget {
  const EuTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final int maxLines;
  final bool enabled;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          maxLines: maxLines,
          enabled: enabled,
          autofocus: autofocus,
          textInputAction: textInputAction,
          focusNode: focusNode,
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

/// OTP input field with individual character boxes.
class EuOtpField extends StatefulWidget {
  const EuOtpField({
    super.key,
    required this.length,
    required this.onCompleted,
    this.onChanged,
  });

  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;

  @override
  State<EuOtpField> createState() => _EuOtpFieldState();
}

class _EuOtpFieldState extends State<EuOtpField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _currentValue =>
      _controllers.map((c) => c.text).join();

  void _onChanged(int index, String value) {
    if (value.length == 1 && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    final currentValue = _currentValue;
    widget.onChanged?.call(currentValue);

    if (currentValue.length == widget.length) {
      widget.onCompleted(currentValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Container(
          width: 48,
          height: 56,
          margin: EdgeInsets.symmetric(
            horizontal: index == widget.length - 1 ? 0 : 6,
          ),
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: AppTypography.otp.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: _controllers[index].text.isNotEmpty
                  ? AppColors.primarySurface
                  : AppColors.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(
                  color: _controllers[index].text.isNotEmpty
                      ? AppColors.primary
                      : Colors.transparent,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(
                  color: _controllers[index].text.isNotEmpty
                      ? AppColors.primary
                      : Colors.transparent,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) => _onChanged(index, value),
          ),
        );
      }),
    );
  }
}

/// Amount input field with currency prefix.
class EuAmountField extends StatelessWidget {
  const EuAmountField({
    super.key,
    this.controller,
    this.onChanged,
    this.validator,
    this.hint = '0.00',
    this.currencySymbol = '€',
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final String hint;
  final String currencySymbol;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: validator,
      onChanged: onChanged,
      autofocus: autofocus,
      textAlign: TextAlign.center,
      style: AppTypography.amountLarge.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.amountLarge.copyWith(
          color: AppColors.textTertiary.withValues(alpha: 0.4),
        ),
        prefixText: '$currencySymbol ',
        prefixStyle: AppTypography.amountLarge.copyWith(
          color: AppColors.textSecondary,
        ),
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}

/// Search field with icon and clear button.
class EuSearchField extends StatelessWidget {
  const EuSearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.onClear,
    this.hint = 'Search...',
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search_rounded, size: 22),
        suffixIcon: controller?.text.isNotEmpty == true
            ? IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () {
                  controller?.clear();
                  onClear?.call();
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }
}
