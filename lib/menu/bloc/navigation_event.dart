import 'package:equatable/equatable.dart';

/// Événements de navigation dans l'application
abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

/// Navigation vers un élément du menu principal
class NavigateToMain extends NavigationEvent {
  const NavigateToMain();
}

/// Navigation vers un élément du menu des paramètres
class NavigateToSettings extends NavigationEvent {
  const NavigateToSettings();
}

/// Sortie du menu des paramètres vers le menu principal
class ExitSettings extends NavigationEvent {
  const ExitSettings();
}
