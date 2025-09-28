part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthAuthenticated extends AuthState {
  final User user;
  final bool isAutoLogin;

  AuthAuthenticated({required this.user, this.isAutoLogin = false});
}

final class AuthUnauthenticated extends AuthState {
  final String? error;

  AuthUnauthenticated({this.error});
}