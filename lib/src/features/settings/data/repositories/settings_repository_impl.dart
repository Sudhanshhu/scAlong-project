import '../../domain/repositories/settings_repository.dart';
import '../models/settings_models.dart';
import 'package:midchains_customer_portal/src/core/network/dio_client.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final DioClient _client;

  SettingsRepositoryImpl({required DioClient client}) : _client = client;

  @override
  Future<TwoFaStatus> get2faStatus() async {
    final res = await _client.dio.get('/api/2fa/status');
    return TwoFaStatus.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<AppThemePreference> getTheme() async {
    final res = await _client.dio.get('/api/kyc/theme/get');
    final body = res.data as Map<String, dynamic>;
    return AppThemePreference.fromApi(body['theme']?.toString());
  }

  @override
  Future<void> setTheme(AppThemePreference theme) async {
    await _client.dio.post(
      '/api/kyc/theme/set',
      data: {'theme': theme.apiValue},
    );
  }
}
