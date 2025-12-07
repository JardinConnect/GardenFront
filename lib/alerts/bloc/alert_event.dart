part of 'alert_bloc.dart';

@immutable
sealed class AlertBlocEvent {}

final class AlertLoadData extends AlertBlocEvent {}

final class AlertChangeDisplayMode extends AlertBlocEvent {
  final DisplayMode displayMode;

  AlertChangeDisplayMode({required this.displayMode});
}

final class AlertToggleStatus extends AlertBlocEvent {
  final String alertId;
  final bool isActive;

  AlertToggleStatus({required this.alertId, required this.isActive});
}

final class AlertDeleteEvent extends AlertBlocEvent {
  final String eventId;

  AlertDeleteEvent({required this.eventId});
}

final class AlertArchiveAll extends AlertBlocEvent {}

final class AlertChangeTab extends AlertBlocEvent {
  final AlertTabType tabType;

  AlertChangeTab({required this.tabType});
}

final class AlertClearSuccessMessage extends AlertBlocEvent {}