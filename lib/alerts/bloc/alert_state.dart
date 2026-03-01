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
  // Données
  final List<Alert> alerts;
  final List<SensorAlertData> sensorAlerts;
  final List<AlertEvent> alertEvents;
  final List<Map<String, dynamic>> spaces;
  final List<Map<String, dynamic>> availableSensors;
  final List<CellItem> cells;

  // Navigation
  final DisplayMode displayMode;
  final AlertTabType selectedTab;
  final bool isShowingAddView;
  final bool isShowingEditView;
  final String? editingAlertId;
  final Alert? editingAlert;
  final Map<String, dynamic>? alertDetails;

  // Formulaire capteurs
  final List<SelectedSensor> selectedSensors;
  final Map<String, RangeValues> criticalRanges;
  final Map<String, RangeValues> warningRanges;
  final bool isWarningEnabled;

  // Conflit en attente de confirmation
  final List<AlertConflict>? pendingConflicts;
  final AlertCreationRequest? pendingRequest;

  // Messages UI
  final String? successMessage;
  final String? errorMessage;

  AlertLoaded({
    required this.alerts,
    required this.sensorAlerts,
    required this.alertEvents,
    required this.displayMode,
    required this.selectedTab,
    this.spaces = const [],
    this.availableSensors = const [],
    this.cells = const [],
    this.isShowingAddView = false,
    this.isShowingEditView = false,
    this.editingAlertId,
    this.editingAlert,
    this.alertDetails,
    this.selectedSensors = const [],
    this.criticalRanges = const {},
    this.warningRanges = const {},
    this.isWarningEnabled = true,
    this.pendingConflicts,
    this.pendingRequest,
    this.successMessage,
    this.errorMessage,
  });

  AlertLoaded copyWith({
    List<Alert>? alerts,
    List<SensorAlertData>? sensorAlerts,
    List<AlertEvent>? alertEvents,
    List<Map<String, dynamic>>? spaces,
    List<Map<String, dynamic>>? availableSensors,
    List<CellItem>? cells,
    DisplayMode? displayMode,
    AlertTabType? selectedTab,
    bool? isShowingAddView,
    bool? isShowingEditView,
    String? editingAlertId,
    Alert? editingAlert,
    Map<String, dynamic>? alertDetails,
    List<SelectedSensor>? selectedSensors,
    Map<String, RangeValues>? criticalRanges,
    Map<String, RangeValues>? warningRanges,
    bool? isWarningEnabled,
    List<AlertConflict>? pendingConflicts,
    bool clearPendingConflicts = false,
    AlertCreationRequest? pendingRequest,
    bool clearPendingRequest = false,
    String? successMessage,
    bool clearSuccessMessage = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AlertLoaded(
      alerts: alerts ?? this.alerts,
      sensorAlerts: sensorAlerts ?? this.sensorAlerts,
      alertEvents: alertEvents ?? this.alertEvents,
      spaces: spaces ?? this.spaces,
      availableSensors: availableSensors ?? this.availableSensors,
      cells: cells ?? this.cells,
      displayMode: displayMode ?? this.displayMode,
      selectedTab: selectedTab ?? this.selectedTab,
      isShowingAddView: isShowingAddView ?? this.isShowingAddView,
      isShowingEditView: isShowingEditView ?? this.isShowingEditView,
      editingAlertId: editingAlertId ?? this.editingAlertId,
      editingAlert: editingAlert ?? this.editingAlert,
      alertDetails: alertDetails ?? this.alertDetails,
      selectedSensors: selectedSensors ?? this.selectedSensors,
      criticalRanges: criticalRanges ?? this.criticalRanges,
      warningRanges: warningRanges ?? this.warningRanges,
      isWarningEnabled: isWarningEnabled ?? this.isWarningEnabled,
      pendingConflicts: clearPendingConflicts ? null : (pendingConflicts ?? this.pendingConflicts),
      pendingRequest: clearPendingRequest ? null : (pendingRequest ?? this.pendingRequest),
      successMessage: clearSuccessMessage ? null : (successMessage ?? this.successMessage),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}