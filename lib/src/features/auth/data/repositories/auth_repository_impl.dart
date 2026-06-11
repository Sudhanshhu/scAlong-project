import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_models.dart';
import 'package:midchains_customer_portal/src/core/network/dio_client.dart';
import 'package:midchains_customer_portal/src/core/storage/secure_storage_service.dart';
import 'package:argon2/argon2.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DioClient _client;
  final SecureStorageService _storage;

  AuthRepositoryImpl({
    required DioClient client,
    required SecureStorageService storage,
  })  : _client = client,
        _storage = storage;

  String _getArgon2Hash(String password, String saltStr) {
    final saltBytes = utf8.encode(saltStr);
    final passwordBytes = utf8.encode(password);
    
    final parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_i,
      Uint8List.fromList(saltBytes),
      iterations: 1,
      memory: 19456,
      lanes: 1,
      version: Argon2Parameters.ARGON2_VERSION_13,
    );
    
    final generator = Argon2BytesGenerator();
    generator.init(parameters);
    
    final result = Uint8List(32);
    generator.generateBytes(passwordBytes, result, 0, result.length);
    
    final saltBase64 = base64.encode(saltBytes).replaceAll('=', '');
    final hashBase64 = base64.encode(result).replaceAll('=', '');
    
    return '\$argon2i\$v=19\$m=19456,t=1,p=1\$$saltBase64\$$hashBase64';
  }

  @override
  Future<SessionResponse> initializeSession() async {
    final response = await _client.dio.get('/api/client/auth/session');
    return SessionResponse.fromJson(response.data);
  }

  @override
  Future<CaptchaRequestResponse> requestCaptcha({
    required String sessionId,
    required String email,
    required String password,
  }) async {
    final response = await _client.dio.post(
      '/api/client/auth/login/captcha/request/v2',
      data: {
        'email': email,
        'password': password,
      },
      options: Options(headers: {'sessionId': sessionId}),
    );
    return CaptchaRequestResponse.fromJson(response.data);
  }

  @override
  Future<CaptchaValidateResponse> validateCaptcha({
    required String sessionId,
    required String captchaId,
    required String captchaInput,
  }) async {
    final response = await _client.dio.post(
      '/api/client/auth/login/captcha/validate/v2',
      data: {
        'captchaId': captchaId,
        'captchaInput': captchaInput,
      },
      options: Options(headers: {'sessionId': sessionId}),
    );
    return CaptchaValidateResponse.fromJson(response.data);
  }

  @override
  Future<TwoFaCheckResponse> check2Fa({
    required String sessionId,
    required String email,
  }) async {
    final response = await _client.dio.post(
      '/api/client/auth/2fa/check',
      data: {
        'email': email,
      },
      options: Options(headers: {
        'sessionId': sessionId,
        'x-user-name': email,
      }),
    );
    return TwoFaCheckResponse.fromJson(response.data);
  }

  @override
  Future<OtpOptionsResponse> requestOtpOptions({
    required String sessionId,
    required String email,
    required String method,
  }) async {
    final response = await _client.dio.post(
      '/api/client/auth/login/otp/request/v2',
      data: {
        'email': email,
        'method': method,
      },
      options: Options(headers: {
        'sessionId': sessionId,
        'x-user-name': email,
      }),
    );
    return OtpOptionsResponse.fromJson(response.data);
  }

  @override
  Future<OtpSendResponse> sendOtp({
    required String sessionId,
    required String email,
    required String deliveryMethod,
  }) async {
    final response = await _client.dio.post(
      '/api/client/auth/login/otp/send/v2',
      data: {
        'method': deliveryMethod == 'PHONE' ? 'mobile' : 'email',
      },
      options: Options(headers: {
        'sessionId': sessionId,
        'x-user-name': email,
      }),
    );
    return OtpSendResponse.fromJson(response.data);
  }

  @override
  Future<OtpValidateResponse> validateOtp({
    required String sessionId,
    required String email,
    required String otpCode,
  }) async {
    final response = await _client.dio.post(
      '/api/client/auth/login/otp/validate/v2',
      data: {
        'otp': otpCode,
      },
      options: Options(headers: {
        'sessionId': sessionId,
        'x-user-name': email,
      }),
    );
    return OtpValidateResponse.fromJson(response.data);
  }

  @override
  Future<LoginResponse> login({
    required String sessionId,
    required String email,
    required String password,
    required String securityToken,
  }) async {
    final hashedPwd = _getArgon2Hash(password, securityToken);
    final usernameB64 = base64.encode(utf8.encode(email)).replaceAll('=', '');
    
    final response = await _client.dio.post(
      '/api/client/auth/login/v2',
      data: {
        'username': usernameB64,
        'password': hashedPwd,
      },
      options: Options(headers: {
        'sessionId': sessionId,
        'x-user-name': email,
      }),
    );
    
    final loginRes = LoginResponse.fromJson(response.data);
    
    // Save tokens and session ID upon successful login
    await _storage.saveTokens(
      accessToken: loginRes.token,
      refreshToken: loginRes.refreshToken,
      sessionId: loginRes.sessionId,
      userName: email,
    );
    
    return loginRes;
  }

  @override
  Future<void> logout() async {
    await _storage.clearAll();
  }

  @override
  Future<bool> isUserLoggedIn() async {
    return await _storage.hasValidSession();
  }
}
