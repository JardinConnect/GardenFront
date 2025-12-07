import '../models/alert_models.dart';

/// Repository pour la gestion des données d'alertes
class AlertRepository {
  /// Récupère les alertes simples pour l'affichage en liste
  Future<List<Alert>> getAlertsForListView() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      var response = {
        "alerts": [
          {
            "id": "1",
            "title": "Alerte température",
            "description": "Surveillance de la température dans les serres",
            "isActive": true,
            "sensorTypes": ["temperature"]
          },
          {
            "id": "2", 
            "title": "Alerte humidité complète",
            "description": "Contrôle humidité surface et profondeur",
            "isActive": true,
            "sensorTypes": ["humiditySurface", "humidityDepth"]
          },
          {
            "id": "3",
            "title": "Alerte conditions climatiques", 
            "description": "Surveillance complète des conditions",
            "isActive": false,
            "sensorTypes": ["temperature", "light", "rain"]
          },
          {
            "id": "4",
            "title": "Alerte luminosité",
            "description": "Contrôle de l'éclairage optimal",
            "isActive": false,
            "sensorTypes": ["light"]
          },
          {
            "id": "5",
            "title": "Alerte pluviosité",
            "description": "Surveillance des précipitations", 
            "isActive": false,
            "sensorTypes": ["rain"]
          }
        ]
      };

      return (response['alerts'] as List).map((alertJson) => Alert.fromJson(alertJson)).toList();
    } catch (e) {
      throw Exception('Failed to load alerts for list view: $e');
    }
  }

  /// Récupère les données détaillées des capteurs pour l'affichage en cards
  Future<List<SensorAlertData>> getSensorAlertsForCardView() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      var response = {
        "sensorAlerts": [
          {
            "id": "1",
            "title": "Alerte température",
            "sensorType": "temperature",
            "threshold": {
              "thresholds": [
                {"value": 25.0, "unit": "°C", "label": "maximale", "alertType": "warning"},
                {"value": 18.0, "unit": "°C", "label": "minimale", "alertType": "warning"},
                {"value": 22.0, "unit": "°C", "label": "optimale", "alertType": "none"}
              ]
            },
            "isEnabled": true
          },
          {
            "id": "2",
            "title": "Alerte humidité surface",
            "sensorType": "humiditySurface",
            "threshold": {
              "thresholds": [
                {"value": 85.0, "unit": "%", "label": "maximale", "alertType": "warning"},
                {"value": 65.0, "unit": "%", "label": "optimale", "alertType": "none"},
                {"value": 40.0, "unit": "%", "label": "minimale", "alertType": "warning"}
              ]
            },
            "isEnabled": true
          },
          {
            "id": "3", 
            "title": "Alerte humidité profondeur",
            "sensorType": "humidityDepth",
            "threshold": {
              "thresholds": [
                {"value": 90.0, "unit": "%", "label": "maximale", "alertType": "warning"},
                {"value": 70.0, "unit": "%", "label": "optimale", "alertType": "none"},
                {"value": 50.0, "unit": "%", "label": "minimale", "alertType": "warning"}
              ]
            },
            "isEnabled": false
          },
          {
            "id": "4",
            "title": "Alerte luminosité",
            "sensorType": "light",
            "threshold": {
              "thresholds": [
                {"value": 5000.0, "unit": " lux", "label": "optimale", "alertType": "none"},
                {"value": 1000.0, "unit": " lux", "label": "minimale", "alertType": "warning"}
              ]
            },
            "isEnabled": false
          },
          {
            "id": "5",
            "title": "Alerte pluviosité",
            "sensorType": "rain", 
            "threshold": {
              "thresholds": [
                {"value": 100.0, "unit": " mm", "label": "maximale", "alertType": "warning"},
                {"value": 0.0, "unit": " mm", "label": "minimale", "alertType": "none"}
              ]
            },
            "isEnabled": false
          }
        ]
      };

      return (response['sensorAlerts'] as List).map((alertJson) => SensorAlertData.fromJson(alertJson)).toList();
    } catch (e) {
      throw Exception('Failed to load sensor alerts for card view: $e');
    }
  }

  /// Récupère les événements d'alerte pour l'historique
  Future<List<AlertEvent>> getAlertHistory() async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    try {
      var response = {
        "alertEvents": [
          {
            "id": "1",
            "value": "26°C",
            "sensorType": "temperature",
            "cellName": "Cellule 2",
            "time": "16h45",
            "date": "07/12/2025",
            "location": "Parcelle1 > Serre 2 > Chappelle 5 > planche 19"
          },
          {
            "id": "2",
            "value": "88%",
            "sensorType": "humiditySurface",
            "cellName": "Cellule 5", 
            "time": "14h30",
            "date": "07/12/2025",
            "location": "Parcelle2 > Serre 1 > Chappelle 3 > planche 8"
          },
          {
            "id": "3",
            "value": "800 lux",
            "sensorType": "light",
            "cellName": "Cellule 1",
            "time": "12h15", 
            "date": "06/12/2025",
            "location": "Parcelle1 > Serre 3 > Chappelle 2 > planche 4"
          },
          {
            "id": "4",
            "value": "38%",
            "sensorType": "humiditySurface",
            "cellName": "Cellule 3",
            "time": "10h20",
            "date": "06/12/2025",
            "location": "Parcelle1 > Serre 1 > Chappelle 1 > planche 12"
          },
          {
            "id": "5", 
            "value": "17°C",
            "sensorType": "temperature",
            "cellName": "Cellule 4",
            "time": "08h05",
            "date": "05/12/2025",
            "location": "Parcelle2 > Serre 2 > Chappelle 4 > planche 6"
          },
          {
            "id": "6",
            "value": "95%",
            "sensorType": "humidityDepth",
            "cellName": "Cellule 1",
            "time": "22h30",
            "date": "04/12/2025", 
            "location": "Parcelle1 > Serre 3 > Chappelle 2 > planche 4"
          }
        ]
      };

      return (response['alertEvents'] as List).map((eventJson) => AlertEvent.fromJson(eventJson)).toList();
    } catch (e) {
      throw Exception('Failed to load alert history: $e');
    }
  }

  /// Met à jour l'état d'activation d'une alerte
  Future<bool> updateAlertStatus(String alertId, bool isEnabled) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      return true;
    } catch (e) {
      throw Exception('Failed to update alert status: $e');
    }
  }

  /// Archive un événement d'alerte de l'historique
  Future<bool> archiveAlertEvent(String eventId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      return true;
    } catch (e) {
      throw Exception('Failed to archive alert event: $e');
    }
  }
}
