import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/alert_models.dart';
import '../page/alerts_page.dart';
import '../repository/alert_repository.dart';
import '../widgets/button/tab_menu.dart';
import '../widgets/forms/sensors_section.dart';

part 'alert_event.dart';
part 'alert_state.dart';

class AlertBloc extends Bloc<AlertBlocEvent, AlertState> {
  final AlertRepository _alertRepository;

  AlertBloc() : _alertRepository = AlertRepository(), super(AlertInitial()) {
    // Chargement
    on<AlertLoadData>(_loadData);
    on<AlertLoadCells>(_loadCells);

    // Navigation entre vues
    on<AlertShowAddView>(_showAddView);
    on<AlertHideAddView>(_hideAddView);
    on<AlertShowEditView>(_showEditView);

    // CRUD alertes
    on<AlertValidateAlert>(_validateAlert);
    on<AlertConfirmCreate>(_confirmCreate);
    on<AlertCancelCreate>(_cancelCreate);
    on<AlertCreateAlert>(_createAlert);
    on<AlertValidateUpdate>(_validateUpdate);
    on<AlertConfirmUpdate>(_confirmUpdate);
    on<AlertCancelUpdate>(_cancelUpdate);
    on<AlertUpdateAlert>(_updateAlert);
    on<AlertDeleteAlert>(_deleteAlert);
    on<AlertToggleStatus>(_toggleStatus);

    // Archivage événements
    on<AlertDeleteEvent>(_deleteEvent);
    on<AlertArchiveAll>(_archiveAll);
    on<AlertArchiveByCell>(_archiveByCell);

    // UI
    on<AlertChangeDisplayMode>(_changeDisplayMode);
    on<AlertChangeTab>(_changeTab);
    on<AlertUpdateSensors>(_updateSensors);
    on<AlertUpdateCriticalRange>(_updateCriticalRange);
    on<AlertUpdateWarningRange>(_updateWarningRange);
    on<AlertUpdateWarningEnabled>(_updateWarningEnabled);

    // Messages
    on<AlertClearSuccessMessage>(_clearSuccessMessage);
    on<AlertClearErrorMessage>(_clearErrorMessage);
    on<AlertPushError>(_pushError);
  }

  // -- Helpers --

  // Vérifie que le state est AlertLoaded, retourne null sinon
  AlertLoaded? _loaded() => state is AlertLoaded ? state as AlertLoaded : null;

  // Recharge la liste des alertes depuis l'API
  Future<(List<Alert>, List<SensorAlertData>)> _fetchAlerts() async {
    final rawAlerts = await _alertRepository.fetchAlerts();
    // On exclut les alertes qui n'ont aucun capteur affichable (ex: alertes batterie uniquement)
    final alerts = rawAlerts.where((a) => a.sensors.isNotEmpty).toList();
    final sensorAlerts = alerts.expand((a) => a.sensors).toList();
    return (alerts, sensorAlerts);
  }

  // -- Chargement --

  Future<void> _loadData(AlertLoadData event, Emitter<AlertState> emit) async {
    emit(AlertLoading());
    try {
      // Tous les fetch en parallèle pour minimiser le temps de chargement initial
      final results = await Future.wait([
        _alertRepository.fetchAlerts(),
        _alertRepository.fetchAlertHistory(),
        _alertRepository.fetchSpaces(),
        _alertRepository
            .fetchCells(), // préchargé ici pour éviter le délai en édition/ajout
      ]);

      final rawAlerts = results[0] as List<Alert>;
      // On exclut les alertes qui n'ont aucun capteur affichable (ex: alertes batterie uniquement)
      final alerts = rawAlerts.where((a) => a.sensors.isNotEmpty).toList();
      final sensorAlerts = alerts.expand((a) => a.sensors).toList();
      final alertEvents = results[1] as List<AlertEvent>;
      final spaces = results[2] as List<Map<String, dynamic>>;
      final cells = results[3] as List<CellItem>;

      emit(
        AlertLoaded(
          alerts: alerts,
          sensorAlerts: sensorAlerts,
          alertEvents: alertEvents,
          displayMode: DisplayMode.list,
          selectedTab: AlertTabType.alerts,
          spaces: spaces,
          cells: cells,
        ),
      );
    } catch (e) {
      emit(AlertError(message: e.toString()));
    }
  }

