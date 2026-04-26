part of 'alert_bloc.dart';

@immutable
sealed class AlertBlocEvent {
  const AlertBlocEvent();
}

// -- Chargement --
final class AlertLoadData extends AlertBlocEvent {
  const AlertLoadData();
}

final class AlertLoadCells extends AlertBlocEvent {
  const AlertLoadCells();
}

// -- Navigation --
final class AlertShowAddView extends AlertBlocEvent {
  const AlertShowAddView();
}

final class AlertHideAddView extends AlertBlocEvent {
  const AlertHideAddView();
}

final class AlertShowEditView extends AlertBlocEvent {
  final String alertId;
  const AlertShowEditView({required this.alertId});
}

// -- CRUD alertes --
final class AlertValidateAlert extends AlertBlocEvent {
  final AlertCreationRequest request;
  const AlertValidateAlert({required this.request});
}

final class AlertConfirmCreate extends AlertBlocEvent {
  final bool overwrite;
  const AlertConfirmCreate({required this.overwrite});
}

final class AlertCancelCreate extends AlertBlocEvent {
  const AlertCancelCreate();
}

final class AlertCreateAlert extends AlertBlocEvent {
  final AlertCreationRequest request;
  const AlertCreateAlert({required this.request});
}

final class AlertUpdateAlert extends AlertBlocEvent {
  final String alertId;
  final AlertCreationRequest request;
  const AlertUpdateAlert({required this.alertId, required this.request});
}

// Valide les conflits avant la mise à jour d'une alerte
final class AlertValidateUpdate extends AlertBlocEvent {
  final String alertId;
  final AlertCreationRequest request;
  const AlertValidateUpdate({required this.alertId, required this.request});
}

// Confirme la mise à jour après résolution des conflits
final class AlertConfirmUpdate extends AlertBlocEvent {
  final bool overwrite;
  const AlertConfirmUpdate({required this.overwrite});
}

// Annule la mise à jour en cours de validation
final class AlertCancelUpdate extends AlertBlocEvent {
  const AlertCancelUpdate();
}

final class AlertDeleteAlert extends AlertBlocEvent {
  final String alertId;
  const AlertDeleteAlert({required this.alertId});
}

final class AlertToggleStatus extends AlertBlocEvent {
  final String alertId;
  final bool isActive;
  const AlertToggleStatus({required this.alertId, required this.isActive});
}

// -- Archivage événements --
final class AlertDeleteEvent extends AlertBlocEvent {
  final String eventId;
  const AlertDeleteEvent({required this.eventId});
}

final class AlertArchiveAll extends AlertBlocEvent {
  const AlertArchiveAll();
}

final class AlertArchiveByCell extends AlertBlocEvent {
  final String cellId;
  const AlertArchiveByCell({required this.cellId});
}

// -- UI --
final class AlertChangeDisplayMode extends AlertBlocEvent {
  final DisplayMode displayMode;
  const AlertChangeDisplayMode({required this.displayMode});
}

final class AlertChangeTab extends AlertBlocEvent {
  final AlertTabType tabType;
  const AlertChangeTab({required this.tabType});
}

final class AlertUpdateSensors extends AlertBlocEvent {
  final List<SelectedSensor> sensors;
  const AlertUpdateSensors({required this.sensors});
}

final class AlertUpdateCriticalRange extends AlertBlocEvent {
  final SelectedSensor sensor;
  final RangeValues range;
  const AlertUpdateCriticalRange({required this.sensor, required this.range});
}

final class AlertUpdateWarningRange extends AlertBlocEvent {
  final SelectedSensor sensor;
  final RangeValues range;
  const AlertUpdateWarningRange({required this.sensor, required this.range});
}

final class AlertUpdateWarningEnabled extends AlertBlocEvent {
  final bool enabled;
  const AlertUpdateWarningEnabled({required this.enabled});
}

// -- Messages --
final class AlertClearSuccessMessage extends AlertBlocEvent {
  const AlertClearSuccessMessage();
}

final class AlertClearErrorMessage extends AlertBlocEvent {
  const AlertClearErrorMessage();
}

/// Pousse un message d'erreur dans le state depuis une vue
final class AlertPushError extends AlertBlocEvent {
  final String message;
  const AlertPushError({required this.message});
}

final class AlertSSENewEvent extends AlertBlocEvent {
  final AlertEvent alertEvent;
  const AlertSSENewEvent({required this.alertEvent});
}

final class AlertSSEClearNotification extends AlertBlocEvent {
  const AlertSSEClearNotification();
}
