import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../models/alert_models.dart';
import '../page/alerts_page.dart';
import '../repository/alert_repository.dart';
import '../widgets/button/tab_menu.dart';

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
    on<AlertArchiveByCell>(_archiveByCell);
    on<AlertChangeTab>(_changeTab);
    on<AlertClearSuccessMessage>(_clearSuccessMessage);
    on<AlertShowAddView>(_showAddView);
    on<AlertHideAddView>(_hideAddView);
    on<AlertShowEditView>(_showEditView);
    on<AlertDeleteAlert>(_deleteAlert);

    // Charger les données initiales
    add(AlertLoadData());
  }

  Future<void> _loadData(AlertLoadData event, Emitter<AlertState> emit) async {
    emit(AlertLoading());
    try {
      // Récupération des données depuis le repository
      final alerts = await _alertRepository.fetchAlerts();
      final sensorAlerts = await _alertRepository.fetchSensorAlerts();
      final alertEvents = await _alertRepository.fetchAlertHistory();

      emit(
        AlertLoaded(
          alerts: alerts,
          sensorAlerts: sensorAlerts,
          alertEvents: alertEvents,
          displayMode: DisplayMode.list,
          selectedTab: AlertTabType.alerts,
        ),
      );
    } catch (e) {
      emit(AlertError(message: e.toString()));
    }
  }

  void _changeDisplayMode(
    AlertChangeDisplayMode event,
    Emitter<AlertState> emit,
  ) {
    if (state is AlertLoaded) {
      final currentState = state as AlertLoaded;
      emit(currentState.copyWith(displayMode: event.displayMode));
    }
  }

  Future<void> _toggleStatus(
    AlertToggleStatus event,
    Emitter<AlertState> emit,
  ) async {
    if (state is! AlertLoaded) return;

    final currentState = state as AlertLoaded;

    try {
      // Appel au repository pour activer/désactiver l'alerte
      await _alertRepository.toggleAlert(event.alertId, event.isActive);

      // Mettre à jour les alerts dans la liste
      final updatedAlerts =
          currentState.alerts.map((alert) {
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
      final updatedSensorAlerts =
          currentState.sensorAlerts.map((sensorAlert) {
            if (sensorAlert.id == event.alertId) {
              return sensorAlert.copyWith(isEnabled: event.isActive);
            }
            return sensorAlert;
          }).toList();

      emit(
        currentState.copyWith(
          alerts: updatedAlerts,
          sensorAlerts: updatedSensorAlerts,
          successMessage: 'Statut de l\'alerte mis à jour',
        ),
      );
    } catch (e) {
      emit(
        AlertError(message: 'Erreur lors de la mise à jour: ${e.toString()}'),
      );
    }
  }

  /// Gère l'archivage d'un événement d'alerte spécifique
  Future<void> _deleteEvent(
    AlertDeleteEvent event,
    Emitter<AlertState> emit,
  ) async {
    if (state is! AlertLoaded) return;

    final currentState = state as AlertLoaded;

    try {
      // Appel au repository pour archiver l'événement
      await _alertRepository.archiveAlertEvent(event.eventId);

      // Retirer l'événement de la liste locale
      final updatedEvents =
          currentState.alertEvents
              .where((alertEvent) => alertEvent.id != event.eventId)
              .toList();

      emit(
        currentState.copyWith(
          alertEvents: updatedEvents,
          successMessage: 'Événement archivé avec succès',
        ),
      );
    } catch (e) {
      emit(AlertError(message: 'Erreur lors de l\'archivage: ${e.toString()}'));
    }
  }

  /// Gère l'archivage de tous les événements d'alerte
  Future<void> _archiveAll(
    AlertArchiveAll event,
    Emitter<AlertState> emit,
  ) async {
    if (state is! AlertLoaded) return;

    final currentState = state as AlertLoaded;

    // Vérifier qu'il y a des événements à archiver
    if (currentState.alertEvents.isEmpty) {
      return;
    }

    try {
      // Appel au repository pour archiver tous les événements
      final archivedCount = await _alertRepository.archiveAllAlertEvents();

      emit(
        currentState.copyWith(
          alertEvents: [],
          successMessage:
              'Tous les événements ont été archivés (${currentState.alertEvents.length} événements)',
        ),
      );
    } catch (e) {
      emit(AlertError(message: 'Erreur lors de l\'archivage: ${e.toString()}'));
    }
  }

  /// Gère l'archivage de tous les événements d'une cellule spécifique
  Future<void> _archiveByCell(
    AlertArchiveByCell event,
    Emitter<AlertState> emit,
  ) async {
    if (state is! AlertLoaded) return;

    final currentState = state as AlertLoaded;

    try {
      // Appel au repository pour archiver les événements de la cellule
      final archivedCount = await _alertRepository.archiveAlertEventsByCell(
        event.cellId,
      );

      // Retirer les événements de la cellule spécifique de la liste locale
      // Note: On suppose que cellName contient l'ID ou qu'on peut le déduire
      // TODO: Adapter selon la structure réelle de vos données
      final updatedEvents =
          currentState.alertEvents
              .where((alertEvent) => alertEvent.cellName != event.cellId)
              .toList();

      final removedCount =
          currentState.alertEvents.length - updatedEvents.length;

      emit(
        currentState.copyWith(
          alertEvents: updatedEvents,
          successMessage:
              '$removedCount événement(s) de la cellule archivé(s) avec succès',
        ),
      );
    } catch (e) {
      emit(
        AlertError(
          message: 'Erreur lors de l\'archivage par cellule: ${e.toString()}',
        ),
      );
    }
  }

  void _changeTab(AlertChangeTab event, Emitter<AlertState> emit) {
    if (state is AlertLoaded) {
      final currentState = state as AlertLoaded;
      emit(currentState.copyWith(selectedTab: event.tabType));
    }
  }

  void _clearSuccessMessage(
    AlertClearSuccessMessage event,
    Emitter<AlertState> emit,
  ) {
    if (state is AlertLoaded) {
      final currentState = state as AlertLoaded;
      emit(currentState.copyWith(clearSuccessMessage: true));
    }
  }

  void _showAddView(AlertShowAddView event, Emitter<AlertState> emit) {
    if (state is AlertLoaded) {
      final currentState = state as AlertLoaded;
      emit(
        currentState.copyWith(
          isShowingAddView: true,
          isShowingEditView: false,
          editingAlertId: null,
        ),
      );
    }
  }

  void _hideAddView(AlertHideAddView event, Emitter<AlertState> emit) {
    if (state is AlertLoaded) {
      final currentState = state as AlertLoaded;
      emit(
        currentState.copyWith(
          isShowingAddView: false,
          isShowingEditView: false,
          editingAlertId: null,
        ),
      );
    }
  }

  /// Affiche la vue d'édition d'une alerte
  void _showEditView(AlertShowEditView event, Emitter<AlertState> emit) {
    if (state is AlertLoaded) {
      final currentState = state as AlertLoaded;
      emit(
        currentState.copyWith(
          isShowingEditView: true,
          isShowingAddView: false,
          editingAlertId: event.alertId,
        ),
      );
    }
  }

  /// Gère la suppression d'une alerte
  Future<void> _deleteAlert(
    AlertDeleteAlert event,
    Emitter<AlertState> emit,
  ) async {
    if (state is! AlertLoaded) return;

    final currentState = state as AlertLoaded;

    try {
      // Appel au repository pour supprimer l'alerte
      await _alertRepository.deleteAlert(event.alertId);

      // Retirer l'alerte de la liste locale
      final updatedAlerts =
          currentState.alerts
              .where((alert) => alert.id != event.alertId)
              .toList();

      final updatedSensorAlerts =
          currentState.sensorAlerts
              .where((sensorAlert) => sensorAlert.id != event.alertId)
              .toList();

      emit(
        currentState.copyWith(
          alerts: updatedAlerts,
          sensorAlerts: updatedSensorAlerts,
          isShowingEditView: false,
          editingAlertId: null,
          successMessage: 'Alerte supprimée avec succès',
        ),
      );
    } catch (e) {
      emit(
        AlertError(
          message:
              'Erreur lors de la suppression de l\'alerte: ${e.toString()}',
        ),
      );
    }
  }
}