  Future<void> _loadCells(
    AlertLoadCells event,
    Emitter<AlertState> emit,
  ) async {
    final s = _loaded();
    if (s == null) return;
    try {
      final cells = await _alertRepository.fetchCells();
      emit(s.copyWith(cells: cells));
    } catch (_) {}
  }

  // -- Navigation --

  void _showAddView(AlertShowAddView event, Emitter<AlertState> emit) {
    final s = _loaded();
    if (s == null) return;
    // Les cellules sont préchargées dans _loadData, pas besoin de les recharger
    emit(
      s.copyWith(
        isShowingAddView: true,
        isShowingEditView: false,
        selectedSensors: const [],
        criticalRanges: const {},
        warningRanges: const {},
      ),
    );
  }

  void _hideAddView(AlertHideAddView event, Emitter<AlertState> emit) {
    final s = _loaded();
    if (s == null) return;
    emit(s.copyWith(isShowingAddView: false, isShowingEditView: false));
  }

  Future<void> _showEditView(
    AlertShowEditView event,
    Emitter<AlertState> emit,
  ) async {
    final s = _loaded();
    if (s == null) return;

    // Récupère l'alerte depuis la liste locale ou crée un placeholder
    final alert = s.alerts.firstWhere(
      (a) => a.id == event.alertId,
      orElse:
          () => Alert(
            id: event.alertId,
            title: 'Alerte inconnue',
            isActive: false,
            sensors: [],
            warningEnabled: true,
          ),
    );

    // Emit intermédiaire : bascule vers la vue d'édition en vidant les données
    // de l'édition précédente pour éviter un flash avec les mauvaises infos
    emit(
      s.copyWith(
        isShowingEditView: true,
        isShowingAddView: false,
        editingAlertId: event.alertId,
        clearEditingAlert: true,
        clearAlertDetails: true,
        selectedSensors: const [],
        criticalRanges: const {},
        warningRanges: const {},
      ),
    );

    // Charge les détails de l'alerte, et les cellules seulement si pas encore chargées
    final hasCells = s.cells.isNotEmpty;
    final results = await Future.wait([
      _alertRepository.fetchAlertDetails(event.alertId),
      if (!hasCells) _alertRepository.fetchCells(),
    ]);

    final details = results[0] as Map<String, dynamic>;
    final cells = hasCells ? s.cells : results[1] as List<CellItem>;

    // Reconstruit les capteurs sélectionnés et leurs plages depuis l'API
    // La batterie est exclue : elle ne doit pas apparaître dans la configuration des alertes
    final sensorsData =
        (details['sensors'] as List<dynamic>? ?? [])
            .where((json) => (json['type'] as String?) != 'battery')
            .toList();
    final selectedSensors = <SelectedSensor>[];
    final criticalRanges = <String, RangeValues>{};
    final warningRanges = <String, RangeValues>{};

    for (final json in sensorsData) {
      final type = sensorTypeFromString(json['type'] as String);
      final index = (json['index'] as num).toInt();
      final sensorId = json['sensor_id'];
      final key = '${type.index}_$index';

      selectedSensors.add(SelectedSensor(type, index, sensorId));

      if (json['criticalRange'] != null) {
        final cr = json['criticalRange'] as Map<String, dynamic>;
        criticalRanges[key] = RangeValues(
          (cr['min'] as num).toDouble(),
          (cr['max'] as num).toDouble(),
        );
      }
      if (json['warningRange'] != null) {
        final wr = json['warningRange'] as Map<String, dynamic>;
        warningRanges[key] = RangeValues(
          (wr['min'] as num).toDouble(),
          (wr['max'] as num).toDouble(),
        );
      }
    }

    emit(
      s.copyWith(
        isShowingEditView: true,
        isShowingAddView: false,
        editingAlertId: event.alertId,
        editingAlert: alert,
        alertDetails: details,
        cells: cells,
        selectedSensors: selectedSensors,
        criticalRanges: criticalRanges,
        warningRanges: warningRanges,
        isWarningEnabled: details['warningEnabled'] as bool? ?? true,
      ),
    );
  }

