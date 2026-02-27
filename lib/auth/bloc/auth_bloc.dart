import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_repository.dart';
import '../models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  Timer? _refreshTimer;

  void _startRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 9), (_) {
      add(AuthTokenRefreshRequested());
    });
  }

  void _stopRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  AuthBloc() : _authRepository = AuthRepository(), super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthAppStarted>(_onAppStarted);
    on<AuthTokenRefreshRequested>(_onTokenRefreshRequested);

    add(AuthAppStarted());
  }

  Future<void> _onAppStarted(
      AuthAppStarted event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      final token = await _authRepository.getToken();
      final user = await _authRepository.getUser();

      if (token != null && user != null) {
        _startRefreshTimer();
        emit(AuthAuthenticated(user: user, isAutoLogin: true));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la vérification au démarrage: $e');
      }
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await _authRepository.login(event.email, event.password);

      if (user != null) {
        _startRefreshTimer();
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated(error: "Identifiants incorrects"));
      }
    } catch (e) {
      emit(AuthUnauthenticated(error: "Erreur de connexion: ${e.toString()}"));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    _startRefreshTimer();
    emit(AuthLoading());

    try {
      await _authRepository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthUnauthenticated(error: "Erreur lors de la déconnexion"));
    }
  }

  Future<void> _onTokenRefreshRequested(
      AuthTokenRefreshRequested event,
      Emitter<AuthState> emit,
      ) async {
    final success = await _authRepository.refreshAccessToken();
    if (!success) {
      _stopRefreshTimer();
      await _authRepository.logout();
      emit(AuthUnauthenticated(error: "Session expirée, veuillez vous reconnecter"));
    }
  }

  @override
  Future<void> close() {
    _stopRefreshTimer();
    return super.close();
  }

  User? get currentUser {
    final state = this.state;
    if (state is AuthAuthenticated) {
      return state.user;
    }
    return null;
  }

  bool get isAuthenticated {
    return state is AuthAuthenticated;
  }
}