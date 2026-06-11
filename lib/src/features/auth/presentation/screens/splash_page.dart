import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:midchains_customer_portal/src/core/storage/secure_storage_service.dart';
import 'package:midchains_customer_portal/src/common/widgets/k_text.dart';
import 'package:midchains_customer_portal/src/core/theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOutBack),
    );

    _animationController.repeat(reverse: true);
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Wait for animation to settle
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final storage = context.read<SecureStorageService>();
    final hasSession = await storage.hasValidSession();

    if (hasSession) {
      context.go('/dashboard');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.15),
              theme.scaffoldBackgroundColor,
            ],
            radius: 1.2,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 50,
                      color: AppTheme.primaryEmerald,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const KText(
                'MIDCHAINS',
                style: KTextStyle.displayMedium,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 8),
              KText(
                'Customer Portal',
                style: KTextStyle.bodyMedium,
                color: theme.colorScheme.onBackground.withOpacity(0.5),
              ),
              const SizedBox(height: 48),
              SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
extension on KText {
  // Utility support helper for letter spacing in code template
  Widget get spacing => this;
}
