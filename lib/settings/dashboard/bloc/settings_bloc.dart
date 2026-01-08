import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/settings/dashboard/repository/settings_repository.dart';
import 'package:meta/meta.dart';

import '../../../auth/models/user.dart';
import '../models/settings.dart';

part 'settings_state.dart';
part 'settings_event.dart';


class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {

  final SettingsRepository _settingsRepository;

  SettingsBloc() : _settingsRepository = SettingsRepository(), super(SettingsInitial()){
    on<SettingsLoad>(_loadSettings);

    add(SettingsLoad());
  }
  _loadSettings(SettingsLoad event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final settings = await _settingsRepository.fetchSettings();
      final users = await _settingsRepository.fetchUsers() ?? [];
      final logs = await _settingsRepository.fetchLogs();
      emit(SettingsLoaded(settings: settings, users: users, logs: logs));
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }
}