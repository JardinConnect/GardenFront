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
  final List<AlertEvent> alertEvents; // AlertEvent du modèle
  final DisplayMode displayMode;
  final AlertTabType selectedTab;
  final String? successMessage;

  AlertLoaded({
    required this.alerts,
    required this.sensorAlerts,
    required this.alertEvents,
    required this.displayMode,
    required this.selectedTab,
    this.successMessage,
  });

  AlertLoaded copyWith({
    List<Alert>? alerts,
    List<SensorAlertData>? sensorAlerts,
    List<AlertEvent>? alertEvents,
    DisplayMode? displayMode,
    AlertTabType? selectedTab,
    String? successMessage,
    bool clearSuccessMessage = false,
  }) {
    return AlertLoaded(
      alerts: alerts ?? this.alerts,
      sensorAlerts: sensorAlerts ?? this.sensorAlerts,
      alertEvents: alertEvents ?? this.alertEvents,
      displayMode: displayMode ?? this.displayMode,
      selectedTab: selectedTab ?? this.selectedTab,
      successMessage: clearSuccessMessage ? null : (successMessage ?? this.successMessage),
    );
  }
}