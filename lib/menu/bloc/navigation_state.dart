import 'package:equatable/equatable.dart';

/// État de navigation pour gérer le menu principal et les paramètres
class NavigationState extends Equatable {
  /// Indique si on est dans le menu des paramètres
  final bool isInSettings;

  const NavigationState({this.isInSettings = false});

  /// Crée une copie de l'état avec les valeurs modifiées
  NavigationState copyWith({bool? isInSettings}) {
    return NavigationState(isInSettings: isInSettings ?? this.isInSettings);
  }

  @override
  List<Object?> get props => [isInSettings];
}
