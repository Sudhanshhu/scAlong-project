import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  /// Extracts the backend's human-readable message (e.g. "User not found")
  /// from a failed request instead of surfacing the raw DioException dump.
  String _friendlyError(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map) {
        final msg = data['error'] ?? data['message'];
        if (msg is String && msg.trim().isNotEmpty) return msg.trim();
      }
    }
    return 'Something went wrong. Please try again.';
  }

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

      // 2. Verify the account exists BEFORE showing the captcha slider.
      // The backend answers 2fa/check with 404 "User not found" for unknown
      // accounts, so we surface that on the login screen and never advance to
      // the Security Check page for an unauthenticated user.
      await _repository.check2Fa(
        sessionId: _sessionId!,
        email: email,
      );

      // 3. Account is valid → request the captcha challenge.
      final captchaRes = await _repository.requestCaptcha(
        sessionId: _sessionId!,
        email: email,
        password: password,
      );

      emit(AuthCaptchaRequired(
        sessionId: _sessionId!,
        securityToken: _securityToken!,
        captchaId: captchaRes.data.captchaId,
        captchaImage: captchaRes.data.imageUrl,
      ));
    } catch (e) {
      emit(AuthFailure(_friendlyError(e)));
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
        // The account was already verified before the captcha, so go straight
        // to fetching the OTP delivery options.
        await _requestOtpOptions();
      } else {
        emit(AuthFailure("Captcha validation failed", previousState: state));
      }
    } catch (e) {
      emit(AuthFailure(_friendlyError(e), previousState: state));
    }
  }

  // Step 3: Check 2FA
  Future<void> _check2Fa() async {
    if (_sessionId == null || _email == null) return;
    emit(AuthLoading());

    try {
      await _repository.check2Fa(
        sessionId: _sessionId!,
        email: _email!,
      );

      // We proceed to request OTP options
      await _requestOtpOptions();
    } catch (e) {
      emit(AuthFailure(_friendlyError(e)));
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
      emit(AuthFailure(_friendlyError(e)));
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
      emit(AuthFailure(_friendlyError(e)));
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
      emit(AuthFailure(_friendlyError(e), previousState: state));
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
      emit(AuthFailure(_friendlyError(e)));
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
