import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../data/auth_repository.dart';
import '../models/user.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc() : _authRepository = AuthRepository(), super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckStatus>(_onCheckStatus);
    on<AuthAppStarted>(_onAppStarted);

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
        //TODO vérifier si le token est encore valide

        emit(AuthAuthenticated(user: user, isAutoLogin: true));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      print('Erreur lors de la vérification au démarrage: $e');
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
    emit(AuthLoading());

    try {
      await _authRepository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthUnauthenticated(error: "Erreur lors de la déconnexion"));
    }
  }

  Future<void> _onCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final token = await _authRepository.getToken();
    final user = await _authRepository.getUser();

    if (token != null && user != null) {
      emit(AuthAuthenticated(user: user));
    } else {
      emit(AuthUnauthenticated());
    }
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