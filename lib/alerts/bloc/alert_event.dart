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

final class AlertArchiveByCell extends AlertBlocEvent {
  final String cellId;

  AlertArchiveByCell({required this.cellId});
}

final class AlertChangeTab extends AlertBlocEvent {
  final AlertTabType tabType;

  AlertChangeTab({required this.tabType});
}

final class AlertClearSuccessMessage extends AlertBlocEvent {}

final class AlertShowAddView extends AlertBlocEvent {}

final class AlertHideAddView extends AlertBlocEvent {}

final class AlertShowEditView extends AlertBlocEvent {
  final String alertId;

  AlertShowEditView({required this.alertId});
}

final class AlertDeleteAlert extends AlertBlocEvent {
  final String alertId;

  AlertDeleteAlert({required this.alertId});
}

