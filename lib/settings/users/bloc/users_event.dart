part of 'users_bloc.dart';

@immutable
sealed class UsersEvent {}

final class UsersLoad extends UsersEvent {
  final User? currentUser;

  UsersLoad({this.currentUser});
}

final class UserSelect extends UsersEvent {
  final User user;

  UserSelect({required this.user});
}
final class UserUpdateEvent extends UsersEvent {
  final User user;

  UserUpdateEvent({required this.user});
}
final class UserAddEvent extends UsersEvent {
  final UserAddDto user;
  final bool isFarmSetup;

  UserAddEvent({required this.user, this.isFarmSetup=false});
}
final class UserDeleteEvent extends UsersEvent {
  final User user;

  UserDeleteEvent({required this.user});
}

final class UsersCreationEvent extends UsersEvent {}