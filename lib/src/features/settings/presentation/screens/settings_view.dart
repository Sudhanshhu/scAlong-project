import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:midchains_customer_portal/src/core/di/service_locator.dart';
import 'package:midchains_customer_portal/src/core/theme/theme_cubit.dart';
import 'package:midchains_customer_portal/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:midchains_customer_portal/src/features/account/presentation/bloc/account_cubit.dart';
import 'package:midchains_customer_portal/src/features/account/presentation/bloc/account_state.dart';
import 'package:midchains_customer_portal/src/features/settings/data/models/settings_models.dart';
import 'package:midchains_customer_portal/src/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:midchains_customer_portal/src/features/settings/presentation/bloc/settings_state.dart';
import 'package:midchains_customer_portal/src/common/widgets/k_text.dart';
import 'package:midchains_customer_portal/src/common/widgets/k_text_field.dart';
import 'package:midchains_customer_portal/src/common/widgets/k_button.dart';
import 'package:midchains_customer_portal/src/core/theme/app_theme.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;

  void _showEditProfileDialog(BuildContext context, String currentFirst, String currentLast, String currentPhone) {
    final firstController = TextEditingController(text: currentFirst);
    final lastController = TextEditingController(text: currentLast);
    final phoneController = TextEditingController(text: currentPhone);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const KText('Edit Profile', style: KTextStyle.titleLarge, fontWeight: FontWeight.bold),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  KTextField(
                    controller: firstController,
                    labelText: 'First Name',
                    validator: (val) => val == null || val.isEmpty ? 'First name required' : null,
                  ),
                  const SizedBox(height: 16),
                  KTextField(
                    controller: lastController,
                    labelText: 'Last Name',
                    validator: (val) => val == null || val.isEmpty ? 'Last name required' : null,
                  ),
                  const SizedBox(height: 16),
                  KTextField(
                    controller: phoneController,
                    labelText: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    validator: (val) => val == null || val.isEmpty ? 'Phone required' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryEmerald,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.read<AccountCubit>().updateProfile(
                        firstName: firstController.text.trim(),
                        lastName: lastController.text.trim(),
                        phone: phoneController.text.trim(),
                      );
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated successfully')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const KText('Change Password', style: KTextStyle.titleLarge, fontWeight: FontWeight.bold),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  KTextField(
                    controller: currentPasswordController,
                    labelText: 'Current Password',
                    isPassword: true,
                    validator: (val) => val == null || val.isEmpty ? 'Current password required' : null,
                  ),
                  const SizedBox(height: 16),
                  KTextField(
                    controller: newPasswordController,
                    labelText: 'New Password',
                    isPassword: true,
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'New password required';
                      if (val.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryEmerald,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final messenger = ScaffoldMessenger.of(context);
                  final success = await context.read<AccountCubit>().changePassword(
                        currentPassword: currentPasswordController.text,
                        newPassword: newPasswordController.text,
                      );
                  if (!dialogContext.mounted) return;
                  Navigator.pop(dialogContext);
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        success ? 'Password updated successfully' : 'Failed to update password',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = BlocProvider.of<ThemeCubit>(context).state == ThemeMode.dark;
    final settingsState = context.watch<SettingsCubit>().state;
    final twoFa =
        settingsState is SettingsLoaded ? settingsState.twoFaStatus : null;

    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (prev, curr) => curr is SettingsLoaded,
      listener: (context, sState) {
        // Reflect the backend theme preference in the app on first load.
        if (sState is SettingsLoaded) {
          final desired = sState.theme == AppThemePreference.dark
              ? ThemeMode.dark
              : ThemeMode.light;
          if (context.read<ThemeCubit>().state != desired) {
            context.read<ThemeCubit>().setThemeMode(desired);
          }
        }
      },
      child: BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        final profileLoaded = state is AccountLoaded;
        final firstName = profileLoaded ? state.personalInfo.firstName : '';
        final lastName = profileLoaded ? state.personalInfo.lastName : '';
        final phone = profileLoaded ? state.personalInfo.phone : '';

        return Scaffold(
          appBar: AppBar(
            title: const KText('Settings', style: KTextStyle.titleLarge, fontWeight: FontWeight.bold),
          ),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Theme settings card
              const KText('Appearance', style: KTextStyle.titleMedium, fontWeight: FontWeight.bold),
              const SizedBox(height: 12),
              Card(
                child: SwitchListTile(
                  title: const KText('Dark Theme', style: KTextStyle.bodyLarge, fontWeight: FontWeight.bold),
                  subtitle: const KText('Switch app style to dark mode', style: KTextStyle.bodyMedium),
                  value: isDark,
                  activeThumbColor: theme.colorScheme.primary,
                  onChanged: (value) {
                    context.read<ThemeCubit>().setThemeMode(
                        value ? ThemeMode.dark : ThemeMode.light);
                    // Persist the preference to the backend (POST /api/kyc/theme/set).
                    context.read<SettingsCubit>().updateTheme(value
                        ? AppThemePreference.dark
                        : AppThemePreference.light);
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Profile / Account settings
              const KText('Profile & Security', style: KTextStyle.titleMedium, fontWeight: FontWeight.bold),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const KText('Edit Profile Info', style: KTextStyle.bodyLarge, fontWeight: FontWeight.bold),
                      subtitle: const KText('Change first name, last name, phone number', style: KTextStyle.bodyMedium),
                      trailing: const Icon(Icons.chevron_right),
                      enabled: profileLoaded,
                      onTap: () => _showEditProfileDialog(context, firstName, lastName, phone),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.lock_outline_rounded),
                      title: const KText('Change Password', style: KTextStyle.bodyLarge, fontWeight: FontWeight.bold),
                      subtitle: const KText('Change your dashboard access password', style: KTextStyle.bodyMedium),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showChangePasswordDialog(context),
                    ),
                    const Divider(height: 1),
                    // Real 2FA status (GET /api/2fa/status).
                    ListTile(
                      leading: const Icon(Icons.shield_outlined),
                      title: const KText('Two-Factor Authentication', style: KTextStyle.bodyLarge, fontWeight: FontWeight.bold),
                      subtitle: KText(
                        twoFa == null
                            ? 'Checking status…'
                            : (twoFa.enabled ? 'Enabled' : 'Disabled'),
                        style: KTextStyle.bodyMedium,
                      ),
                      trailing: twoFa == null
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              twoFa.enabled ? Icons.check_circle : Icons.cancel_outlined,
                              color: twoFa.enabled ? Colors.green : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Notification settings card
              const KText('Notifications Preferences', style: KTextStyle.titleMedium, fontWeight: FontWeight.bold),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const KText('Email Alerts', style: KTextStyle.bodyLarge, fontWeight: FontWeight.bold),
                      value: _emailNotifications,
                      activeThumbColor: theme.colorScheme.primary,
                      onChanged: (value) {
                        setState(() {
                          _emailNotifications = value;
                        });
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const KText('Push Alerts', style: KTextStyle.bodyLarge, fontWeight: FontWeight.bold),
                      value: _pushNotifications,
                      activeThumbColor: theme.colorScheme.primary,
                      onChanged: (value) {
                        setState(() {
                          _pushNotifications = value;
                        });
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const KText('SMS / Mobile Alerts', style: KTextStyle.bodyLarge, fontWeight: FontWeight.bold),
                      value: _smsNotifications,
                      activeThumbColor: theme.colorScheme.primary,
                      onChanged: (value) {
                        setState(() {
                          _smsNotifications = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Logout Button
              KButton(
                text: 'Log Out',
                type: KButtonType.secondary,
                onPressed: () async {
                  await getIt<AuthRepository>().logout();
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
      ),
    );
  }
}
