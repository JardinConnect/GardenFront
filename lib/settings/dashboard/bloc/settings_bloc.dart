import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/settings/dashboard/repository/settings_repository.dart';
import 'package:garden_connect/settings/users/repository/users_repository.dart';
import 'package:meta/meta.dart';

import '../../../auth/models/user.dart';
import '../models/settings.dart';

part 'settings_state.dart';
part 'settings_event.dart';


class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final UsersRepository usersRepository;
  final SettingsRepository settingsRepository;

  SettingsBloc({
    required this.usersRepository,
    required this.settingsRepository,
  }) : super(SettingsInitial()) {
    on<SettingsLoad>(_loadSettings);
  }

  Future<void> _loadSettings(
      SettingsLoad event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final settings = await settingsRepository.fetchSettings();
      final users = await usersRepository.fetchUsers();
      final logs = await usersRepository.fetchLogs();
      emit(SettingsLoaded(settings: settings, users: users, logs: logs));
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }
}
