import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keySessionId = 'session_id';
  static const String _keyUserName = 'user_name';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String sessionId,
    String? userName,
  }) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
    await _storage.write(key: _keySessionId, value: sessionId);
    if (userName != null) {
      await _storage.write(key: _keyUserName, value: userName);
    }
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  Future<String?> getSessionId() async {
    return await _storage.read(key: _keySessionId);
  }

  Future<String?> getUserName() async {
    return await _storage.read(key: _keyUserName);
  }

  Future<void> clearAll() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keySessionId);
    await _storage.delete(key: _keyUserName);
  }

  Future<bool> hasValidSession() async {
    final token = await getAccessToken();
    final session = await getSessionId();
    return token != null && session != null;
  }
}
