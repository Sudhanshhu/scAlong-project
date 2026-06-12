import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/repositories/auth_repository.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import 'package:midchains_customer_portal/src/common/widgets/k_text.dart';
import 'package:midchains_customer_portal/src/common/widgets/k_text_field.dart';
import 'package:midchains_customer_portal/src/common/widgets/k_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email address is required';
    }
    final emailRegExp = RegExp(r'^[\w\.\-\+]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => AuthCubit(context.read<AuthRepository>()),
      child: Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthCaptchaRequired) {
              // Navigate to Captcha validation screen
              context.push(
                '/captcha',
                extra: {
                  'cubit': context.read<AuthCubit>(),
                  'captchaId': state.captchaId,
                  'captchaImage': state.captchaImage,
                },
              ).then((result) {
                if (!context.mounted) return;
                // If captcha validate was successful, it auto-advances to OTP
                if (result == true) {
                  context.push('/otp', extra: {
                    'cubit': context.read<AuthCubit>(),
                  });
                } else {
                  context.read<AuthCubit>().reset();
                }
              });
            } else if (state is AuthFailure) {
              // The captcha/OTP screens own their own error toasts while they
              // are on top; only show here when login is the active route.
              final isLoginOnTop = ModalRoute.of(context)?.isCurrent ?? true;
              if (isLoginOnTop) {
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
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      // Header Brand
                      Center(
                        child: Column(
                          children: [
                            Container(
                              height: 64,
                              width: 64,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 36,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const KText(
                              'Midchains Customer Portal',
                              style: KTextStyle.titleLarge,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 8),
                            KText(
                              'Securely trade and manage your assets',
                              style: KTextStyle.bodyMedium,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                      const KText(
                        'Welcome Back',
                        style: KTextStyle.displayMedium,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 8),
                      KText(
                        'Enter your credentials to login to your dashboard',
                        style: KTextStyle.bodyMedium,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(height: 32),
                      
                      // Email Field
                      KTextField(
                        controller: _emailController,
                        labelText: 'Email Address',
                        hintText: 'name@example.com',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 20),
                      
                      // Password Field
                      KTextField(
                        controller: _passwordController,
                        labelText: 'Password',
                        hintText: '••••••••',
                        isPassword: true,
                        prefixIcon: Icons.lock_outline_rounded,
                        validator: _validatePassword,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 32),
                      
                      // Continue Button
                      KButton(
                        text: 'Continue',
                        isLoading: isLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().startLoginFlow(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
