part of 'analytics_bloc.dart';

@immutable
sealed class AnalyticsState {}

final class AnalyticsInitial extends AnalyticsState {}

final class AnalyticsError extends AnalyticsState {
  final String message;

  AnalyticsError({required this.message});
}

final class AnalyticsShimmer extends AnalyticsState {}

final class AnalyticsLoaded extends AnalyticsState {
  final Analytics analytics;

  AnalyticsLoaded({required this.analytics});
}