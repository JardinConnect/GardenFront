
part of 'farm_setup_bloc.dart';


@immutable
sealed class FarmState {}

final class FarmInitial extends FarmState {}

final class FarmCreation extends FarmState {
  final Farm farm;

  FarmCreation({required this.farm});
}