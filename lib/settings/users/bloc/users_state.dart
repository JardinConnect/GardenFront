part of 'users_bloc.dart';

@immutable
sealed class UsersState {}

final class UsersInitial extends UsersState {}

final class UsersLoading extends UsersState {}

final class UsersError extends UsersState {
  final String message;

  UsersError({required this.message});
}

final class UsersLoaded extends UsersState {
  final List<User> users;
  final List<Log> logs;

  UsersLoaded({required this.users, required this.logs});
}

final class UserCreation extends UsersState {}

final class UserSelected extends UsersState {
  final User user;
  final List<Log> logs;

  UserSelected({required this.user, required this.logs});
}
final class UserUpdate extends UsersState {}
final class UserAdd extends UsersState {}