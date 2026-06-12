import '../../data/models/settings_models.dart';

abstract class SettingsRepository {
  /// GET /api/2fa/status
  Future<TwoFaStatus> get2faStatus();

  /// GET /api/kyc/theme/get
  Future<AppThemePreference> getTheme();

  /// POST /api/kyc/theme/set
  Future<void> setTheme(AppThemePreference theme);
}
