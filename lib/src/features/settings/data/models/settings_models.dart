/// 2FA status from `GET /api/2fa/status`.
class TwoFaStatus {
  final bool enabled;
  final bool verified;
  final String? method;

  const TwoFaStatus({
    required this.enabled,
    required this.verified,
    this.method,
  });

  factory TwoFaStatus.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map?)?.cast<String, dynamic>() ?? json;
    return TwoFaStatus(
      enabled: data['enabled'] == true,
      verified: data['verified'] == true,
      method: data['method']?.toString(),
    );
  }
}

/// App theme preference from `GET/POST /api/kyc/theme`.
/// The backend only accepts the capitalised values "Light" and "Dark".
enum AppThemePreference {
  light,
  dark;

  String get apiValue => this == AppThemePreference.dark ? 'Dark' : 'Light';

  static AppThemePreference fromApi(String? value) =>
      (value ?? '').toLowerCase() == 'dark'
          ? AppThemePreference.dark
          : AppThemePreference.light;
}
