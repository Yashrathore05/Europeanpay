import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';

// Feature screen imports
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/presentation/screens/language_selection_screen.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/sign_up_screen.dart';
import '../../features/authentication/presentation/screens/otp_verification_screen.dart';
import '../../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../../features/authentication/presentation/screens/reset_password_screen.dart';
import '../../features/authentication/presentation/screens/two_factor_screen.dart';
import '../../features/authentication/presentation/screens/pin_lock_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/transactions/presentation/screens/transactions_screen.dart';
import '../../features/transactions/presentation/screens/transaction_detail_screen.dart';
import '../../features/scan_pay/presentation/screens/qr_scanner_screen.dart';
import '../../features/scan_pay/presentation/screens/payment_preview_screen.dart';
import '../../features/scan_pay/presentation/screens/payment_result_screen.dart';
import '../../features/loyalty/presentation/screens/loyalty_screen.dart';
import '../../features/loyalty/presentation/screens/points_history_screen.dart';
import '../../features/loyalty/presentation/screens/reward_rules_screen.dart';
import '../../features/loyalty/presentation/screens/referral_screen.dart';
import '../../features/loyalty/presentation/screens/membership_screen.dart';
import '../../features/loyalty/presentation/screens/loyalty_terms_screen.dart';
import '../../features/loyalty/presentation/screens/withdrawal_screen.dart';
import '../../features/offers/presentation/screens/offers_screen.dart';
import '../../features/offers/presentation/screens/offer_detail_screen.dart';
import '../../features/eu_pay_id/presentation/screens/eu_pay_id_transfer_screen.dart';
import '../../features/eu_pay_id/presentation/screens/transfer_result_screen.dart';
import '../../features/my_qr/presentation/screens/my_qr_screen.dart';
import '../../features/my_network/presentation/screens/my_network_screen.dart';
import '../../features/bank_accounts/presentation/screens/bank_accounts_screen.dart';
import '../../features/bank_accounts/presentation/screens/bank_connect_screen.dart';
import '../../features/bank_accounts/presentation/screens/account_detail_screen.dart';
import '../../features/bank_accounts/presentation/screens/bank_transactions_screen.dart';
import '../../features/linked_bank_payments/presentation/screens/linked_bank_payments_screen.dart';
import '../../features/invoices/presentation/screens/invoice_detail_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/notifications/presentation/screens/notification_preferences_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/personal_details_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/change_password_screen.dart';
import '../../features/settings/presentation/screens/pin_setup_screen.dart';
import '../../features/settings/presentation/screens/two_factor_setup_screen.dart';
import '../../features/support/presentation/screens/support_screen.dart';
import '../../features/support/presentation/screens/document_viewer_screen.dart';
import '../../shared/widgets/layout/main_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

