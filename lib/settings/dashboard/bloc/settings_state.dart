part of 'settings_bloc.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class SettingsLoading extends SettingsState {}

final class SettingsError extends SettingsState {
  final String message;

  SettingsError({required this.message});
}

final class SettingsLoaded extends SettingsState {
  final Settings settings;
  final List<User> users;
  final Logs logs;

  SettingsLoaded({required this.settings, required this.users, required this.logs});
}