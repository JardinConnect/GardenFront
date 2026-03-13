
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/farm-setup/models/network_info.dart';
import 'package:meta/meta.dart';

import '../../../auth/models/user.dart';
import '../../areas/models/area.dart';
import '../models/farm.dart';
import '../repository/farm_repository.dart';

part 'farm_setup_event.dart';
part 'network_state.dart';

class FarmSetupBloc extends Bloc<FarmSetupEvent, FarmState> {

  final FarmRepository _farmRepository;

  FarmSetupBloc() : _farmRepository = FarmRepository(), super(FarmInitial()) {
    on<LoadWifiListEvent>(_loadWifiList);
    on<FarmCreateEvent>(_createFarm);
    on<RefreshWifiListEvent>(_refreshWifiList);
    on<ConnectFarmToWifiEvent>(_connectFarmToWifi);
    on<NetworkChange>(_networkChange);
    add(LoadWifiListEvent());
  }

  _createFarm(FarmCreateEvent event, Emitter<FarmState> emit) async {
    final _ = await _farmRepository.addFarm(event.farm);
  }

  _loadWifiList(LoadWifiListEvent event, Emitter<FarmState> emit) async{
     emit(FarmLoading());
     try {
       final wifiList = await _farmRepository.getWifiList();
       emit(NetworkLoaded(wifiList: wifiList, networkState: NetworkState.none));
     }catch(e){
        emit(FarmError(message: 'Failed to load Wi-Fi networks'));
     }
  }
  _networkChange(NetworkChange event, Emitter<FarmState> emit){
    emit(NetworkLoaded(wifiList: (state as NetworkLoaded).wifiList, networkState: NetworkState.none));
  }
  _connectFarmToWifi(ConnectFarmToWifiEvent event, Emitter<FarmState> emit) async {
    emit(NetworkLoaded(wifiList: (state as NetworkLoaded).wifiList, networkState: NetworkState.connecting));
    try {
      var wifi = (state as NetworkLoaded).wifiList.firstWhere(
          (wifi)=>wifi.ssid == event.ssid
      );
      var response = wifi.security == event.password;
      //bool response = await _farmRepository.sendWifiConfiguration(event.ssid, event.password);
      if(!response) {
        emit(NetworkLoaded(wifiList: (state as NetworkLoaded).wifiList, networkState: NetworkState.connexionFailed));
      }else {
        emit(NetworkLoaded(wifiList: (state as NetworkLoaded).wifiList, networkState: NetworkState.connected));
      }
    }catch(e){
      emit(FarmError(message: 'Failed to connect to Wi-Fi'));
    }
  }

  _refreshWifiList(RefreshWifiListEvent event, Emitter<FarmState> emit) async {
      try {
        final wifiList = await _farmRepository.getWifiList();
        emit(NetworkLoaded(wifiList: wifiList,networkState: NetworkState.none));
      }catch(e){
          emit(FarmError(message: 'Failed to refresh Wi-Fi networks'));
      }
  }
}