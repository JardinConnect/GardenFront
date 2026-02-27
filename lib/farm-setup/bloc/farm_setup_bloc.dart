
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/farm-setup/models/network_info.dart';
import 'package:meta/meta.dart';

import '../../../auth/models/user.dart';
import '../../settings/users/repository/users_repository.dart';
import '../models/farm.dart';
import '../repository/farm_repository.dart';

part 'farm_setup_event.dart';
part 'farm_setup_state.dart';

class FarmSetupBloc extends Bloc<FarmSetupEvent, FarmState> {
  final UsersRepository _usersRepository;

  final FarmRepository _farmRepository;

  FarmSetupBloc() : _farmRepository = FarmRepository(), _usersRepository = UsersRepository(), super(FarmInitial()) {
    on<LoadWifiListEvent>(_loadWifiList);
    on<FarmCreateEvent>(_createFarm);
    on<RefreshWifiListEvent>(_refreshWifiList);
    add(LoadWifiListEvent());
  }

  _createFarm(FarmCreateEvent event, Emitter<FarmState> emit) async {
    final _ = await _usersRepository.addUser(event.user);
    final _ = await _farmRepository.addFarm(event.farm);
  }

  _loadWifiList(LoadWifiListEvent event, Emitter<FarmState> emit) async{
     emit(FarmLoading());
     try {
       final wifiList = await _farmRepository.getWifiList();
       emit(FarmLoaded(wifiList: wifiList));
     }catch(e){
        emit(FarmError(message: 'Failed to load Wi-Fi networks'));
      }
  }

  _refreshWifiList(RefreshWifiListEvent event, Emitter<FarmState> emit) async {
      try {
        final wifiList = await _farmRepository.getWifiList();
        emit(FarmLoaded(wifiList: wifiList));
      }catch(e){
          emit(FarmError(message: 'Failed to refresh Wi-Fi networks'));
      }
  }
}