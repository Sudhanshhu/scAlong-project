import 'package:dio/dio.dart';
import 'dart:io';
import '../storage/secure_storage_service.dart';

class DioClient {
  final Dio dio;
  final SecureStorageService _storage;

  DioClient({required SecureStorageService secureStorageService, Dio? dio})
      : _storage = secureStorageService,
        dio = dio ?? Dio() {
    this.dio.options.baseUrl = 'https://clientapigateway-dev.midchains.com';
    this.dio.options.connectTimeout = const Duration(seconds: 15);
    this.dio.options.receiveTimeout = const Duration(seconds: 15);
    this.dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    this.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await _storage.getAccessToken();
          final sessionId = await _storage.getSessionId();
          final userName = await _storage.getUserName();

          // Do not overwrite existing headers if they are explicitly set
          if (accessToken != null && !options.headers.containsKey('Authorization')) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          if (sessionId != null && !options.headers.containsKey('sessionId')) {
            options.headers['sessionId'] = sessionId;
          }
          if (userName != null && !options.headers.containsKey('x-user-name')) {
            options.headers['x-user-name'] = userName;
          }

          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          // If 401 Unauthorized received, try to refresh token and retry
          if (error.response?.statusCode == 401) {
            final refreshToken = await _storage.getRefreshToken();
            final accessToken = await _storage.getAccessToken();
            final sessionId = await _storage.getSessionId();
            final userName = await _storage.getUserName();

            if (refreshToken != null && accessToken != null && sessionId != null) {
              try {
                // Obtain a fresh client to avoid request loop on refresh endpoint
                final refreshDio = Dio(BaseOptions(
                  baseUrl: 'https://clientapigateway-dev.midchains.com',
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer $accessToken',
                    'sessionId': sessionId,
                  },
                ));

                final response = await refreshDio.post(
                  '/api/client/auth/refresh-token',
                  data: {'refreshToken': refreshToken},
                );

                if (response.statusCode == 200) {
                  final resBody = response.data;
                  // Handle both nested 'data' and flat JSON schemas defensively
                  final data = resBody['data'] ?? resBody['Data'] ?? resBody;
                  final newAccess = data['accessToken'] ?? data['token'];
                  final newRefresh = data['refreshToken'];

                  if (newAccess != null && newRefresh != null) {
                    await _storage.saveTokens(
                      accessToken: newAccess,
                      refreshToken: newRefresh,
                      sessionId: sessionId,
                      userName: userName,
                    );

                    // Clone the original request and retry with updated token
                    final requestOptions = error.requestOptions;
                    requestOptions.headers['Authorization'] = 'Bearer $newAccess';
                    requestOptions.headers['sessionId'] = sessionId;
                    
                    final retryResponse = await refreshDio.request(
                      requestOptions.path,
                      data: requestOptions.data,
                      queryParameters: requestOptions.queryParameters,
                      options: Options(
                        method: requestOptions.method,
                        headers: requestOptions.headers,
                      ),
                    );
                    return handler.resolve(retryResponse);
                  }
                }
              } catch (e) {
                // If token refresh fails, clear storage and bubble up the error
                await _storage.clearAll();
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }
}
