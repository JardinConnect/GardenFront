


part of 'farm_setup_bloc.dart';

class FarmSetupEvent {}

class FarmCreateEvent extends FarmSetupEvent {
  final Farm farm;
  final UserAddDto user;
  final String wifiPassword;
  final String wifiSsid;

  FarmCreateEvent({required this.farm, required this.user, required this.wifiPassword, required this.wifiSsid});
}