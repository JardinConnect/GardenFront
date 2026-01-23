import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../auth/models/user.dart';
import '../../dashboard/models/settings.dart';
import '../repository/users_repository.dart';

part 'users_state.dart';
part 'users_event.dart';


class UsersBloc extends Bloc<UsersEvent, UsersState> {

  final UsersRepository _usersRepository;

  UsersBloc() : _usersRepository = UsersRepository(), super(UsersInitial()){
    on<UsersLoad>(_loadUsers);
    on<UserSelect>(_selectUser);
    on<UsersUnselectEvent>(_unselectUser);
    on<UserUpdateEvent>(_updateUser);
    on<UserAddEvent>(_addUser);
    on<UsersCreationEvent>((event, emit) => emit(UserCreation()));

    add(UsersLoad());
  }

  _selectUser(UserSelect event, Emitter<UsersState> emit) async {

    final logs = await _usersRepository.fetchLogsByUser(event.user.id);
    emit(UserSelected(user: event.user, logs: logs));
  }


  _unselectUser(UsersUnselectEvent event, Emitter<UsersState> emit) {
    emit(UsersInitial());
    add(UsersLoad());
  }


  _loadUsers(UsersLoad event, Emitter<UsersState> emit) async {
    emit(UsersLoading());
    try {
      final users = await _usersRepository.fetchUsers() ;
      final logs = await _usersRepository.fetchLogs();
      emit(UsersLoaded( users: users,logs: logs));
    } catch (e) {
      emit(UsersError(message: e.toString()));
    }
  }

  User? get selectedUser {
    final state = this.state;
    if (state is UserSelected) {
      return state.user;
    }
    return null;
  }
  List<Log>? get userLogs {
    final state = this.state;
    if (state is UserSelected) {
      return state.logs;
    }
    return null;
  }

  _updateUser(UserUpdateEvent event, Emitter<UsersState> emit) async {
    final _ = await _usersRepository.updateUser(event.user);
  }
  _addUser(UserAddEvent event, Emitter<UsersState> emit) async {
    final _ = await _usersRepository.addUser(event.user);
  }
}