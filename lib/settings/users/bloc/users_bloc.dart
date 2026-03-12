
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
    on<UserUpdateEvent>(_updateUser);
    on<UserAddEvent>(_addUser);
    on<UserDeleteEvent>(_deleteUser);
    on<UsersCreationEvent>((event, emit) => emit(UserCreation()));
  }

  _selectUser(UserSelect event, Emitter<UsersState> emit) async {
    final logs = await _usersRepository.fetchLogsByUser(event.user.id);
    emit(UserSelected(user: event.user, logs: logs));
  }


  _loadUsers(UsersLoad event, Emitter<UsersState> emit) async {
    emit(UsersLoading());
    try {
      final users = await _usersRepository.fetchUsers();
      late final List<Log> logs;
      if(event.currentUser?.role != Role.admin || event.currentUser?.role != Role.superadmin){
        logs = await _usersRepository.fetchLogs();
      }else{
        logs = await _usersRepository.fetchLogsByUser(event.currentUser);
      }
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
  _deleteUser(UserDeleteEvent event, Emitter<UsersState> emit) async {
    final _ = await _usersRepository.deleteUser(event.user.id);
    add(UsersLoad());
  }
  _addUser(UserAddEvent event, Emitter<UsersState> emit) async {
    final _ = await _usersRepository.addUser(event.user);
    if(!event.isFarmSetup) {
      add(UsersLoad());
    }
  }
}