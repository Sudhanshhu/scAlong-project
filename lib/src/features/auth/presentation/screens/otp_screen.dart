import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import 'package:midchains_customer_portal/src/common/widgets/k_text.dart';
import 'package:midchains_customer_portal/src/common/widgets/k_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _pinControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _pinFocusNodes = List.generate(6, (_) => FocusNode());
  Timer? _timer;
  int _secondsRemaining = 60;
  String _selectedMethod = 'PHONE'; // default to PHONE

  @override
  void initState() {
    super.initState();
    // The parent cubit is already in AuthOtpOptionsReceived state or AuthOtpSent
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _pinControllers) {
      controller.dispose();
    }
    for (var node in _pinFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String _getPin() {
    return _pinControllers.map((c) => c.text).join();
  }

  void _resetPinFields() {
    for (var controller in _pinControllers) {
      controller.clear();
    }
    _pinFocusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('2FA Verification'),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthOtpSent) {
            _startTimer();
            _resetPinFields();
          } else if (state is AuthSuccess) {
            // Login successful! Route to dashboard
            context.go('/dashboard');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: KText(
                  state.message.replaceAll('Exception:', '').trim(),
                  color: Colors.white,
                ),
                backgroundColor: theme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final isSending = state is AuthOtpSending;
          final isValidating = state is AuthOtpValidating;
          final isLoading = state is AuthLoading;

          if (state is AuthOtpOptionsReceived) {
            final options = state.otpOptions;
            final emailAddr = options['email'] ?? 'Email';
            final mobileNum = options['mobile'] ?? 'Mobile';

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const KText(
                    'Select Verification Channel',
                    style: KTextStyle.displayMedium,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 12),
                  KText(
                    'Choose where you would like to receive your 6-digit verification code.',
                    style: KTextStyle.bodyMedium,
                    color: theme.colorScheme.onBackground.withOpacity(0.6),
                  ),
                  const SizedBox(height: 40),
                  
                  // Radio Option PHONE
                  Card(
                    child: RadioListTile<String>(
                      value: 'PHONE',
                      groupValue: _selectedMethod,
                      activeColor: theme.colorScheme.primary,
                      title: const KText('SMS / Mobile Phone', style: KTextStyle.titleMedium, fontWeight: FontWeight.bold),
                      subtitle: KText(mobileNum, style: KTextStyle.bodyMedium, color: theme.colorScheme.onBackground.withOpacity(0.5)),
                      onChanged: (val) {
                        setState(() {
                          _selectedMethod = val!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Radio Option EMAIL
                  Card(
                    child: RadioListTile<String>(
                      value: 'EMAIL',
                      groupValue: _selectedMethod,
                      activeColor: theme.colorScheme.primary,
                      title: const KText('Email Address', style: KTextStyle.titleMedium, fontWeight: FontWeight.bold),
                      subtitle: KText(emailAddr, style: KTextStyle.bodyMedium, color: theme.colorScheme.onBackground.withOpacity(0.5)),
                      onChanged: (val) {
                        setState(() {
                          _selectedMethod = val!;
                        });
                      },
                    ),
                  ),
                  const Spacer(),
                  
                  // Send OTP Button
                  KButton(
                    text: 'Receive OTP',
                    isLoading: isSending || isLoading,
                    onPressed: () {
                      context.read<AuthCubit>().sendOtpCode(deliveryMethod: _selectedMethod);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }

          if (state is AuthOtpSent || state is AuthOtpValidating || state is AuthFailure) {
            final dest = (state is AuthOtpSent) ? state.maskedDestination : '';

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const KText(
                    'Enter Security Code',
                    style: KTextStyle.displayMedium,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 12),
                  KText(
                    'We sent a 6-digit verification code to $dest. Enter it below to authorize this session.',
                    style: KTextStyle.bodyMedium,
                    color: theme.colorScheme.onBackground.withOpacity(0.6),
                  ),
                  const SizedBox(height: 48),

                  // PIN entry fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        height: 56,
                        width: 44,
                        child: TextFormField(
                          controller: _pinControllers[index],
                          focusNode: _pinFocusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: theme.colorScheme.outline.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: theme.colorScheme.primary,
                                width: 1.5,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              _pinFocusNodes[index + 1].requestFocus();
                            }
                            if (value.isEmpty && index > 0) {
                              _pinFocusNodes[index - 1].requestFocus();
                            }
                            // Auto trigger verification if last digit is typed
                            if (_getPin().length == 6) {
                              context.read<AuthCubit>().submitOtp(otpCode: _getPin());
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),

                  // Submit Button
                  KButton(
                    text: 'Verify Code',
                    isLoading: isValidating,
                    onPressed: _getPin().length == 6
                        ? () {
                            context.read<AuthCubit>().submitOtp(otpCode: _getPin());
                          }
                        : null,
                  ),
                  const SizedBox(height: 32),

                  // Countdown & Resend Option
                  Center(
                    child: Column(
                      children: [
                        if (_secondsRemaining > 0)
                          KText(
                            'Resend code in ${_secondsRemaining}s',
                            style: KTextStyle.bodyMedium,
                            color: theme.colorScheme.onBackground.withOpacity(0.5),
                          )
                        else
                          KButton(
                            text: 'Resend Verification Code',
                            type: KButtonType.text,
                            onPressed: () {
                              context.read<AuthCubit>().sendOtpCode(deliveryMethod: _selectedMethod);
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          // Fallback loader
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
