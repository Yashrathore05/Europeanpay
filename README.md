<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.24+-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.5+-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android" />
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License" />
</p>

# 💶 European Pay

**European Pay** is a production-grade fintech mobile application built with Flutter, designed for EU-based payment processing, QR transactions, open-banking integration, loyalty rewards, and merchant discovery. The application implements 18 feature modules spanning over 14,000 lines of Dart across 102 source files, following clean architecture principles with Riverpod state management and GoRouter navigation.

---

## 📋 Table of Contents

- [Features](#-features)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Prerequisites](#-prerequisites)
- [Getting Started](#-getting-started)
- [Project Structure](#-project-structure)
- [Building the APK](#-building-the-apk)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Design System](#-design-system)
- [Feature Modules](#-feature-modules)
- [Environment Configuration](#-environment-configuration)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [License](#-license)

---

## ✨ Features

| Category | Highlights |
|---|---|
| **Authentication** | Email/password sign-in, OTP verification, 2FA, biometric unlock, forgot-password flow, remember-me credential storage |
| **Dashboard** | Wallet balance, EU Pay Points summary, quick actions (QR, Send, Network, Banks), recent transactions, pull-to-refresh |
| **QR Scan & Pay** | Live camera scanner, gallery import, merchant QR validation, dynamic/fixed-amount support, PIN authorization |
| **EU Pay ID Transfers** | Peer-to-peer transfers via EU Pay ID, recipient lookup, transfer review, bank SCA web flow |
| **Bank Accounts** | Open Banking integration (Powens), multi-bank connections, balance visibility toggles, IBAN copy, sync status |
| **Linked Bank Payments** | Automatic bank ↔ EU Pay transaction matching, confidence scoring, claim EU Pay Points for verified matches |
| **Transactions** | Unified history across EU Pay, invoices, and bank sources; search, filters (source, status, date range), EN16931 PDF |
| **Invoices** | Deep-link invoice opening, amount display, PIN-authorized payment, bank SCA, payment status refresh |
| **Offers & Deals** | Nearby/online offers, category filters, location-based sorting, merchant map integration, redeem QR display |
| **EU Pay Points** | Points wallet, VIP tiers, streak tracking, reward rules, referral system, points withdrawal to IBAN |
| **My Network** | Contact management, favorites, search by EU Pay ID, person-level payment history |
| **Notifications** | In-app inbox, push notifications, filters by type, mark read, notification preference control center |
| **Profile** | Personal details management, phone verification, linked-bank count, change PIN, language preference |
| **Settings & Security** | Password change, transaction PIN setup/change/reset, app lock, biometric auth, 2FA toggle, timezone preference |
| **Localization** | Full English and French language support with dynamic locale switching |
| **My QR Code** | Personal payment QR generation, share/print QR image, EU Pay ID display |

---

## 🏗 Architecture

The application follows a **feature-first clean architecture** pattern with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────┐
│                     Presentation                        │
│   Screens · Widgets · ViewModels (Riverpod Providers)   │
├─────────────────────────────────────────────────────────┤
│                      Domain                             │
│          Models · Entities · Business Logic              │
├─────────────────────────────────────────────────────────┤
│                    Data / Services                       │
│    API Client (Dio) · Repositories · Local Storage       │
├─────────────────────────────────────────────────────────┤
│                    Core / Shared                         │
│  Theme · Router · Extensions · Utils · Shared Widgets    │
└─────────────────────────────────────────────────────────┘
```

**Key architectural decisions:**

- **State Management:** [Riverpod](https://riverpod.dev) for dependency injection and reactive state management
- **Routing:** [GoRouter](https://pub.dev/packages/go_router) for declarative, type-safe navigation with authentication-protected routes
- **Networking:** [Dio](https://pub.dev/packages/dio) as the HTTP client with structured `ApiResult` response handling
- **Code Generation:** Freezed + JSON Serializable for immutable models and serialization
- **Local Storage:** Hive for fast key-value storage, Flutter Secure Storage for sensitive credentials
- **Security:** Transaction PIN, biometric authentication via `local_auth`, and session management

---

## 🧰 Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.24+ / Dart 3.5+ |
| State Management | Riverpod 2.x with code generation |
| Navigation | GoRouter 14.x |
| HTTP Client | Dio 5.x |
| Models | Freezed + JSON Annotation |
| Local Storage | Hive + Flutter Secure Storage |
| Authentication | Local Auth (biometrics) |
| QR Scanning | Mobile Scanner 6.x |
| QR Generation | qr_flutter 4.x |
| UI Components | Google Fonts, Flutter SVG, Lottie, Shimmer |
| Responsive | Responsive Framework |
| Location | Geolocator |
| WebView | webview_flutter |
| Linting | flutter_lints with custom rules |
| CI/CD | GitHub Actions |

---

## 📦 Prerequisites

Before you begin, ensure you have the following installed on your development machine:

### Required

| Tool | Version | Installation |
|---|---|---|
| **Flutter SDK** | `>= 3.24.0` | [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install) |
| **Dart SDK** | `>= 3.5.0` | Bundled with Flutter |
| **Android Studio** | Latest stable | [developer.android.com/studio](https://developer.android.com/studio) |
| **Java JDK** | `17` | Via Android Studio or [Adoptium](https://adoptium.net/) |
| **Git** | Latest | [git-scm.com](https://git-scm.com/) |

### Android SDK Requirements

| Component | Version |
|---|---|
| Compile SDK | 34 |
| Min SDK | 21 (Android 5.0) |
| Target SDK | 34 |
| Build Tools | 34.0.0 |

### Verify Installation

```bash
# Verify Flutter installation and check for issues
flutter doctor -v

# Expected output should show no errors for:
# ✓ Flutter
# ✓ Android toolchain
# ✓ Android Studio
```

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/Yashrathore05/Europeanpay.git
cd Europeanpay
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Platform Files

Since platform directories (`android/`, `ios/`, `web/`) are excluded from version control for cleanliness, regenerate them before building:

```bash
flutter create --platforms=android --project-name=european_pay .
```

### 4. Configure Android Manifest

The app requires biometric permissions and `FlutterFragmentActivity` for `local_auth` support. Apply the following patches after platform generation:

**Add biometric permission** to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
```

**Update MainActivity** in `android/app/src/main/kotlin/.../MainActivity.kt`:

```kotlin
// Change this:
import io.flutter.embedding.android.FlutterActivity
class MainActivity: FlutterActivity()

// To this:
import io.flutter.embedding.android.FlutterFragmentActivity
class MainActivity: FlutterFragmentActivity()
```

> **Tip:** The CI/CD pipeline automates these patches. For local development, you can run the same Python script from the workflow — see [CI/CD Pipeline](#-cicd-pipeline).

### 5. Run the Application

```bash
# Run in debug mode on a connected device or emulator
flutter run

# Run on a specific device
flutter devices                  # List available devices
flutter run -d <device-id>       # Run on specific device
```

### 6. Run Code Generation (if modifying models)

```bash
# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for continuous generation during development
flutter pub run build_runner watch --delete-conflicting-outputs
```

---

## 📂 Project Structure

```
european_pay/
├── .github/
│   └── workflows/
│       └── build_apk.yml          # GitHub Actions CI/CD pipeline
├── lib/
│   ├── main.dart                   # Application entry point
│   ├── app.dart                    # Root MaterialApp widget
│   ├── core/                       # Core application infrastructure
│   │   ├── constants/              # App-wide constants and config values
│   │   ├── extensions/             # Dart extension methods
│   │   ├── network/                # API client and result types
│   │   ├── router/                 # GoRouter configuration and route names
│   │   ├── services/               # Core services (payment simulator, security, session)
│   │   ├── theme/                  # Design system (colors, typography, spacing, elevation)
│   │   └── utils/                  # Utility functions and helpers
│   ├── features/                   # Feature modules (feature-first architecture)
│   │   ├── authentication/         # Sign-in, sign-up, OTP, 2FA, password reset
│   │   ├── bank_accounts/          # Open banking, account management, bank transactions
│   │   ├── dashboard/              # Home screen, wallet, quick actions
│   │   ├── eu_pay_id/              # EU Pay ID transfers and recipient lookup
│   │   ├── invoices/               # Invoice viewing and payment
│   │   ├── linked_bank_payments/   # Bank ↔ EU Pay transaction matching
│   │   ├── loyalty/                # EU Pay Points, tiers, rewards, referrals, withdrawal
│   │   ├── my_network/             # Contact management and favorites
│   │   ├── my_qr/                  # Personal QR code generation and sharing
│   │   ├── notifications/          # Notification inbox and preference management
│   │   ├── offers/                 # Merchant offers, deals, location-based discovery
│   │   ├── onboarding/             # First-launch language selection and onboarding
│   │   ├── profile/                # User profile and personal details
│   │   ├── scan_pay/               # QR scanner, payment processing, results
│   │   ├── settings/               # Security settings, PIN, biometrics, 2FA, preferences
│   │   ├── splash/                 # Splash screen with routing logic
│   │   ├── support/                # Help and support
│   │   └── transactions/           # Transaction history, filters, details, receipts
│   └── shared/
│       └── widgets/                # Reusable UI components
├── pubspec.yaml                    # Dependencies and project configuration
├── analysis_options.yaml           # Lint rules and static analysis config
└── .gitignore
```

---

## 📱 Building the APK

### Debug APK

```bash
# Quick debug build for testing
flutter build apk --debug
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`

### Release APK

```bash
# Optimized production build
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Split APKs per ABI (Recommended for Distribution)

Generates smaller APKs optimized for each CPU architecture:

```bash
flutter build apk --split-per-abi --release
```

Output:
```
build/app/outputs/flutter-apk/
├── app-armeabi-v7a-release.apk    # ~15-20 MB (32-bit ARM)
├── app-arm64-v8a-release.apk      # ~15-20 MB (64-bit ARM — most devices)
└── app-x86_64-release.apk         # ~15-20 MB (x86 emulators)
```

### App Bundle (for Google Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### Full Local Build Script

Run this end-to-end script to build a release APK from a clean state:

```bash
#!/bin/bash
set -e

# Step 1: Install dependencies
flutter pub get

# Step 2: Regenerate platform files
flutter create --platforms=android --project-name=european_pay .

# Step 3: Patch AndroidManifest for biometric support
python3 - <<'PY'
from pathlib import Path

manifest = Path("android/app/src/main/AndroidManifest.xml")
text = manifest.read_text()
permission = '<uses-permission android:name="android.permission.USE_BIOMETRIC" />'
if permission not in text:
    text = text.replace("    <application", f"    {permission}\n\n    <application", 1)
    manifest.write_text(text)

for activity in Path("android/app/src/main").rglob("MainActivity.kt"):
    source = activity.read_text()
    source = source.replace(
        "import io.flutter.embedding.android.FlutterActivity",
        "import io.flutter.embedding.android.FlutterFragmentActivity",
    ).replace("FlutterActivity()", "FlutterFragmentActivity()")
    activity.write_text(source)
PY

# Step 4: Build release APK
flutter build apk --release

echo "✅ APK built successfully:"
echo "   build/app/outputs/flutter-apk/app-release.apk"
```

---

## ⚙ CI/CD Pipeline

The project includes a GitHub Actions workflow (`.github/workflows/build_apk.yml`) that automates the build process on every push and pull request to `main`.

### Pipeline Steps

```
Checkout → Setup Java 17 → Setup Flutter (stable) → Regenerate Android platform
→ Patch Manifest & MainActivity → Install dependencies → Build Release APK → Upload Artifact
```

### Triggering a Build

| Trigger | Description |
|---|---|
| `push` to `main` | Automatic build on every merge/push |
| `pull_request` to `main` | Build validation on PRs |
| `workflow_dispatch` | Manual trigger from GitHub Actions UI |

### Downloading the APK from CI

1. Go to the [**Actions**](https://github.com/Yashrathore05/Europeanpay/actions) tab on GitHub
2. Select the latest successful **Build Release APK** workflow run
3. Download the `release-apk` artifact from the **Artifacts** section

---

## 🎨 Design System

The application implements a comprehensive design system inspired by Stripe and Apple Pay aesthetics:

### Color Palette

| Token | Value | Usage |
|---|---|---|
| Base Canvas | `#09090b` | Primary dark background |
| Surface Bright | `#18181b` | Elevated card backgrounds |
| Primary Blue | `#3b82f6` | Active states, CTAs, focus indicators |
| Secondary Green | `#10b981` | Success states, positive balances, loyalty |
| Tertiary Amber | `#f59e0b` | Warnings, pending states |
| Error Red | `#ef4444` | Error states, failed transactions |
| On Surface | `#f4f4f5` | Primary text |
| On Surface Variant | `#a1a1aa` | Secondary/muted text |
| Outline | `#27272a` | Borders and dividers |

### Typography

- **Font:** Inter (via Google Fonts)
- **Monospace:** Geist (for IBANs, transaction IDs, EU Pay IDs)
- **Scaling:** Tight tracking (`-0.02em` to `-0.03em`) on headings for a structured, authoritative feel

### Elevation System

| Level | Surface | Border | Usage |
|---|---|---|---|
| 0 | `#09090b` | — | Background canvas |
| 1 | `#121214` | `1px #27272a` | Cards and list items |
| 2 | `#1a1a1e` | `1px #3f3f46` | Modals and bottom sheets |

---

## 📦 Feature Modules

Each feature follows a consistent internal structure:

```
feature_name/
├── models/          # Data models and entities
├── providers/       # Riverpod state providers
├── screens/         # Full-page screen widgets
└── widgets/         # Feature-specific UI components
```

### Module Inventory (18 modules, 74 feature files)

| Module | Files | Description |
|---|---|---|
| `authentication` | 11 | Full auth lifecycle — sign-up, sign-in, OTP, 2FA, password reset |
| `loyalty` | 11 | Points wallet, tiers, rewards, referrals, withdrawal |
| `bank_accounts` | 8 | Open banking, multi-bank management, bank transactions |
| `settings` | 8 | Security settings, PIN, biometrics, language, timezone |
| `eu_pay_id` | 6 | Peer-to-peer transfers via EU Pay ID |
| `dashboard` | 5 | Home screen, wallet summary, quick actions |
| `linked_bank_payments` | 5 | Bank ↔ EU Pay transaction matching engine |
| `transactions` | 3 | Unified transaction history with filters |
| `scan_pay` | 3 | QR scanner, payment flow, result states |
| `support` | 2 | Help and support center |
| `profile` | 2 | User profile management |
| `onboarding` | 2 | Language selection and first-launch flow |
| `offers` | 2 | Merchant offers and deals discovery |
| `notifications` | 2 | Notification inbox and preferences |
| `splash` | 1 | Splash screen and routing |
| `my_qr` | 1 | Personal payment QR code |
| `my_network` | 1 | Contact and network management |
| `invoices` | 1 | Invoice payment processing |

---

## 🔧 Environment Configuration

### Supported Flutter Channels

| Channel | Status |
|---|---|
| **Stable** | ✅ Recommended |
| Beta | ⚠️ Not tested |
| Dev | ❌ Not supported |

### Minimum Platform Versions

| Platform | Minimum Version |
|---|---|
| Android | API 21 (Android 5.0 Lollipop) |
| Java | JDK 17 |

---

## 🔍 Troubleshooting

### Common Issues

<details>
<summary><strong>MissingPluginException for local_auth</strong></summary>

**Cause:** `MainActivity` extends `FlutterActivity` instead of `FlutterFragmentActivity`.

**Fix:** Update `android/app/src/main/kotlin/.../MainActivity.kt`:

```kotlin
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity()
```

</details>

<details>
<summary><strong>Android platform directory not found</strong></summary>

**Cause:** Platform directories are excluded from version control.

**Fix:** Regenerate them:

```bash
flutter create --platforms=android --project-name=european_pay .
```

</details>

<details>
<summary><strong>Gradle build fails with JDK version error</strong></summary>

**Cause:** Wrong Java version. The project requires JDK 17.

**Fix:** Verify and set Java version:

```bash
java -version  # Should show 17.x

# If using multiple JDK versions, set JAVA_HOME:
export JAVA_HOME=/path/to/jdk-17
```

</details>

<details>
<summary><strong>Build runner conflicts</strong></summary>

**Cause:** Stale generated files conflicting with new model changes.

**Fix:**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

</details>

<details>
<summary><strong>flutter pub get fails with version conflicts</strong></summary>

**Fix:** Clear the pub cache and retry:

```bash
flutter pub cache repair
flutter pub get
```

</details>

---

## 🤝 Contributing

Contributions are welcome. Please follow these guidelines:

### Development Workflow

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feat/your-feature-name`
3. **Commit** with conventional commits: `feat:`, `fix:`, `refactor:`, `docs:`
4. **Push** to your fork: `git push origin feat/your-feature-name`
5. **Open** a Pull Request against `main`

### Code Standards

- Run `flutter analyze` before committing — zero warnings required
- Follow the lint rules defined in `analysis_options.yaml`
- Use `const` constructors wherever possible
- Prefer single quotes for strings
- Sort child properties last in widget constructors
- All new features must follow the feature-first module structure

### Commit Convention

```
feat: add bank account detail view
fix: resolve QR scanner orientation crash
refactor: extract shared transaction card widget
docs: update README setup instructions
ci: add iOS build workflow
```

---

## 📄 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

---

<p align="center">
  Built with Flutter 💙
</p>
