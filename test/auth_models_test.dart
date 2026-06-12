import 'package:flutter_test/flutter_test.dart';
import 'package:midchains_customer_portal/src/features/auth/data/models/auth_models.dart';

void main() {
  group('Auth Models Deserialization Tests', () {
    
    group('SessionResponse', () {
      test('parses exact flat structure from server', () {
        final json = {
          'isValidSession': true,
          'security': 'sec-123',
          'sessionId': 'sess-123',
        };
        final res = SessionResponse.fromJson(json);
        expect(res.isValidSession, true);
        expect(res.security, 'sec-123');
        expect(res.sessionId, 'sess-123');
      });
    });

    group('CaptchaRequestResponse', () {
      // The live gateway returns a FLAT object (no `success`/`data` wrapper):
      //   { "captchaImage": "data:image/png;base64,...",
      //     "captchaId": "...", "message": "Internal CAPTCHA generated" }
      test('parses the real flat structure from the live server', () {
        final json = {
          'captchaImage': 'data:image/png;base64,iVBORw0KGgoAAAANS...',
          'captchaId': '3b2a8d-1234',
          'message': 'Internal CAPTCHA generated',
        };
        final res = CaptchaRequestResponse.fromJson(json);
        expect(res.success, true); // presence of captchaId implies success
        expect(res.data.captchaId, '3b2a8d-1234');
        expect(res.data.imageUrl, 'data:image/png;base64,iVBORw0KGgoAAAANS...');
        expect(res.data.type, 'SLIDER'); // defaulted when absent
      });

      test('also tolerates a wrapped { data: {...} } structure', () {
        final json = {
          'success': true,
          'data': {
            'captchaId': '3b2a8d-1234',
            'captchaImage': 'data:image/png;base64,iVBORw0KGgoAAAANS...',
          }
        };
        final res = CaptchaRequestResponse.fromJson(json);
        expect(res.success, true);
        expect(res.data.captchaId, '3b2a8d-1234');
        expect(res.data.imageUrl, 'data:image/png;base64,iVBORw0KGgoAAAANS...');
      });
    });

    group('CaptchaValidateResponse', () {
      test('parses exact flat structure from server', () {
        final json = {
          'validated': true,
          'message': 'CAPTCHA validated successfully',
        };
        final res = CaptchaValidateResponse.fromJson(json);
        expect(res.validated, true);
        expect(res.message, 'CAPTCHA validated successfully');
      });
    });

    group('TwoFaCheckResponse', () {
      test('parses exact flat structure from server', () {
        final json = {
          'twoFaEnabled': false,
          'userId': 245,
          'email': 'ravindra_hcode@midchains.com',
        };
        final res = TwoFaCheckResponse.fromJson(json);
        expect(res.twoFaEnabled, false);
        expect(res.userId, 245);
        expect(res.email, 'ravindra_hcode@midchains.com');
      });
    });

    group('OtpOptionsResponse', () {
      test('parses exact flat structure from server', () {
        final json = {
          'message': 'Select where to receive OTP',
          'otp_options': {
            'mobile': '+********0508',
            'email': 'ravindra_hcode@midchains.com'
          }
        };
        final res = OtpOptionsResponse.fromJson(json);
        expect(res.message, 'Select where to receive OTP');
        expect(res.otpOptions['mobile'], '+********0508');
        expect(res.otpOptions['email'], 'ravindra_hcode@midchains.com');
      });
    });

    group('OtpSendResponse', () {
      test('parses exact flat structure from server', () {
        final json = {
          'method': 'mobile',
          'maskedAddress': '+********0508',
          'message': 'OTP sent successfully'
        };
        final res = OtpSendResponse.fromJson(json);
        expect(res.method, 'mobile');
        expect(res.maskedAddress, '+********0508');
        expect(res.message, 'OTP sent successfully');
      });
    });

    group('OtpValidateResponse', () {
      test('parses exact flat structure from server', () {
        final json = {
          'validated': true,
          'message': 'OTP validated successfully'
        };
        final res = OtpValidateResponse.fromJson(json);
        expect(res.validated, true);
        expect(res.message, 'OTP validated successfully');
      });
    });

    group('LoginResponse', () {
      test('parses exact flat structure from server', () {
        final json = {
          'sessionId': '88b78d68-1847-43cf-b5a5-d35abbbc7074',
          'token': 'jwt_token_data',
          'refreshToken': 'refresh_token_data'
        };
        final res = LoginResponse.fromJson(json);
        expect(res.sessionId, '88b78d68-1847-43cf-b5a5-d35abbbc7074');
        expect(res.token, 'jwt_token_data');
        expect(res.refreshToken, 'refresh_token_data');
      });
    });

  });
}
