
part of 'farm_setup_bloc.dart';


@immutable
sealed class FarmState {}

final class FarmInitial extends FarmState {}

final class FarmLoading extends FarmState {}

final class FarmError extends FarmState {
  final String message;

  FarmError({required this.message});
}

final class FarmLoaded extends FarmState {
  final List<NetworkInfo> wifiList;

  FarmLoaded({required this.wifiList});
}

final class FarmCreation extends FarmState {
  final Farm farm;

  FarmCreation({required this.farm});
}