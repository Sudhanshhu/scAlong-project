import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/splash_page.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/captcha_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/captcha',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final cubit = extra['cubit'] as AuthCubit;
        final captchaId = extra['captchaId'] as String;
        final captchaImage = extra['captchaImage'] as String;
        return BlocProvider.value(
          value: cubit,
          child: CaptchaScreen(
            captchaId: captchaId,
            captchaImage: captchaImage,
          ),
        );
      },
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final cubit = extra['cubit'] as AuthCubit;
        return BlocProvider.value(
          value: cubit,
          child: const OtpScreen(),
        );
      },
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('No route defined for ${state.uri.path}'),
    ),
  ),
);
