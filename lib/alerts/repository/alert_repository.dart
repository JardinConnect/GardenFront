import '../models/alert_models.dart';
import 'mock_data.dart';

/// Repository pour la gestion des données d'alertes
/// Centralise tous les appels API liés aux alertes
class AlertRepository {
  // TODO: Injecter le client HTTP (Dio, http, etc.) via le constructeur
  // final HttpClient _httpClient;

  /// Récupère la liste complète des alertes depuis l'API
  Future<List<Alert>> fetchAlerts() async {
    // TODO: Remplacer par un vrai appel HTTP
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return (AlertMockData.alerts)
          .map((alertJson) => Alert.fromJson(alertJson))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des alertes: $e');
    }
  }

  /// Récupère les données détaillées des capteurs avec leurs seuils
  Future<List<SensorAlertData>> fetchSensorAlerts() async {
    // TODO: Remplacer par un vrai appel HTTP
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return (AlertMockData.sensorAlerts)
          .map((alertJson) => SensorAlertData.fromJson(alertJson))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des alertes capteurs: $e');
    }
  }

  /// Récupère l'historique complet des événements d'alerte
  Future<List<AlertEvent>> fetchAlertHistory() async {
    // TODO: Remplacer par un vrai appel HTTP
    await Future.delayed(const Duration(milliseconds: 400));

    try {
      return (AlertMockData.alertHistory)
          .map((eventJson) => AlertEvent.fromJson(eventJson))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'historique: $e');
    }
  }

  /// Active ou désactive une alerte spécifique
  Future<bool> toggleAlert(String alertId, bool isActive) async {
    // TODO: Remplacer par un vrai appel HTTP
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  /// Archive un événement d'alerte spécifique
  Future<bool> archiveAlertEvent(String eventId) async {
    // TODO: Remplacer par un vrai appel HTTP
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  /// Archive tous les événements d'alerte
  Future<int> archiveAllAlertEvents() async {
    // TODO: Remplacer par un vrai appel HTTP
    await Future.delayed(const Duration(milliseconds: 500));
    return 0;
  }

  /// Archive tous les événements d'une cellule spécifique
  Future<int> archiveAlertEventsByCell(String cellId) async {
    // TODO: Remplacer par un vrai appel HTTP
    await Future.delayed(const Duration(milliseconds: 400));
    return 0;
  }

  /// Récupère la liste des cellules disponibles
  Future<List<Map<String, dynamic>>> fetchCells() async {
    // TODO: Remplacer par un vrai appel HTTP
    await Future.delayed(const Duration(milliseconds: 300));
    return AlertMockData.cells;
  }

  /// Récupère la liste complète des espaces avec leur localisation hiérarchique
  Future<List<Space>> fetchSpaces() async {
    // TODO: Remplacer par un vrai appel HTTP

    try {
      return AlertMockData.spaces
          .map((spaceJson) => Space.fromJson(spaceJson))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des espaces: $e');
    }
  }

  /// Récupère la liste des types de capteurs disponibles
  Future<List<Map<String, dynamic>>> fetchAvailableSensors() async {
    // TODO: Remplacer par un vrai appel HTTP
    return AlertMockData.availableSensors;
  }

  /// Crée une nouvelle alerte
  Future<String> createAlert({
    required String name,
    required List<String> cellIds,
    required Map<String, dynamic> sensors,
    required bool isWarningEnabled,
  }) async {
    // TODO: Remplacer par un vrai appel HTTP
    await Future.delayed(const Duration(milliseconds: 500));
    return 'alert_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Récupère les détails complets d'une alerte pour modification/visualisation
  Future<Map<String, dynamic>> fetchAlertDetails(String alertId) async {
    // TODO: Remplacer par un vrai appel HTTP
    await Future.delayed(const Duration(milliseconds: 400));
    return AlertMockData.alertDetails(alertId);
  }

  /// Supprime une alerte définitivement
  Future<bool> deleteAlert(String alertId) async {
    // TODO: Remplacer par un vrai appel HTTP
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}


