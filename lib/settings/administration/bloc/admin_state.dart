part of 'admin_bloc.dart';

@immutable
sealed class AdminState {

  const AdminState();
}

final class AdminInitial extends AdminState {
  const AdminInitial() : super();
}

final class AdminError extends AdminState {
  final String message;

  const AdminError({required this.message}) : super();
}

final class AdminShimmer extends AdminState {
  const AdminShimmer() : super();
}

final class AdminLoaded extends AdminState {
  final SystemMetrics systemMetrics;
  final String? vpnAuthURL;

  const AdminLoaded({required this.systemMetrics, this.vpnAuthURL});
}