# Midchains Customer Portal - Flutter App

A modern, high-fidelity Flutter mobile application that integrates with the Midchains Customer Portal (`https://cp-dev.midchains.com`). This project features a complete secure login flow (session → CAPTCHA → OTP → Argon2 login), a dashboard that greets the authenticated user and lists linked wallets, a tabbed account/profile section with KYC status, a notifications view, a settings pane (real 2FA status + backend-synced theme), and dual dark/light Material 3 theming. All screens are bound to live REST endpoints; where the backend has no data (no wallet/bank/notifications on the test account), the UI shows proper empty states rather than mock data.

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
│       ├── auth/                  # Authentication module (Session, Captcha, OTP)
│       │   ├── data/              # Models & Repository implementations
│       │   ├── domain/            # Repository interfaces/contracts
│       │   └── presentation/      # BLoCs/Cubits, Screens & Subwidgets
│       ├── dashboard/             # User greeting + linked-wallet overview (data/domain/presentation)
│       ├── account/               # KYC status, banking & profile information (data/domain/presentation)
│       ├── settings/              # Real 2FA status, backend-synced theme & security controls (data/domain/presentation)
│       └── notifications/         # Notifications list with empty state (data/domain/presentation)
```

### Clean Architecture Layers

Each feature folder is strictly structured into three layers to isolate dependencies and enforce clean code boundaries:

1. **Presentation Layer (`presentation/`)**:
   - **Responsibility**: Rendering user interfaces and executing user interaction flows.
   - **Components**:
     - **UI Screens & Views**: Reusable layouts built with Material 3 styling.
     - **BLoCs / Cubits**: Emits distinct states (e.g. `Loading`, `Loaded`, `Error`) in response to actions and fetches data from repositories.
     - **Custom Widgets**: Domain-specific UI subcomponents (like sliders or PIN inputs).

2. **Domain Layer (`domain/`)**:
   - **Responsibility**: Encapsulating the core business rules and defining data boundaries. This layer is fully pure and free of external framework dependencies (like Dio or Flutter).
   - **Components**:
     - **Repository Interfaces**: Abstract classes defining the data-fetching contracts (e.g. `AuthRepository`, `AccountRepository`).

3. **Data Layer (`data/`)**:
   - **Responsibility**: Implementing repository contracts and handling networking and serialization.
   - **Components**:
     - **Repository Implementations**: Implements the abstract contracts defined in the domain layer. Handles Dio network calls, local file system reads/writes, secure token storage, and recovery logic.
     - **Data Models**: JSON-serializable DTOs (Data Transfer Objects) derived from raw payloads using automated code generators (`json_serializable`).

### Key Framework & Technology Choices
1. **State Management**: **BLoC / Cubit** (`flutter_bloc`). Used to drive reactive states per screen (e.g., `AuthCubit` driving login checkpoints, `ThemeCubit` driving dark mode toggles).
2. **Networking**: **Dio** (`dio`). Integrated with global interceptors that automatically inject `sessionId`, `x-user-name`, and `Authorization: Bearer <token>` headers as required by the Midchains gateway.
3. **Password Hashing**: **Argon2i** (`argon2`). Implemented purely in Dart to hash passwords on-device using the `security` UUID salt returned during session init before sending payloads to `/login/v2`.
4. **Token Persistence**: **Flutter Secure Storage** (`flutter_secure_storage`). Encrypts and persists tokens in Keychain (iOS) and KeyStore (Android) securely.
5. **Design System**: **Material 3**. Styled using Outfit fonts, custom Card shapes, and dynamic light/dark theme switching synced to the backend theme preference.

---

## ⚠️ Known Limitations & API Fallbacks

1. **Documented endpoint paths differ from the live gateway**:
   - The endpoint spec documents paths like `/api/client-profiles/personal-info` and `/api/dropdowns/countries`, but the live gateway serves them under an `/api/kyc/...` prefix (e.g. `/api/kyc/client-profiles/all`, `/api/kyc/dropdowns/countries`). Calling the documented paths returns a wrapped `500` ("No static resource ..."). The app uses the real working paths; profile/occupation/FATCA/documents are read in one call via `/api/kyc/client-profiles/all`.
   - Any genuine network error is propagated through the repositories to the cubit, and the UI shows a Material 3 error widget with the error detail and a **Retry** button.

2. **Endpoints with no data on the test account → empty states (no mock data)**:
   - `GET /api/clientBasicinfo/client/details` returns **404** when no bank is linked (documented behaviour) → "No Bank Linked" empty state.
   - `GET /api/kyc/client-profiles/wallet` returns an empty list → "No Wallet" empty state on the Dashboard and Account tabs.
   - There is **no portfolio/balance endpoint** and **no notifications-list endpoint** on the gateway, so the Dashboard wallet area and Notifications list render empty-state illustrations instead of fabricated values.
   - `GET /api/2fa/status` and `GET/POST /api/kyc/theme` are wired in Settings (real 2FA status display + backend-synced theme). `GET /api/client-profiles/image` and `GET /api/notifications/preferences` have no working gateway path and are not used.

3. **CAPTCHA Input Validation**:
   - The slider is a human-presence gesture; on completion the app sends the backend's expected `captchaInput: "slider-verified"` to `/captcha/validate/v2`. The dev gateway accepts this fixed token (it does not perform positional puzzle matching).
