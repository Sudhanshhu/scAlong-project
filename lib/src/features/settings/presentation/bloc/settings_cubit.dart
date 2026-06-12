import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../data/models/settings_models.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _repository;

  SettingsCubit(this._repository) : super(SettingsInitial());

  Future<void> load() async {
    emit(SettingsLoading());
    try {
      final twoFa = await _repository.get2faStatus();
      final theme = await _repository.getTheme();
      emit(SettingsLoaded(twoFaStatus: twoFa, theme: theme));
    } catch (e) {
      emit(SettingsError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  /// Persists the chosen theme to the backend and updates local state.
  Future<void> updateTheme(AppThemePreference theme) async {
    final current = state;
    if (current is SettingsLoaded) {
      emit(SettingsLoaded(twoFaStatus: current.twoFaStatus, theme: theme));
    }
    try {
      await _repository.setTheme(theme);
    } catch (_) {
      // Keep the optimistic local change; backend sync can be retried later.
    }
  }
}
