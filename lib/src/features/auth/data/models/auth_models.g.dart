// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionResponse _$SessionResponseFromJson(Map<String, dynamic> json) =>
    SessionResponse(
      isValidSession: json['isValidSession'] as bool,
      security: json['security'] as String,
      sessionId: json['sessionId'] as String,
    );

Map<String, dynamic> _$SessionResponseToJson(SessionResponse instance) =>
    <String, dynamic>{
      'isValidSession': instance.isValidSession,
      'security': instance.security,
      'sessionId': instance.sessionId,
    };

CaptchaRequestResponse _$CaptchaRequestResponseFromJson(
  Map<String, dynamic> json,
) => CaptchaRequestResponse(
  captchaImage: json['captchaImage'] as String,
  message: json['message'] as String,
  captchaId: json['captchaId'] as String,
);

Map<String, dynamic> _$CaptchaRequestResponseToJson(
  CaptchaRequestResponse instance,
) => <String, dynamic>{
  'captchaImage': instance.captchaImage,
  'message': instance.message,
  'captchaId': instance.captchaId,
};

CaptchaValidateResponse _$CaptchaValidateResponseFromJson(
  Map<String, dynamic> json,
) => CaptchaValidateResponse(
  validated: json['validated'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$CaptchaValidateResponseToJson(
  CaptchaValidateResponse instance,
) => <String, dynamic>{
  'validated': instance.validated,
  'message': instance.message,
};

TwoFaCheckResponse _$TwoFaCheckResponseFromJson(Map<String, dynamic> json) =>
    TwoFaCheckResponse(
      twoFaEnabled: json['twoFaEnabled'] as bool,
      userId: (json['userId'] as num).toInt(),
      email: json['email'] as String,
    );

Map<String, dynamic> _$TwoFaCheckResponseToJson(TwoFaCheckResponse instance) =>
    <String, dynamic>{
      'twoFaEnabled': instance.twoFaEnabled,
      'userId': instance.userId,
      'email': instance.email,
    };

OtpOptionsResponse _$OtpOptionsResponseFromJson(Map<String, dynamic> json) =>
    OtpOptionsResponse(
      message: json['message'] as String,
      otpOptions: Map<String, String>.from(json['otp_options'] as Map),
    );

Map<String, dynamic> _$OtpOptionsResponseToJson(OtpOptionsResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'otp_options': instance.otpOptions,
    };

OtpSendResponse _$OtpSendResponseFromJson(Map<String, dynamic> json) =>
    OtpSendResponse(
      method: json['method'] as String,
      maskedAddress: json['maskedAddress'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$OtpSendResponseToJson(OtpSendResponse instance) =>
    <String, dynamic>{
      'method': instance.method,
      'maskedAddress': instance.maskedAddress,
      'message': instance.message,
    };

OtpValidateResponse _$OtpValidateResponseFromJson(Map<String, dynamic> json) =>
    OtpValidateResponse(
      validated: json['validated'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$OtpValidateResponseToJson(
  OtpValidateResponse instance,
) => <String, dynamic>{
  'validated': instance.validated,
  'message': instance.message,
};

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      sessionId: json['sessionId'] as String,
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };
