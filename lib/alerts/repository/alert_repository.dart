import 'dart:convert';

import '../models/alert_models.dart';
import '../../auth/utils/http_client.dart';
import 'mock_data.dart';

/// Repository pour la gestion des données d'alertes
/// Centralise tous les appels API liés aux alertes
class AlertRepository {
  final HttpClient _httpClient = HttpClient();

  /// Récupère la liste complète des alertes depuis l'API
  Future<List<Alert>> fetchAlerts() async {
    try {
      final response = await _httpClient.get("/alert");
      final jsonData = jsonDecode(response.body);
      return (jsonData as List).map((json) => Alert.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des alertes: $e');
    }
  }

  /// Active ou désactive une alerte spécifique
  Future<bool> toggleAlert(String alertId, bool isActive) async {
    try {
      final response = await _httpClient.patch(
        "/alert/$alertId/toggle",
        body: {"isActive": isActive},
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Erreur lors du toggle de l\'alerte: $e');
    }
  }

  /// Récupère l'historique complet des événements d'alerte
  Future<List<AlertEvent>> fetchAlertHistory() async {
    try {
      final response = await _httpClient.get("/alert/events/");
      final jsonData = jsonDecode(response.body);
      return (jsonData as List)
          .map((json) => AlertEvent.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'historique: $e');
    }
  }

  /// Archive un événement d'alerte spécifique
  Future<bool> archiveAlertEvent(String eventId) async {
    try {
      final response = await _httpClient.patch(
        "/alert/events/$eventId/archive",
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Erreur lors de l\'archivage de l\'événement: $e');
    }
  }

  /// Archive tous les événements d'alerte
  Future<int> archiveAllAlertEvents() async {
    try {
      final response = await _httpClient.post("/alert/events/archive-all");
      return response.statusCode == 200 ? 1 : 0;
    } catch (e) {
      throw Exception('Erreur lors de l\'archivage de tous les événements: $e');
    }
  }

  /// Archive tous les événements d'une cellule spécifique
  Future<int> archiveAlertEventsByCell(String cellId) async {
    try {
      final response = await _httpClient.post(
        "/alert/events/archive-by-cell",
        body: {"cellId": cellId},
      );
      return response.statusCode == 200 ? 1 : 0;
    } catch (e) {
      throw Exception('Erreur lors de l\'archivage par cellule: $e');
    }
  }

  /// Vérifie les conflits avant de créer une alerte (POST /alert/validate)
  Future<AlertValidationResponse> validateAlert(
    AlertValidationRequest request,
  ) async {
    try {
      final response = await _httpClient.post(
        "/alert/validate",
        body: request.toJson(),
      );
      final jsonData = jsonDecode(response.body);
      return AlertValidationResponse.fromJson(jsonData);
    } catch (e) {
      throw Exception('Erreur lors de la validation de l\'alerte: $e');
    }
  }

  /// Créer une alerte
  Future<String> createAlert(AlertCreationRequest request) async {
    try {
      final response = await _httpClient.post("/alert", body: request.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        return jsonData['id'] ??
            'alert_${DateTime.now().millisecondsSinceEpoch}';
      }
      throw Exception(
        'Erreur lors de la création de l\'alerte: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'alerte: $e');
    }
  }

  /// Récupère la liste des cellules disponibles depuis GET /cell/
  Future<List<CellItem>> fetchCells() async {
    try {
      final response = await _httpClient.get("/cell/");
      final jsonData = jsonDecode(response.body);
      return (jsonData as List).map((json) => CellItem.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des cellules: $e');
    }
  }

  /// Récupère la liste complète des espaces avec leur localisation hiérarchique
  Future<List<Map<String, dynamic>>> fetchSpaces() async {
    // TODO: Remplacer par un vrai appel HTTP
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return AlertMockData.spaces;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des espaces: $e');
    }
  }

  /// Retourne la liste des types de capteurs disponibles (basée sur l'enum SensorType)
  Future<List<Map<String, dynamic>>> fetchAvailableSensors() async {
    return [
      {"type": "airTemperature", "displayName": "Température air", "index": 0},
      {"type": "soilTemperature", "displayName": "Température sol", "index": 0},
      {
        "type": "humiditySurface",
        "displayName": "Humidité surface",
        "index": 0,
      },
      {
        "type": "humidityDepth",
        "displayName": "Humidité profondeur",
        "index": 0,
      },
      {"type": "light", "displayName": "Luminosité", "index": 0},
      {"type": "rain", "displayName": "Humidité air", "index": 0},
    ];
  }

  /// Récupère les détails complets d'une alerte depuis GET /alert/{id}
  Future<Map<String, dynamic>> fetchAlertDetails(String alertId) async {
    try {
      final response = await _httpClient.get("/alert/$alertId");
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception(
        'Erreur lors de la récupération des détails de l\'alerte: $e',
      );
    }
  }

  /// Met à jour une alerte existante via PUT /alert/{id}
  /// TODO : En attente du fix backend afin de valider le dev de cette fonctionnalité
  Future<void> updateAlert(String alertId, AlertCreationRequest request) async {
    try {
      final response = await _httpClient.put(
        "/alert/$alertId",
        body: request.toJson(),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erreur HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de l\'alerte: $e');
    }
  }

  /// Supprime une alerte définitivement via DELETE /alert/{id}
  Future<bool> deleteAlert(String alertId) async {
    try {
      final response = await _httpClient.delete("/alert/$alertId");
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'alerte: $e');
    }
  }
}