  // -- CRUD Alertes --

  Future<void> _validateAlert(
    AlertValidateAlert event,
    Emitter<AlertState> emit,
  ) async {
    final s = _loaded();
    if (s == null) return;
    try {
      final sensorTypes =
          event.request.sensors.map((s) => s.type).toSet().toList();
      final validation = await _alertRepository.validateAlert(
        AlertValidationRequest(
          cellIds: event.request.cellIds,
          sensorTypes: sensorTypes,
        ),
      );

      if (validation.hasConflicts) {
        // Conflits détectés → on stocke la requête et on attend la décision de l'utilisateur
        emit(
          s.copyWith(
            pendingConflicts: validation.conflicts,
            pendingRequest: event.request,
          ),
        );
      } else {
        add(AlertCreateAlert(request: event.request));
      }
    } catch (e) {
      emit(s.copyWith(errorMessage: 'Erreur de validation : $e'));
    }
  }

  void _confirmCreate(AlertConfirmCreate event, Emitter<AlertState> emit) {
    final s = _loaded();
    if (s == null) return;
    final pending = s.pendingRequest;
    if (pending == null) return;

    // Vide les conflits puis envoie la création avec le flag overwrite
    emit(s.copyWith(clearPendingConflicts: true, clearPendingRequest: true));
    add(
      AlertCreateAlert(
        request: pending.copyWith(overwriteExisting: event.overwrite),
      ),
    );
  }

  void _cancelCreate(AlertCancelCreate event, Emitter<AlertState> emit) {
    final s = _loaded();
    if (s == null) return;
    emit(s.copyWith(clearPendingConflicts: true, clearPendingRequest: true));
  }

  Future<void> _createAlert(
    AlertCreateAlert event,
    Emitter<AlertState> emit,
  ) async {
    final s = _loaded();
    if (s == null) return;
    try {
      await _alertRepository.createAlert(event.request);
      final (alerts, sensorAlerts) = await _fetchAlerts();
      emit(
        s.copyWith(
          alerts: alerts,
          sensorAlerts: sensorAlerts,
          isShowingAddView: false,
          isShowingEditView: false,
          clearEditingAlert: true,
          clearAlertDetails: true,
          successMessage: 'Alerte créée avec succès',
          clearPendingConflicts: true,
          clearPendingRequest: true,
        ),
      );
    } catch (e) {
      emit(
        s.copyWith(
          errorMessage: 'Erreur lors de la création : $e',
          clearPendingConflicts: true,
          clearPendingRequest: true,
        ),
      );
    }
  }

  Future<void> _validateUpdate(
    AlertValidateUpdate event,
    Emitter<AlertState> emit,
  ) async {
    final s = _loaded();
    if (s == null) return;
    try {
      final sensorTypes =
          event.request.sensors.map((s) => s.type).toSet().toList();
      final validation = await _alertRepository.validateAlert(
        AlertValidationRequest(
          cellIds: event.request.cellIds,
          sensorTypes: sensorTypes,
        ),
      );

      // Filtre les conflits qui ne concernent pas l'alerte en cours d'édition
      final filteredConflicts =
          validation.conflicts
              .where((c) => c.existingAlertId != event.alertId)
              .toList();

      if (filteredConflicts.isNotEmpty) {
        // Conflits détectés → stocke la requête et attend la décision
        emit(
          s.copyWith(
            pendingConflicts: filteredConflicts,
            pendingRequest: event.request,
            editingAlertId: event.alertId,
          ),
        );
      } else {
        add(AlertUpdateAlert(alertId: event.alertId, request: event.request));
      }
    } catch (e) {
      emit(s.copyWith(errorMessage: 'Erreur de validation : $e'));
    }
  }

