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

class CaptchaData {
  final String captchaId;
  final String imageUrl;
  final String type;

  CaptchaData({
    required this.captchaId,
    required this.imageUrl,
    required this.type,
  });

  /// The live API returns a flat captcha object:
  ///   { "captchaImage": "data:image/png;base64,...",
  ///     "captchaId": "...", "message": "..." }
  /// (Older docs described a nested { success, data:{...} } shape.)
  factory CaptchaData.fromJson(Map<String, dynamic> json) => CaptchaData(
        captchaId: (json['captchaId'] ?? '') as String,
        imageUrl: (json['captchaImage'] ?? json['imageUrl'] ?? '') as String,
        type: (json['type'] ?? 'SLIDER') as String,
      );
}

class CaptchaRequestResponse {
  final bool success;
  final CaptchaData data;

  CaptchaRequestResponse({
    required this.success,
    required this.data,
  });

  factory CaptchaRequestResponse.fromJson(Map<String, dynamic> json) {
    // Tolerate both the flat live response and a wrapped { data: {...} } shape.
    final inner = json['data'] is Map
        ? (json['data'] as Map).cast<String, dynamic>()
        : json;
    return CaptchaRequestResponse(
      success: json['success'] == true || inner['captchaId'] != null,
      data: CaptchaData.fromJson(inner),
    );
  }
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
