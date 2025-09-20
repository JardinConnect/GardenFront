part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthAuthenticated extends AuthState {
  final User user;

  AuthAuthenticated({required this.user});
}

final class AuthUnauthenticated extends AuthState {
  final String? error;

  AuthUnauthenticated({this.error});
}