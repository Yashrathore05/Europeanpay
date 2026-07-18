import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview placeholder
          Container(color: Colors.black),
          // Scanner overlay
          Center(
            child: Container(
              width: 280, height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 3),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  // Corner accents
                  ..._buildCorners(),
                ],
              ),
            ),
          ),
          // Top bar
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
                    Text('Scan QR Code', style: AppTypography.titleLarge.copyWith(color: Colors.white)),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
          ),
          // Instruction text
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: 0, right: 0,
            child: Text(
              'Align the QR code within the frame',
              style: AppTypography.bodyMedium.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ),
          // Bottom controls
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ControlButton(icon: Icons.flash_on_rounded, label: 'Flash', onTap: () {}),
                    _ControlButton(icon: Icons.flip_camera_ios_rounded, label: 'Flip', onTap: () {}),
                    _ControlButton(icon: Icons.photo_library_outlined, label: 'Gallery', onTap: () {}),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static List<Widget> _buildCorners() {
    return [
      Positioned(top: 0, left: 0, child: _Corner(alignment: Alignment.topLeft)),
      Positioned(top: 0, right: 0, child: _Corner(alignment: Alignment.topRight)),
      Positioned(bottom: 0, left: 0, child: _Corner(alignment: Alignment.bottomLeft)),
      Positioned(bottom: 0, right: 0, child: _Corner(alignment: Alignment.bottomRight)),
    ];
  }
}

class _Corner extends StatelessWidget {
  const _Corner({required this.alignment});
  final Alignment alignment;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24, height: 24,
      decoration: BoxDecoration(
        border: Border(
          top: alignment == Alignment.topLeft || alignment == Alignment.topRight ? const BorderSide(color: AppColors.primary, width: 4) : BorderSide.none,
          bottom: alignment == Alignment.bottomLeft || alignment == Alignment.bottomRight ? const BorderSide(color: AppColors.primary, width: 4) : BorderSide.none,
          left: alignment == Alignment.topLeft || alignment == Alignment.bottomLeft ? const BorderSide(color: AppColors.primary, width: 4) : BorderSide.none,
          right: alignment == Alignment.topRight || alignment == Alignment.bottomRight ? const BorderSide(color: AppColors.primary, width: 4) : BorderSide.none,
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTypography.labelSmall.copyWith(color: Colors.white70)),
        ],
      ),
    );
  }
}
