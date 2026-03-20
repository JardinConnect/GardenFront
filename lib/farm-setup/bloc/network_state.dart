
part of 'farm_setup_bloc.dart';


@immutable
sealed class FarmState {}

final class FarmInitial extends FarmState {}

final class FarmLoading extends FarmState {}

final class FarmError extends FarmState {
  final String message;

  FarmError({required this.message});
}

final class NetworkLoaded extends FarmState {
  final List<NetworkInfo> wifiList;
  final NetworkState networkState;

  NetworkLoaded({required this.wifiList, required this.networkState});
}

enum NetworkState {
  connecting,
  connected,
  connexionFailed,
  none,
}

final class FarmCreated extends FarmState {}
