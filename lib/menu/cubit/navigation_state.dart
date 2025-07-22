import 'package:equatable/equatable.dart';

class NavigationState extends Equatable {
  final int index;

  const NavigationState(this.index);

  @override
  List<Object?> get props => [index];
}