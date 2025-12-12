part of 'analytics_bloc.dart';

@immutable
sealed class AnalyticsEvent {}

final class LoadAnalytics extends AnalyticsEvent {}