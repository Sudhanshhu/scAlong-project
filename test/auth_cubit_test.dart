import 'package:flutter_test/flutter_test.dart';
import 'package:midchains_customer_portal/src/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:midchains_customer_portal/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:midchains_customer_portal/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:midchains_customer_portal/src/features/auth/data/models/auth_models.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<SessionResponse> initializeSession() async {
    return SessionResponse(
      isValidSession: true,
      security: 'security_uuid_123',
      sessionId: 'session_id_123',
    );
  }

  @override
  Future<CaptchaRequestResponse> requestCaptcha({
    required String sessionId,
    required String email,
    required String password,
  }) async {
    return CaptchaRequestResponse(
      captchaImage: 'base64_image_data',
      message: 'Success',
      captchaId: 'captcha_uuid_123',
    );
  }

  @override
  Future<CaptchaValidateResponse> validateCaptcha({
    required String sessionId,
    required String captchaId,
    required String captchaInput,
  }) async {
    return CaptchaValidateResponse(
      validated: true,
      message: 'Validated',
    );
  }

  @override
  Future<TwoFaCheckResponse> check2Fa({
    required String sessionId,
    required String email,
  }) async {
    return TwoFaCheckResponse(
      twoFaEnabled: true,
      userId: 42,
      email: email,
    );
  }

  @override
  Future<OtpOptionsResponse> requestOtpOptions({
    required String sessionId,
    required String email,
    required String method,
  }) async {
    return OtpOptionsResponse(
      message: 'Options sent',
      otpOptions: {'PHONE': '+971•••••••67', 'EMAIL': 'j••••••••1@gmail.com'},
    );
  }

  @override
  Future<OtpSendResponse> sendOtp({
    required String sessionId,
    required String email,
    required String deliveryMethod,
  }) async {
    return OtpSendResponse(
      method: deliveryMethod,
      maskedAddress: '+971•••••••67',
      message: 'Sent',
    );
  }

  @override
  Future<OtpValidateResponse> validateOtp({
    required String sessionId,
    required String email,
    required String otpCode,
  }) async {
    return OtpValidateResponse(
      validated: true,
      message: 'Validated',
    );
  }

  @override
  Future<LoginResponse> login({
    required String sessionId,
    required String email,
    required String password,
    required String securityToken,
  }) async {
    return LoginResponse(
      sessionId: sessionId,
      token: 'jwt_access_token_123',
      refreshToken: 'refresh_token_123',
    );
  }

  @override
  Future<void> logout() async {}

  @override
  Future<bool> isUserLoggedIn() async => false;
}

void main() {
  group('AuthCubit State Transition Tests', () {
    late FakeAuthRepository repository;
    late AuthCubit cubit;

    setUp(() {
      repository = FakeAuthRepository();
      cubit = AuthCubit(repository);
    });

    tearDown(() {
      cubit.close();
    });

    test('Initial state is AuthInitial', () {
      expect(cubit.state, equals(AuthInitial()));
    });

    test('startLoginFlow updates cubit state to AuthCaptchaRequired', () async {
      await cubit.startLoginFlow(
        email: 'joshi.sahil12+0312i_1@gmail.com',
        password: 'Test@123',
      );

      expect(
        cubit.state,
        equals(const AuthCaptchaRequired(
          sessionId: 'session_id_123',
          securityToken: 'security_uuid_123',
          captchaId: 'captcha_uuid_123',
          captchaImage: 'base64_image_data',
        )),
      );
    });
  });
}
