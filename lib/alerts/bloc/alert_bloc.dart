import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../models/alert_models.dart';
import '../data/alert_repository.dart';
import '../view/alerts_page.dart'; // Pour DisplayMode
import '../widgets/button/tab_menu.dart'; // Pour AlertTabType

part 'alert_event.dart';
part 'alert_state.dart';

class AlertBloc extends Bloc<AlertBlocEvent, AlertState> {
  final AlertRepository _alertRepository;

  AlertBloc() : _alertRepository = AlertRepository(), super(AlertInitial()) {
    on<AlertLoadData>(_loadData);
    on<AlertChangeDisplayMode>(_changeDisplayMode);
    on<AlertToggleStatus>(_toggleStatus);
    on<AlertDeleteEvent>(_deleteEvent);
    on<AlertArchiveAll>(_archiveAll);
    on<AlertChangeTab>(_changeTab);
    on<AlertClearSuccessMessage>(_clearSuccessMessage);
    on<AlertShowAddView>(_showAddView);
    on<AlertHideAddView>(_hideAddView);

    // Charger les données initiales
    add(AlertLoadData());
  }

  Future<void> _loadData(AlertLoadData event, Emitter<AlertState> emit) async {
    emit(AlertLoading());
    try {
      final alerts = await _alertRepository.getAlertsForListView();
      final sensorAlerts = await _alertRepository.getSensorAlertsForCardView();
      final alertEvents = await _alertRepository.getAlertHistory();

      emit(AlertLoaded(
        alerts: alerts,
        sensorAlerts: sensorAlerts,
        alertEvents: alertEvents,
        displayMode: DisplayMode.list,
        selectedTab: AlertTabType.alerts,
      ));
    } catch (e) {
      emit(AlertError(message: e.toString()));
    }
  }

  void _changeDisplayMode(AlertChangeDisplayMode event, Emitter<AlertState> emit) {
    if (state is AlertLoaded) {
      final currentState = state as AlertLoaded;
      emit(currentState.copyWith(displayMode: event.displayMode));
    }
  }

  Future<void> _toggleStatus(AlertToggleStatus event, Emitter<AlertState> emit) async {
    if (state is! AlertLoaded) return;

    final currentState = state as AlertLoaded;
    
    try {
      await _alertRepository.updateAlertStatus(event.alertId, event.isActive);

      // Mettre à jour les alerts dans la liste
      final updatedAlerts = currentState.alerts.map((alert) {
        if (alert.id == event.alertId) {
          return Alert(
            id: alert.id,
            title: alert.title,
            description: alert.description,
            sensorTypes: alert.sensorTypes,
            isActive: event.isActive,
          );
        }
        return alert;
      }).toList();

      // Mettre à jour les sensor alerts
      final updatedSensorAlerts = currentState.sensorAlerts.map((sensorAlert) {
        if (sensorAlert.id == event.alertId) {
          return sensorAlert.copyWith(isEnabled: event.isActive);
        }
        return sensorAlert;
      }).toList();

      emit(currentState.copyWith(
        alerts: updatedAlerts,
        sensorAlerts: updatedSensorAlerts,
        successMessage: 'Statut de l\'alerte mis à jour',
      ));
    } catch (e) {
      emit(AlertError(message: 'Erreur lors de la mise à jour: ${e.toString()}'));
    }
  }

  Future<void> _deleteEvent(AlertDeleteEvent event, Emitter<AlertState> emit) async {
    if (state is! AlertLoaded) return;

    final currentState = state as AlertLoaded;
    
    try {
      await _alertRepository.archiveAlertEvent(event.eventId);

      final updatedEvents = currentState.alertEvents
          .where((alertEvent) => alertEvent.id != event.eventId)
          .toList();

      emit(currentState.copyWith(
        alertEvents: updatedEvents,
        successMessage: 'Événement archivé avec succès',
      ));
    } catch (e) {
      emit(AlertError(message: 'Erreur lors de la suppression: ${e.toString()}'));
    }
  }

  Future<void> _archiveAll(AlertArchiveAll event, Emitter<AlertState> emit) async {
    if (state is! AlertLoaded) return;

    final currentState = state as AlertLoaded;
    
    try {
      for (final alertEvent in currentState.alertEvents) {
        await _alertRepository.archiveAlertEvent(alertEvent.id);
      }

      emit(currentState.copyWith(
        alertEvents: [],
        successMessage: 'Tout l\'historique a été archivé',
      ));
    } catch (e) {
      emit(AlertError(message: 'Erreur lors de l\'archivage: ${e.toString()}'));
    }
  }

  void _changeTab(AlertChangeTab event, Emitter<AlertState> emit) {
    if (state is AlertLoaded) {
      final currentState = state as AlertLoaded;
      emit(currentState.copyWith(selectedTab: event.tabType));
    }
  }

  void _clearSuccessMessage(AlertClearSuccessMessage event, Emitter<AlertState> emit) {
    if (state is AlertLoaded) {
      final currentState = state as AlertLoaded;
      emit(currentState.copyWith(clearSuccessMessage: true));
    }
  }

  void _showAddView(AlertShowAddView event, Emitter<AlertState> emit) {
    if (state is AlertLoaded) {
      final currentState = state as AlertLoaded;
      emit(currentState.copyWith(isShowingAddView: true));
    }
  }

  void _hideAddView(AlertHideAddView event, Emitter<AlertState> emit) {
    if (state is AlertLoaded) {
      final currentState = state as AlertLoaded;
      emit(currentState.copyWith(isShowingAddView: false));
    }
  }
}