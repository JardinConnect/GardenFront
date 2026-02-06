part of 'users_bloc.dart';

@immutable
sealed class UsersEvent {}

final class UsersLoad extends UsersEvent {}

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

  UserAddEvent({required this.user});
}
final class UserDeleteEvent extends UsersEvent {
  final User user;

  UserDeleteEvent({required this.user});
}

final class UsersUnselectEvent extends UsersEvent {}

final class UsersCreationEvent extends UsersEvent {}