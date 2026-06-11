import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

@JsonSerializable()
class SessionResponse {
  final bool isValidSession;
  final String security;
  final String sessionId;

  SessionResponse({
    required this.isValidSession,
    required this.security,
    required this.sessionId,
  });

  factory SessionResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SessionResponseToJson(this);
}

@JsonSerializable()
class CaptchaRequestResponse {
  final String captchaImage;
  final String message;
  final String captchaId;

  CaptchaRequestResponse({
    required this.captchaImage,
    required this.message,
    required this.captchaId,
  });

  factory CaptchaRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$CaptchaRequestResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CaptchaRequestResponseToJson(this);
}

@JsonSerializable()
class CaptchaValidateResponse {
  final bool validated;
  final String message;

  CaptchaValidateResponse({
    required this.validated,
    required this.message,
  });

  factory CaptchaValidateResponse.fromJson(Map<String, dynamic> json) =>
      _$CaptchaValidateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CaptchaValidateResponseToJson(this);
}

@JsonSerializable()
class TwoFaCheckResponse {
  final bool twoFaEnabled;
  final int userId;
  final String email;

  TwoFaCheckResponse({
    required this.twoFaEnabled,
    required this.userId,
    required this.email,
  });

  factory TwoFaCheckResponse.fromJson(Map<String, dynamic> json) =>
      _$TwoFaCheckResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TwoFaCheckResponseToJson(this);
}

@JsonSerializable()
class OtpOptionsResponse {
  final String message;
  @JsonKey(name: 'otp_options')
  final Map<String, String> otpOptions;

  OtpOptionsResponse({
    required this.message,
    required this.otpOptions,
  });

  factory OtpOptionsResponse.fromJson(Map<String, dynamic> json) =>
      _$OtpOptionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OtpOptionsResponseToJson(this);
}

@JsonSerializable()
class OtpSendResponse {
  final String method;
  final String maskedAddress;
  final String message;

  OtpSendResponse({
    required this.method,
    required this.maskedAddress,
    required this.message,
  });

  factory OtpSendResponse.fromJson(Map<String, dynamic> json) =>
      _$OtpSendResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OtpSendResponseToJson(this);
}

@JsonSerializable()
class OtpValidateResponse {
  final bool validated;
  final String message;

  OtpValidateResponse({
    required this.validated,
    required this.message,
  });

  factory OtpValidateResponse.fromJson(Map<String, dynamic> json) =>
      _$OtpValidateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OtpValidateResponseToJson(this);
}

@JsonSerializable()
class LoginResponse {
  final String sessionId;
  final String token;
  final String refreshToken;

  LoginResponse({
    required this.sessionId,
    required this.token,
    required this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
