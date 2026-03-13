


part of 'farm_setup_bloc.dart';

sealed class FarmSetupEvent {}

class FarmCreateEvent extends FarmSetupEvent {
  final Farm farm;
  final UserAddDto user;
  final List<Area> areas;

  FarmCreateEvent({required this.farm, required this.user, required this.areas});
}
class NetworkChange extends FarmSetupEvent{}

class ConnectFarmToWifiEvent extends FarmSetupEvent {
  final String ssid;
  final String password;

  ConnectFarmToWifiEvent({required this.ssid, required this.password});
}

class RefreshWifiListEvent extends FarmSetupEvent {}

class LoadWifiListEvent extends FarmSetupEvent {}