  void _confirmUpdate(AlertConfirmUpdate event, Emitter<AlertState> emit) {
    final s = _loaded();
    if (s == null) return;
    final pending = s.pendingRequest;
    final alertId = s.editingAlertId;
    if (pending == null || alertId == null) return;

    emit(s.copyWith(clearPendingConflicts: true, clearPendingRequest: true));
    add(
      AlertUpdateAlert(
        alertId: alertId,
        request: pending.copyWith(overwriteExisting: event.overwrite),
      ),
    );
  }

  void _cancelUpdate(AlertCancelUpdate event, Emitter<AlertState> emit) {
    final s = _loaded();
    if (s == null) return;
    emit(s.copyWith(clearPendingConflicts: true, clearPendingRequest: true));
  }

  Future<void> _updateAlert(
    AlertUpdateAlert event,
    Emitter<AlertState> emit,
  ) async {
    final s = _loaded();
    if (s == null) return;
    try {
      await _alertRepository.updateAlert(event.alertId, event.request);
      final (alerts, sensorAlerts) = await _fetchAlerts();
      emit(
        s.copyWith(
          alerts: alerts,
          sensorAlerts: sensorAlerts,
          isShowingEditView: false,
          successMessage: 'Alerte mise à jour avec succès',
        ),
      );
    } catch (e) {
      emit(s.copyWith(errorMessage: 'Erreur lors de la mise à jour : $e'));
    }
  }

  Future<void> _deleteAlert(
    AlertDeleteAlert event,
    Emitter<AlertState> emit,
  ) async {
    final s = _loaded();
    if (s == null) return;
    try {
      await _alertRepository.deleteAlert(event.alertId);
      emit(
        s.copyWith(
          alerts: s.alerts.where((a) => a.id != event.alertId).toList(),
          sensorAlerts:
              s.sensorAlerts.where((a) => a.id != event.alertId).toList(),
          isShowingEditView: false,
          successMessage: 'Alerte supprimée avec succès',
        ),
      );
    } catch (e) {
      emit(s.copyWith(errorMessage: 'Erreur lors de la suppression : $e'));
    }
  }

  Future<void> _toggleStatus(
    AlertToggleStatus event,
    Emitter<AlertState> emit,
  ) async {
    final s = _loaded();
    if (s == null) return;
    try {
      await _alertRepository.toggleAlert(event.alertId, event.isActive);
      emit(
        s.copyWith(
          alerts:
              s.alerts
                  .map(
                    (a) =>
                        a.id == event.alertId
                            ? Alert(
                              id: a.id,
                              title: a.title,
                              isActive: event.isActive,
                              sensors: a.sensors,
                              warningEnabled: a.warningEnabled,
                            )
                            : a,
                  )
                  .toList(),
          sensorAlerts:
              s.sensorAlerts
                  .map(
                    (a) =>
                        a.id == event.alertId
                            ? a.copyWith(isEnabled: event.isActive)
                            : a,
                  )
                  .toList(),
          successMessage: 'Statut mis à jour',
        ),
      );
    } catch (e) {
      emit(
        s.copyWith(
          errorMessage: 'Erreur lors de la mise à jour du statut : $e',
        ),
      );
    }
  }

  // -- Archivage événements --

  Future<void> _deleteEvent(
    AlertDeleteEvent event,
    Emitter<AlertState> emit,
  ) async {
    final s = _loaded();
    if (s == null) return;
    try {
      await _alertRepository.archiveAlertEvent(event.eventId);
      emit(
        s.copyWith(
          alertEvents:
              s.alertEvents.where((e) => e.id != event.eventId).toList(),
          successMessage: 'Événement archivé',
        ),
      );
    } catch (e) {
      emit(s.copyWith(errorMessage: 'Erreur lors de l\'archivage : $e'));
    }
  }

  Future<void> _archiveAll(
    AlertArchiveAll event,
    Emitter<AlertState> emit,
  ) async {
    final s = _loaded();
    if (s == null) return;
    if (s.alertEvents.isEmpty) return;
    try {
      await _alertRepository.archiveAllAlertEvents();
      emit(
        s.copyWith(
          alertEvents: [],
          successMessage: '${s.alertEvents.length} événement(s) archivé(s)',
        ),
      );
    } catch (e) {
      emit(s.copyWith(errorMessage: 'Erreur lors de l\'archivage : $e'));
    }
  }

