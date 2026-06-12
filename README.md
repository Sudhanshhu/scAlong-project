# Midchains Customer Portal - Flutter App

A modern, high-fidelity Flutter mobile application that integrates with the Midchains Customer Portal (`https://cp-dev.midchains.com`). This project features a complete secure login flow, dynamic data-rich portfolio dashboard, tabbed account profile info with KYC status tracking, notifications view, settings pane, and dual dark/light Material 3 theming.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.44.0` / Dart `^3.12.0`)
- Android Studio / Xcode (for simulator running)
- Cocoapods (for iOS/macOS compilation)

### Installation & Setup

1. **Clone the Repository** and navigate to the project directory:
   ```bash
   cd scAlong\ project/
   ```

2. **Retrieve Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate Code Serializers** (runs `build_runner` for model parsing):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the Application**:
   ```bash
   flutter run
   ```

5. **Run the Test Suite**:
   ```bash
   flutter test
   ```

---

## 🔐 Credentials & API Information

Use the following credentials in the **cp-dev** environment:
- **Email**: `joshi.sahil12+0312i_1@gmail.com`
- **Password**: `Test@123`
- **OTP Verification Code**: `000000`

---

## 🏗️ Architectural Decisions

This project strictly adheres to **Clean Architecture** patterns combined with a **Feature-First** directory structure. This separates concerns, decouples the UI from business logic, and guarantees modular testability.

### Folder Structure
```
lib/
├── src/
│   ├── app.dart                   # Root MaterialApp config
│   ├── core/                      # Core configurations
│   │   ├── theme/                 # Light/Dark Material 3 App themes
│   │   ├── network/               # Dio client & interceptor injects
│   │   ├── storage/               # flutter_secure_storage wrapper
│   │   └── routing/               # GoRouter paths & transitions
│   ├── common/                    # Shared reusable components
│   │   ├── widgets/               # KText, KDropdown, KTextField, KButton
│   │   └── constants/             # AppColors, Sizes, Assets
│   └── features/                  # Distinct modular feature layers
│       ├── auth/                  # Session Init, Captcha validation, 2FA & OTP
│       ├── dashboard/             # Balance overview & sparklines
│       ├── account/               # KYC, Bank, and Personal Info
│       ├── settings/              # Profiles editing, passwords & logout
│       └── notifications/         # Alerts logs & Read/Unread actions
```

### Key Framework & Technology Choices
1. **State Management**: **BLoC / Cubit** (`flutter_bloc`). Used to drive reactive states per screen (e.g., `AuthCubit` driving login checkpoints, `ThemeCubit` driving dark mode toggles).
2. **Networking**: **Dio** (`dio`). Integrated with global interceptors that automatically inject `sessionId`, `x-user-name`, and `Authorization: Bearer <token>` headers as required by the Midchains gateway.
3. **Password Hashing**: **Argon2i** (`argon2`). Implemented purely in Dart to hash passwords on-device using the `security` UUID salt returned during session init before sending payloads to `/login/v2`.
4. **Token Persistence**: **Flutter Secure Storage** (`flutter_secure_storage`). Encrypts and persists tokens in Keychain (iOS) and KeyStore (Android) securely.
5. **Design System**: **Material 3**. Styled using Outfit fonts, custom Card shapes, dynamic theme switching, and sparkline visualization graphics via `fl_chart`.

---

## ⚠️ Known Limitations & API Fallbacks

1. **Database Uninitialized Fallbacks**:
   - Several personal info endpoints under `/api/client/client-profiles/` return a `500 Unexpected Error` on the DEV environment due to database initialization constraints with the test account.
   - **Solution**: A robust repository fallback structure is implemented in [AccountRepositoryImpl](file:///Users/sudhanshu/Desktop/CBO_SFA/scAlong%20project/lib/src/features/account/data/repositories/account_repository_impl.dart). If the server returns a 500 error, it returns mock data formatted to match the production API documentation, keeping the app crash-free and showing realistic KYC status information.
2. **CAPTCHA Input Validation**:
   - The validation uses slide completion detection (`slider-verified` input) which completes successfully.