/// GoRouter configuration for European Pay.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    // ── Splash ─────────────────────────────────────────────
    GoRoute(
      path: '/',
      name: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    // ── Onboarding ─────────────────────────────────────────
    GoRoute(
      path: '/onboarding',
      name: RouteNames.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/language-selection',
      name: RouteNames.languageSelection,
      builder: (context, state) => const LanguageSelectionScreen(),
    ),

    // ── Auth ───────────────────────────────────────────────
    GoRoute(
      path: '/login',
      name: RouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/sign-up',
      name: RouteNames.signUp,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/otp-verification',
      name: RouteNames.otpVerification,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return OtpVerificationScreen(
          email: extra['email'] as String? ?? '',
          purpose: extra['purpose'] as String? ?? 'registration',
        );
      },
    ),
    GoRoute(
      path: '/forgot-password',
      name: RouteNames.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      name: RouteNames.resetPassword,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return ResetPasswordScreen(
          email: extra['email'] as String? ?? '',
        );
      },
    ),
    GoRoute(
      path: '/two-factor',
      name: RouteNames.twoFactor,
      builder: (context, state) => const TwoFactorScreen(),
    ),
    GoRoute(
      path: '/pin-lock',
      name: RouteNames.pinLock,
      builder: (context, state) => const PinLockScreen(),
    ),

    // ── Main Shell with Bottom Nav ─────────────────────────
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          name: RouteNames.dashboard,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DashboardScreen(),
          ),
        ),
        GoRoute(
          path: '/transactions',
          name: RouteNames.transactions,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TransactionsScreen(),
          ),
        ),
        GoRoute(
          path: '/qr-scanner',
          name: RouteNames.qrScanner,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: QrScannerScreen(),
          ),
        ),
        GoRoute(
          path: '/loyalty',
          name: RouteNames.loyalty,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LoyaltyScreen(),
          ),
        ),
        GoRoute(
          path: '/offers',
          name: RouteNames.offers,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: OffersScreen(),
          ),
        ),
      ],
    ),

    // ── Dashboard Sub-routes ───────────────────────────────
    GoRoute(
      path: '/eu-pay-id-transfer',
      name: RouteNames.euPayIdTransfer,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return EuPayIdTransferScreen(
          initialRecipientId: extra['recipientId'] as String?,
        );
      },
    ),
    GoRoute(
      path: '/transfer-result',
      name: RouteNames.transferResult,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return TransferResultScreen(resultData: extra);
      },
    ),
    GoRoute(
      path: '/my-qr',
      name: RouteNames.myQr,
      builder: (context, state) => const MyQrScreen(),
    ),
    GoRoute(
      path: '/my-network',
      name: RouteNames.myNetwork,
      builder: (context, state) => const MyNetworkScreen(),
    ),

    // ── QR Payment Sub-routes ──────────────────────────────
    GoRoute(
      path: '/payment-preview',
      name: RouteNames.paymentPreview,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return PaymentPreviewScreen(paymentData: extra);
      },
    ),
    GoRoute(
      path: '/payment-result',
      name: RouteNames.paymentResult,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return PaymentResultScreen(resultData: extra);
      },
    ),

    // ── Transaction Detail ─────────────────────────────────
    GoRoute(
      path: '/transaction/:id',
      name: RouteNames.transactionDetail,
      builder: (context, state) => TransactionDetailScreen(
        transactionId: state.pathParameters['id'] ?? '',
      ),
    ),

    // ── Bank Accounts ──────────────────────────────────────
    GoRoute(
      path: '/bank-accounts',
      name: RouteNames.bankAccounts,
      builder: (context, state) => const BankAccountsScreen(),
    ),
    GoRoute(
      path: '/bank-connect',
      name: RouteNames.bankConnect,
      builder: (context, state) => const BankConnectScreen(),
    ),
    GoRoute(
      path: '/account-detail/:id',
      name: RouteNames.accountDetail,
      builder: (context, state) => AccountDetailScreen(
        accountId: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      path: '/bank-transactions',
      name: RouteNames.bankTransactions,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return BankTransactionsScreen(
          accountId: extra['accountId'] as String?,
        );
      },
    ),
    GoRoute(
      path: '/linked-bank-payments',
      name: RouteNames.linkedBankPayments,
      builder: (context, state) => const LinkedBankPaymentsScreen(),
    ),

    // ── Invoices ───────────────────────────────────────────
    GoRoute(
      path: '/invoice/:id',
      name: RouteNames.invoiceDetail,
      builder: (context, state) => InvoiceDetailScreen(
        invoiceId: state.pathParameters['id'] ?? '',
      ),
    ),

    // ── Offers Sub-routes ──────────────────────────────────
    GoRoute(
      path: '/offer/:id',
      name: RouteNames.offerDetail,
      builder: (context, state) => OfferDetailScreen(
        offerId: state.pathParameters['id'] ?? '',
      ),
    ),

    // ── Loyalty Sub-routes ─────────────────────────────────
    GoRoute(
      path: '/points-history',
      name: RouteNames.pointsHistory,
      builder: (context, state) => const PointsHistoryScreen(),
    ),
    GoRoute(
      path: '/reward-rules',
      name: RouteNames.rewardRules,
      builder: (context, state) => const RewardRulesScreen(),
    ),
    GoRoute(
      path: '/referral',
      name: RouteNames.referral,
      builder: (context, state) => const ReferralScreen(),
    ),
    GoRoute(
      path: '/membership',
      name: RouteNames.membership,
      builder: (context, state) => const MembershipScreen(),
    ),
    GoRoute(
      path: '/loyalty-terms',
      name: RouteNames.loyaltyTerms,
      builder: (context, state) => const LoyaltyTermsScreen(),
    ),
    GoRoute(
      path: '/withdrawal',
      name: RouteNames.withdrawal,
      builder: (context, state) => const WithdrawalScreen(),
    ),

    // ── Notifications ──────────────────────────────────────
    GoRoute(
      path: '/notifications',
      name: RouteNames.notifications,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/notification-preferences',
      name: RouteNames.notificationPreferences,
      builder: (context, state) => const NotificationPreferencesScreen(),
    ),

    // ── Profile ────────────────────────────────────────────
    GoRoute(
      path: '/profile',
      name: RouteNames.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/personal-details',
      name: RouteNames.personalDetails,
      builder: (context, state) => const PersonalDetailsScreen(),
    ),

    // ── Settings ───────────────────────────────────────────
    GoRoute(
      path: '/settings',
      name: RouteNames.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/change-password',
      name: RouteNames.changePassword,
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: '/setup-pin',
      name: RouteNames.setupPin,
      builder: (context, state) => const PinSetupScreen(),
    ),
    GoRoute(
      path: '/two-factor-setup',
      name: RouteNames.twoFactorSetup,
      builder: (context, state) => const TwoFactorSetupScreen(),
    ),

    // ── Support & Legal ──────────────────────────────────────
    GoRoute(
      path: '/support',
      name: RouteNames.support,
      builder: (context, state) => const SupportScreen(),
    ),
    GoRoute(
      path: '/terms-of-service',
      name: RouteNames.termsOfService,
      builder: (context, state) => const DocumentViewerScreen(
        title: 'Terms of Service',
        content: 'Welcome to EU Pay. These Terms of Service govern your use of our application, website, and simulated financial services. By accessing or using our services, you agree to be bound by these terms. We provide private payments, open banking connections via Powens, and a loyalty points rewards program. EU Pay reserves the right to modify or terminate features or update cashback streaks and tiers at any time. Check the rules and withdrawal eligibility criteria frequently to stay informed.',
      ),
    ),
    GoRoute(
      path: '/privacy-policy',
      name: RouteNames.privacyPolicy,
      builder: (context, state) => const DocumentViewerScreen(
        title: 'Privacy Policy',
        content: 'EU Pay is committed to protecting your privacy. This Privacy Policy describes how we collect, use, and disclose personal details, linked bank accounts, and transaction information. We process data to offer simulated open banking features, calculate loyalty points cashback, and verify recipient information. We use Powens to securely read bank credentials without directly storing them on our servers. All logins and sensitive actions are protected with 2FA, session timeout limits, and PIN confirmation.',
      ),
    ),
  ],
);

