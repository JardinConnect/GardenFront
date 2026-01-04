part of 'alert_bloc.dart';

@immutable
sealed class AlertState {}

final class AlertInitial extends AlertState {}

final class AlertLoading extends AlertState {}

final class AlertError extends AlertState {
  final String message;

  AlertError({required this.message});
}

final class AlertLoaded extends AlertState {
  final List<Alert> alerts;
  final List<SensorAlertData> sensorAlerts;
  final List<AlertEvent> alertEvents;
  final DisplayMode displayMode;
  final AlertTabType selectedTab;
  final String? successMessage;
  final bool isShowingAddView;
  final bool isShowingEditView;
  final String? editingAlertId;
  final Alert? editingAlert;
  final List<Map<String, dynamic>> spaces;
  final Map<String, dynamic>? alertDetails;
  final List<Map<String, dynamic>> availableSensors;
  final List<SelectedSensor> selectedSensors;
  final Map<String, RangeValues> criticalRanges;
  final Map<String, RangeValues> warningRanges;
  final bool isWarningEnabled;

  AlertLoaded({
    required this.alerts,
    required this.sensorAlerts,
    required this.alertEvents,
    required this.displayMode,
    required this.selectedTab,
    this.successMessage,
    this.isShowingAddView = false,
    this.isShowingEditView = false,
    this.editingAlertId,
    this.editingAlert,
    this.spaces = const [],
    this.alertDetails,
    this.availableSensors = const [],
    this.selectedSensors = const [],
    this.criticalRanges = const {},
    this.warningRanges = const {},
    this.isWarningEnabled = true,
  });

  AlertLoaded copyWith({
    List<Alert>? alerts,
    List<SensorAlertData>? sensorAlerts,
    List<AlertEvent>? alertEvents,
    DisplayMode? displayMode,
    AlertTabType? selectedTab,
    String? successMessage,
    bool? isShowingAddView,
    bool? isShowingEditView,
    String? editingAlertId,
    Alert? editingAlert,
    List<Map<String, dynamic>>? spaces,
    Map<String, dynamic>? alertDetails,
    List<Map<String, dynamic>>? availableSensors,
    List<SelectedSensor>? selectedSensors,
    Map<String, RangeValues>? criticalRanges,
    Map<String, RangeValues>? warningRanges,
    bool? isWarningEnabled,
    bool clearSuccessMessage = false,
  }) {
    return AlertLoaded(
      alerts: alerts ?? this.alerts,
      sensorAlerts: sensorAlerts ?? this.sensorAlerts,
      alertEvents: alertEvents ?? this.alertEvents,
      displayMode: displayMode ?? this.displayMode,
      selectedTab: selectedTab ?? this.selectedTab,
      successMessage: clearSuccessMessage ? null : (successMessage ?? this.successMessage),
      isShowingAddView: isShowingAddView ?? this.isShowingAddView,
      isShowingEditView: isShowingEditView ?? this.isShowingEditView,
      editingAlertId: editingAlertId ?? this.editingAlertId,
      editingAlert: editingAlert ?? this.editingAlert,
      spaces: spaces ?? this.spaces,
      alertDetails: alertDetails ?? this.alertDetails,
      availableSensors: availableSensors ?? this.availableSensors,
      selectedSensors: selectedSensors ?? this.selectedSensors,
      criticalRanges: criticalRanges ?? this.criticalRanges,
      warningRanges: warningRanges ?? this.warningRanges,
      isWarningEnabled: isWarningEnabled ?? this.isWarningEnabled,
    );
  }
}