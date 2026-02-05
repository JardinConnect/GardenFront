import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation_event.dart';
import 'navigation_state.dart';

/// Gère l'état de navigation entre le menu principal et les paramètres
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState()) {
    on<NavigateToMain>(_onNavigateToMain);
    on<NavigateToSettings>(_onNavigateToSettings);
    on<ExitSettings>(_onExitSettings);
  }

  /// Navigue vers un élément du menu principal
  void _onNavigateToMain(NavigateToMain event, Emitter<NavigationState> emit) {
    emit(state.copyWith(isInSettings: false));
  }

  /// Navigue vers un élément du menu des paramètres
  void _onNavigateToSettings(
    NavigateToSettings event,
    Emitter<NavigationState> emit,
  ) {
    emit(state.copyWith(isInSettings: true));
  }

  /// Quitte le menu des paramètres et revient au menu principal
  void _onExitSettings(ExitSettings event, Emitter<NavigationState> emit) {
    emit(state.copyWith(isInSettings: false));
  }
}
