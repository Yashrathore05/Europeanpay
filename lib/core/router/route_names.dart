/// Route name constants for European Pay navigation.
abstract final class RouteNames {
  // ── Root ────────────────────────────────────────────────────
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String languageSelection = 'language-selection';

  // ── Auth ────────────────────────────────────────────────────
  static const String login = 'login';
  static const String signUp = 'sign-up';
  static const String otpVerification = 'otp-verification';
  static const String forgotPassword = 'forgot-password';
  static const String resetPassword = 'reset-password';
  static const String twoFactor = 'two-factor';
  static const String pinLock = 'pin-lock';

  // ── Main Shell ─────────────────────────────────────────────
  static const String home = 'home';
  static const String dashboard = 'dashboard';
  static const String transactions = 'transactions';
  static const String qrScanner = 'qr-scanner';
  static const String loyalty = 'loyalty';
  static const String offers = 'offers';

  // ── Dashboard Sub ──────────────────────────────────────────
  static const String euPayIdTransfer = 'eu-pay-id-transfer';
  static const String recipientLookup = 'recipient-lookup';
  static const String transferAmount = 'transfer-amount';
  static const String transferReview = 'transfer-review';
  static const String transferResult = 'transfer-result';
  static const String myQr = 'my-qr';
  static const String myNetwork = 'my-network';
  static const String networkPersonDetail = 'network-person-detail';

  // ── QR Scanner Sub ─────────────────────────────────────────
  static const String paymentPreview = 'payment-preview';
  static const String paymentResult = 'payment-result';

  // ── Transactions Sub ───────────────────────────────────────
  static const String transactionDetail = 'transaction-detail';

  // ── Bank Accounts ──────────────────────────────────────────
  static const String bankAccounts = 'bank-accounts';
  static const String bankConnect = 'bank-connect';
  static const String bankAuth = 'bank-auth';
  static const String accountDetail = 'account-detail';
  static const String bankTransactions = 'bank-transactions';
  static const String bankTransactionDetail = 'bank-transaction-detail';
  static const String bankTransfers = 'bank-transfers';
  static const String linkedBankPayments = 'linked-bank-payments';

  // ── Invoices ───────────────────────────────────────────────
  static const String invoiceDetail = 'invoice-detail';
  static const String invoicePayment = 'invoice-payment';

  // ── Offers Sub ─────────────────────────────────────────────
  static const String offerDetail = 'offer-detail';
  static const String redeemQr = 'redeem-qr';

  // ── Loyalty Sub ────────────────────────────────────────────
  static const String pointsHistory = 'points-history';
  static const String pointsDetail = 'points-detail';
  static const String rewardRules = 'reward-rules';
  static const String referral = 'referral';
  static const String membership = 'membership';
  static const String loyaltyTerms = 'loyalty-terms';
  static const String withdrawal = 'withdrawal';
  static const String withdrawalHistory = 'withdrawal-history';

  // ── Notifications ──────────────────────────────────────────
  static const String notifications = 'notifications';
  static const String notificationPreferences = 'notification-preferences';

  // ── Profile ────────────────────────────────────────────────
  static const String profile = 'profile';
  static const String personalDetails = 'personal-details';
  static const String phoneVerification = 'phone-verification';

  // ── Settings ───────────────────────────────────────────────
  static const String settings = 'settings';
  static const String changePassword = 'change-password';
  static const String setupPin = 'setup-pin';
  static const String changePin = 'change-pin';
  static const String forgotPin = 'forgot-pin';
  static const String biometricSetup = 'biometric-setup';
  static const String twoFactorSetup = 'two-factor-setup';
  static const String languagePreference = 'language-preference';
  static const String timezonePreference = 'timezone-preference';

  // ── Support / Info ─────────────────────────────────────────
  static const String support = 'support';
  static const String termsOfService = 'terms-of-service';
  static const String privacyPolicy = 'privacy-policy';

  // ── PIN Auth ───────────────────────────────────────────────
  static const String pinAuth = 'pin-auth';
}

