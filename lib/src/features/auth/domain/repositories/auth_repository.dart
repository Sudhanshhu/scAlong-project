import '../../data/models/auth_models.dart';

abstract class AuthRepository {
  Future<SessionResponse> initializeSession();
  
  Future<CaptchaRequestResponse> requestCaptcha({
    required String sessionId,
    required String email,
    required String password,
  });

  Future<CaptchaValidateResponse> validateCaptcha({
    required String sessionId,
    required String captchaId,
    required String captchaInput,
  });

  Future<TwoFaCheckResponse> check2Fa({
    required String sessionId,
    required String email,
  });

  Future<OtpOptionsResponse> requestOtpOptions({
    required String sessionId,
    required String email,
    required String method,
  });

  Future<OtpSendResponse> sendOtp({
    required String sessionId,
    required String email,
    required String deliveryMethod,
  });

  Future<OtpValidateResponse> validateOtp({
    required String sessionId,
    required String email,
    required String otpCode,
  });

  Future<LoginResponse> login({
    required String sessionId,
    required String email,
    required String password,
    required String securityToken,
  });

  Future<void> logout();

  Future<bool> isUserLoggedIn();
}
