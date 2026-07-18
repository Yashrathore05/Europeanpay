import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _isFlashOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Simulated Camera Preview
          Container(
            color: Colors.black,
            child: Center(
              child: Opacity(
                opacity: 0.3,
                child: Icon(
                  Icons.photo_camera_back_outlined,
                  size: 120,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ),
          
          // Viewfinder Frame
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Stack(
                children: _buildCorners(),
              ),
            ),
          ),

          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                      onPressed: () => context.pop(),
                    ),
                    Text(
                      'Scan QR Code',
                      style: AppTypography.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                        color: _isFlashOn ? AppColors.primary : Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          _isFlashOn = !_isFlashOn;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Instructions & Guide
          Positioned(
            top: MediaQuery.of(context).size.height * 0.22,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: Text(
                'Align merchant or invoice QR code within the frame',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Quick actions (Gallery / Enter ID Manually)
          Positioned(
            bottom: AppSpacing.xxxl,
            left: AppSpacing.xxl,
            right: AppSpacing.xxl,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EuSecondaryButton(
                    label: 'Upload from Gallery',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Accessing gallery...')),
                      );
                    },
                    icon: Icons.photo_library_outlined,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  EuTextButton(
                    label: 'Enter Merchant ID Manually',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening manual entry portal...')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static List<Widget> _buildCorners() {
    const double length = 24;
    const double thickness = 3;
    return [
      // Top Left Corner
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          width: length,
          height: length,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.primary, width: thickness),
              left: BorderSide(color: AppColors.primary, width: thickness),
            ),
          ),
        ),
      ),
      // Top Right Corner
      Positioned(
        top: 0,
        right: 0,
        child: Container(
          width: length,
          height: length,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.primary, width: thickness),
              right: BorderSide(color: AppColors.primary, width: thickness),
            ),
          ),
        ),
      ),
      // Bottom Left Corner
      Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          width: length,
          height: length,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.primary, width: thickness),
              left: BorderSide(color: AppColors.primary, width: thickness),
            ),
          ),
        ),
      ),
      // Bottom Right Corner
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: length,
          height: length,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.primary, width: thickness),
              right: BorderSide(color: AppColors.primary, width: thickness),
            ),
          ),
        ),
      ),
    ];
  }
}
