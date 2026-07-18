import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/eu_buttons.dart';
import '../../domain/models/bank_account.dart';
import '../../application/bank_accounts_provider.dart';

class BankConnectScreen extends ConsumerStatefulWidget {
  const BankConnectScreen({super.key});

  @override
  ConsumerState<BankConnectScreen> createState() => _BankConnectScreenState();
}

class _BankConnectScreenState extends ConsumerState<BankConnectScreen> {
  final _ibanController = TextEditingController();
  final _accountNameController = TextEditingController(text: 'Primary Checking');
  bool _isConnecting = false;
  String _ibanInput = '';

  @override
  void initState() {
    super.initState();
    _ibanController.addListener(() {
      setState(() {
        _ibanInput = _ibanController.text;
      });
    });
  }

  @override
  void dispose() {
    _ibanController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  bool get _isValid => isValidIbanChecksum(_ibanInput);

  Future<void> _submitConnection(String bankName, String country) async {
    setState(() => _isConnecting = true);

    final cleanIban = _ibanInput.replaceAll(' ', '').toUpperCase();
    final newAccount = BankAccount(
      id: 'acc_${DateTime.now().millisecondsSinceEpoch}',
      bankName: bankName,
      accountName: _accountNameController.text.trim().isNotEmpty 
          ? _accountNameController.text.trim() 
          : 'Checking Account',
      iban: _ibanInput.toUpperCase(),
      accountNumber: cleanIban.length > 10 ? cleanIban.substring(cleanIban.length - 10) : cleanIban,
      balance: 1500.00, // mock initial balance
      available: 1500.00,
      pending: 0.00,
      type: 'Checking',
      lastSynced: DateTime.now(),
      isPrimary: false,
    );

    final success = await ref.read(bankAccountsNotifierProvider.notifier).addAccount(newAccount);

    if (mounted) {
      setState(() => _isConnecting = false);
      if (success) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully linked $bankName Account!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to link bank account. Please try again.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = getIbanDetails(_ibanInput);
    final hasInput = _ibanInput.replaceAll(' ', '').isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Verify IBAN'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePaddingH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Link Bank Account',
              style: AppTypography.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Enter your international bank account number (IBAN) to establish a PSD2 open banking connection.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Account Name field
            Text(
              'Account Name',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              controller: _accountNameController,
              cursorColor: AppColors.primary,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                hintText: 'e.g. Main Checking, Savings',
                hintStyle: TextStyle(color: AppColors.textTertiary),
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  borderSide: const BorderSide(color: AppColors.border, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // IBAN Input Field
            Text(
              'IBAN',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              controller: _ibanController,
              cursorColor: AppColors.primary,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                IbanFormatter(),
                LengthLimitingTextInputFormatter(34), // max IBAN length with spaces
              ],
              style: AppTypography.mono.copyWith(
                color: AppColors.textPrimary,
                fontSize: 15,
                letterSpacing: 1.2,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                hintText: 'FR76 3000 2000 0000 0000 0000 123',
                hintStyle: AppTypography.mono.copyWith(color: AppColors.textTertiary, fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  borderSide: BorderSide(
                    color: !hasInput 
                        ? AppColors.border 
                        : (_isValid ? AppColors.success.withValues(alpha: 0.5) : AppColors.error.withValues(alpha: 0.5)), 
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  borderSide: BorderSide(
                    color: !hasInput 
                        ? AppColors.primary 
                        : (_isValid ? AppColors.success : AppColors.error), 
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Validation Feedback Card
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _buildFeedbackWidget(hasInput, _isValid, details),
            ),
            const SizedBox(height: AppSpacing.xxxl),

            // CTA Button
            EuPrimaryButton(
              label: 'Connect and Link Bank',
              isLoading: _isConnecting,
              onPressed: _isValid && details != null
                  ? () => _submitConnection(details['bankName']!, details['country']!)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackWidget(bool hasInput, bool isValid, Map<String, String>? details) {
    if (!hasInput) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: AppColors.textTertiary, size: 20),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Enter your IBAN to verify its checksum status (MOD-97 check).',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      );
    }

    if (isValid && details != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.successLight,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'Valid IBAN Checksum',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    details['countryCode']!,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: AppSpacing.md),
            _buildDetailRow('Bank Name', details['bankName']!),
            const SizedBox(height: AppSpacing.sm),
            _buildDetailRow('Country', details['country']!),
          ],
        ),
      );
    }

    // Invalid state
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.failedBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Invalid IBAN format or checksum failed (MOD-97 check failed).',
              style: AppTypography.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
        ),
        Text(
          value,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // Helper validation methods
  bool isValidIbanChecksum(String iban) {
    final cleaned = iban.replaceAll(' ', '').toUpperCase();
    if (cleaned.length < 15 || cleaned.length > 34) return false;
    
    if (!RegExp(r'^[A-Z]{2}\d{2}[A-Z0-9]+$').hasMatch(cleaned)) return false;

    final rearranged = cleaned.substring(4) + cleaned.substring(0, 4);
    
    final sb = StringBuffer();
    for (var i = 0; i < rearranged.length; i++) {
      final char = rearranged[i];
      final code = char.codeUnitAt(0);
      if (code >= 65 && code <= 90) { // A-Z
        sb.write((code - 55).toString());
      } else if (code >= 48 && code <= 57) { // 0-9
        sb.write(char);
      } else {
        return false;
      }
    }

    final numStr = sb.toString();
    int remainder = 0;
    for (var i = 0; i < numStr.length; i++) {
      remainder = (remainder * 10 + int.parse(numStr[i])) % 97;
    }
    
    return remainder == 1;
  }

  Map<String, String>? getIbanDetails(String iban) {
    if (!isValidIbanChecksum(iban)) return null;
    final cleaned = iban.replaceAll(' ', '').toUpperCase();
    final countryCode = cleaned.substring(0, 2);
    
    String country = 'Unknown';
    String bankName = 'Standard Euro Bank';
    
    if (countryCode == 'FR') {
      country = 'France';
      if (cleaned.length >= 9) {
        final bankCode = cleaned.substring(4, 9);
        if (bankCode == '10007') bankName = 'Société Générale';
        else if (bankCode == '30002') bankName = 'BNP Paribas';
        else if (bankCode == '30003') bankName = 'Société Générale';
        else if (bankCode == '30004') bankName = 'LCL';
        else if (bankCode == '16278') bankName = 'Qonto';
        else bankName = 'French Retail Bank';
      }
    } else if (countryCode == 'DE') {
      country = 'Germany';
      if (cleaned.length >= 12) {
        final bankCode = cleaned.substring(4, 12);
        if (bankCode.startsWith('100')) bankName = 'Deutsche Bank';
        else if (bankCode.startsWith('500')) bankName = 'Commerzbank';
        else bankName = 'German Federal Bank';
      }
    } else if (countryCode == 'ES') {
      country = 'Spain';
      bankName = 'Banco Santander';
    } else if (countryCode == 'IT') {
      country = 'Italy';
      bankName = 'UniCredit';
    } else {
      country = 'European Union ($countryCode)';
    }
    
    return {
      'country': country,
      'bankName': bankName,
      'countryCode': countryCode,
    };
  }
}

class IbanFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '').toUpperCase();
    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      final nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
