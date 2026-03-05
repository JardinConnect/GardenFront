part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

final class SettingsLoad extends SettingsEvent {
  final User currentUser;

  SettingsLoad({required this.currentUser});
}