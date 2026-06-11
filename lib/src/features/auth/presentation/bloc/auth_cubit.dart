import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  // Local variables to preserve state across actions
  String? _sessionId;
  String? _securityToken;
  String? _email;
  String? _password;

  AuthCubit(this._repository) : super(AuthInitial());

  // Step 1: Initialize session and request captcha
  Future<void> startLoginFlow({required String email, required String password}) async {
    _email = email;
    _password = password;
    emit(AuthLoading());

    try {
      // 1. Get session info
      final sessionRes = await _repository.initializeSession();
      _sessionId = sessionRes.sessionId;
      _securityToken = sessionRes.security;

      // 2. Request Captcha
      final captchaRes = await _repository.requestCaptcha(
        sessionId: _sessionId!,
        email: email,
        password: password,
      );

      emit(AuthCaptchaRequired(
        sessionId: _sessionId!,
        securityToken: _securityToken!,
        captchaId: captchaRes.captchaId,
        captchaImage: captchaRes.captchaImage,
      ));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // Hook to restore session state on the OTP screen and trigger OTP options fetch
  Future<void> initializeOtpFlow({
    required String sessionId,
    required String email,
    required String securityToken,
  }) async {
    _sessionId = sessionId;
    _email = email;
    _securityToken = securityToken;
    emit(AuthLoading());
    await _check2Fa();
  }

  // Step 2: Validate captcha slider
  Future<void> submitCaptcha({required String captchaId, required String captchaInput}) async {
    if (_sessionId == null || _securityToken == null) return;
    emit(AuthCaptchaValidating());

    try {
      final validateRes = await _repository.validateCaptcha(
        sessionId: _sessionId!,
        captchaId: captchaId,
        captchaInput: captchaInput,
      );

      if (validateRes.validated) {
        emit(AuthCaptchaValidated(
          sessionId: _sessionId!,
          securityToken: _securityToken!,
        ));
        // Proceed to 2FA Check automatically
        await _check2Fa();
      } else {
        emit(AuthFailure("Captcha validation failed", previousState: state));
      }
    } catch (e) {
      emit(AuthFailure(e.toString(), previousState: state));
    }
  }

  // Step 3: Check 2FA
  Future<void> _check2Fa() async {
    if (_sessionId == null || _email == null) return;
    emit(AuthLoading());

    try {
      final twoFaRes = await _repository.check2Fa(
        sessionId: _sessionId!,
        email: _email!,
      );

      // We proceed to request OTP options
      await _requestOtpOptions();
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // Step 4: Get OTP Options
  Future<void> _requestOtpOptions() async {
    if (_sessionId == null || _email == null || _securityToken == null) return;

    try {
      final otpOptionsRes = await _repository.requestOtpOptions(
        sessionId: _sessionId!,
        email: _email!,
        method: "PHONE",
      );

      emit(AuthOtpOptionsReceived(
        sessionId: _sessionId!,
        securityToken: _securityToken!,
        otpOptions: Map<String, String>.from(otpOptionsRes.otpOptions),
      ));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // Step 5: Send OTP
  Future<void> sendOtpCode({required String deliveryMethod}) async {
    if (_sessionId == null || _email == null || _securityToken == null) return;
    emit(AuthOtpSending());

    try {
      final sendRes = await _repository.sendOtp(
        sessionId: _sessionId!,
        email: _email!,
        deliveryMethod: deliveryMethod,
      );

      emit(AuthOtpSent(
        sessionId: _sessionId!,
        securityToken: _securityToken!,
        maskedDestination: sendRes.maskedAddress,
      ));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // Step 6: Validate OTP
  Future<void> submitOtp({required String otpCode}) async {
    if (_sessionId == null || _email == null || _securityToken == null) return;
    emit(AuthOtpValidating());

    try {
      final validateRes = await _repository.validateOtp(
        sessionId: _sessionId!,
        email: _email!,
        otpCode: otpCode,
      );

      if (validateRes.validated) {
        emit(AuthOtpValidated(
          sessionId: _sessionId!,
          securityToken: _securityToken!,
        ));
        // Proceed to final login automatically
        await _submitLogin();
      } else {
        emit(AuthFailure("Invalid OTP code", previousState: state));
      }
    } catch (e) {
      emit(AuthFailure(e.toString(), previousState: state));
    }
  }

  // Step 7: Finalize Login
  Future<void> _submitLogin() async {
    if (_sessionId == null || _email == null || _password == null || _securityToken == null) return;
    emit(AuthLoading());

    try {
      final loginRes = await _repository.login(
        sessionId: _sessionId!,
        email: _email!,
        password: _password!,
        securityToken: _securityToken!,
      );

      emit(AuthSuccess(loginRes));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // Reset to initial state
  void reset() {
    _sessionId = null;
    _securityToken = null;
    _email = null;
    _password = null;
    emit(AuthInitial());
  }
}
