import 'package:equatable/equatable.dart';
import '../../data/models/settings_models.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final TwoFaStatus twoFaStatus;
  final AppThemePreference theme;

  const SettingsLoaded({required this.twoFaStatus, required this.theme});

  @override
  List<Object?> get props => [twoFaStatus, theme];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
