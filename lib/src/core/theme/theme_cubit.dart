import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Drives the app's light/dark mode. The persisted preference lives on the
/// backend (`/api/kyc/theme`) and is synced into this cubit from the Settings
/// screen on load; this cubit holds the in-memory mode the [MaterialApp] uses.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.dark);

  void toggleTheme() =>
      emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);

  void setThemeMode(ThemeMode mode) => emit(mode);
}