  Future<void> _archiveByCell(
    AlertArchiveByCell event,
    Emitter<AlertState> emit,
  ) async {
    final s = _loaded();
    if (s == null) return;
    try {
      await _alertRepository.archiveAlertEventsByCell(event.cellId);
      final updated =
          s.alertEvents.where((e) => e.cellId != event.cellId).toList();
      final count = s.alertEvents.length - updated.length;
      emit(
        s.copyWith(
          alertEvents: updated,
          successMessage: '$count événement(s) archivé(s)',
        ),
      );
    } catch (e) {
      emit(
        s.copyWith(
          errorMessage: 'Erreur lors de l\'archivage par cellule : $e',
        ),
      );
    }
  }

  // -- UI --

  void _changeDisplayMode(
    AlertChangeDisplayMode event,
    Emitter<AlertState> emit,
  ) {
    final s = _loaded();
    if (s == null) return;
    emit(s.copyWith(displayMode: event.displayMode));
  }

  void _changeTab(AlertChangeTab event, Emitter<AlertState> emit) {
    final s = _loaded();
    if (s == null) return;
    emit(s.copyWith(selectedTab: event.tabType));
  }

  void _updateSensors(AlertUpdateSensors event, Emitter<AlertState> emit) {
    final s = _loaded();
    if (s == null) return;

    final critical = Map<String, RangeValues>.from(s.criticalRanges);
    final warning = Map<String, RangeValues>.from(s.warningRanges);

    // Initialise les plages des nouveaux capteurs avec les valeurs par défaut
    for (final sensor in event.sensors) {
      final key = '${sensor.type.index}_${sensor.index}';
      critical.putIfAbsent(key, () => sensor.type.defaultCriticalRange);
      warning.putIfAbsent(key, () => sensor.type.defaultWarningRange);
    }

    // Supprime les plages des capteurs retirés
    critical.removeWhere(
      (key, _) =>
          !event.sensors.any((s) => '${s.type.index}_${s.index}' == key),
    );
    warning.removeWhere(
      (key, _) =>
          !event.sensors.any((s) => '${s.type.index}_${s.index}' == key),
    );

    emit(
      s.copyWith(
        selectedSensors: event.sensors,
        criticalRanges: critical,
        warningRanges: warning,
      ),
    );
  }

  void _updateCriticalRange(
    AlertUpdateCriticalRange event,
    Emitter<AlertState> emit,
  ) {
    final s = _loaded();
    if (s == null) return;
    final key = '${event.sensor.type.index}_${event.sensor.index}';
    emit(s.copyWith(criticalRanges: {...s.criticalRanges, key: event.range}));
  }

  void _updateWarningRange(
    AlertUpdateWarningRange event,
    Emitter<AlertState> emit,
  ) {
    final s = _loaded();
    if (s == null) return;
    final key = '${event.sensor.type.index}_${event.sensor.index}';
    emit(s.copyWith(warningRanges: {...s.warningRanges, key: event.range}));
  }

  void _updateWarningEnabled(
    AlertUpdateWarningEnabled event,
    Emitter<AlertState> emit,
  ) {
    final s = _loaded();
    if (s == null) return;
    emit(s.copyWith(isWarningEnabled: event.enabled));
  }

  // -- Messages --

  void _clearSuccessMessage(
    AlertClearSuccessMessage event,
    Emitter<AlertState> emit,
  ) {
    final s = _loaded();
    if (s == null) return;
    emit(s.copyWith(clearSuccessMessage: true));
  }

  void _clearErrorMessage(
    AlertClearErrorMessage event,
    Emitter<AlertState> emit,
  ) {
    final s = _loaded();
    if (s == null) return;
    emit(s.copyWith(clearErrorMessage: true));
  }

  void _pushError(AlertPushError event, Emitter<AlertState> emit) {
    final s = _loaded();
    if (s == null) return;
    emit(s.copyWith(errorMessage: event.message));
  }
}
