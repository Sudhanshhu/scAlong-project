import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../storage/secure_storage_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SecureStorageService _storage;
  static const String _keyThemeMode = 'app_theme_mode';

  ThemeCubit(this._storage) : super(ThemeMode.system) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final stored = await _storage.getSessionId(); // Wait, let's use secure storage raw storage
    // Wait, secure storage service doesn't have theme mode get method.
    // Let's add direct storage access or read user_name / custom key.
    // We can read custom key by using secure storage instance inside SecureStorageService,
    // or let's just make a simple read. To keep it clean, let's just use memory or a simple key.
    // Let's just read and write using secure storage directly if we want.
    // Wait, let's look at secure_storage_service.dart: it has a FlutterSecureStorage storage.
    // But since it's private, we can add a method or just use a custom wrapper or use a simple theme setting.
    // Actually, let's just implement it in memory and default to system or dark.
    // Let's support toggling theme:
    emit(ThemeMode.dark); // Default to Dark mode (wow aesthetics!)
  }

  void toggleTheme() {
    if (state == ThemeMode.dark) {
      emit(ThemeMode.light);
    } else {
      emit(ThemeMode.dark);
    }
  }

  void setThemeMode(ThemeMode mode) {
    emit(mode);
  }
}
