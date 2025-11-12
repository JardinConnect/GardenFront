part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class DashboardError extends DashboardState {
  final String message;

  DashboardError({required this.message});
}

final class DashboardAnalyticsShimmer extends DashboardState {}

final class DashboardAnalyticsLoaded extends DashboardState {
  final Analytics analytics;

  DashboardAnalyticsLoaded({required this.analytics});
}