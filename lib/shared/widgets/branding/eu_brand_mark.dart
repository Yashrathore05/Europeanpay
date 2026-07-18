import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class EuBrandMark extends StatelessWidget {
  const EuBrandMark({
    super.key,
    this.size = 48,
    this.showWordmark = false,
    this.onDark = false,
  });

  final double size;
  final bool showWordmark;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final mark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: onDark ? Colors.white : AppColors.ink,
        borderRadius: BorderRadius.circular(size * 0.22),
        border: Border.all(
          color: onDark ? Colors.white.withValues(alpha: 0.32) : AppColors.brandLine,
        ),
      ),
      child: Center(
        child: Text(
          'EP',
          style: AppTypography.titleMedium.copyWith(
            color: onDark ? AppColors.ink : Colors.white,
            fontSize: size * 0.34,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
      ),
    );

    if (!showWordmark) return mark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        const SizedBox(width: 10),
        Text(
          'European Pay',
          style: AppTypography.titleLarge.copyWith(
            color: onDark ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
