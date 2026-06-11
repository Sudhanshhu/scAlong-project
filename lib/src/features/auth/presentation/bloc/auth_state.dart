import 'package:equatable/equatable.dart';
import '../../data/models/auth_models.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSessionInitialized extends AuthState {
  final String sessionId;
  final String securityToken;

  const AuthSessionInitialized({
    required this.sessionId,
    required this.securityToken,
  });

  @override
  List<Object?> get props => [sessionId, securityToken];
}

class AuthCaptchaRequired extends AuthState {
  final String sessionId;
  final String securityToken;
  final String captchaId;
  final String captchaImage;

  const AuthCaptchaRequired({
    required this.sessionId,
    required this.securityToken,
    required this.captchaId,
    required this.captchaImage,
  });

  @override
  List<Object?> get props => [sessionId, securityToken, captchaId, captchaImage];
}

class AuthCaptchaValidating extends AuthState {}

class AuthCaptchaValidated extends AuthState {
  final String sessionId;
  final String securityToken;

  const AuthCaptchaValidated({
    required this.sessionId,
    required this.securityToken,
  });

  @override
  List<Object?> get props => [sessionId, securityToken];
}

class AuthOtpOptionsReceived extends AuthState {
  final String sessionId;
  final String securityToken;
  final Map<String, String> otpOptions;

  const AuthOtpOptionsReceived({
    required this.sessionId,
    required this.securityToken,
    required this.otpOptions,
  });

  @override
  List<Object?> get props => [sessionId, securityToken, otpOptions];
}

class AuthOtpSending extends AuthState {}

class AuthOtpSent extends AuthState {
  final String sessionId;
  final String securityToken;
  final String maskedDestination;

  const AuthOtpSent({
    required this.sessionId,
    required this.securityToken,
    required this.maskedDestination,
  });

  @override
  List<Object?> get props => [sessionId, securityToken, maskedDestination];
}

class AuthOtpValidating extends AuthState {}

class AuthOtpValidated extends AuthState {
  final String sessionId;
  final String securityToken;

  const AuthOtpValidated({
    required this.sessionId,
    required this.securityToken,
  });

  @override
  List<Object?> get props => [sessionId, securityToken];
}

class AuthSuccess extends AuthState {
  final LoginResponse loginResponse;

  const AuthSuccess(this.loginResponse);

  @override
  List<Object?> get props => [loginResponse];
}

class AuthFailure extends AuthState {
  final String message;
  final AuthState? previousState;

  const AuthFailure(this.message, {this.previousState});

  @override
  List<Object?> get props => [message, previousState];
}
