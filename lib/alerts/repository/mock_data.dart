/// Données mockées pour le développement
/// À remplacer par de vrais appels API en production
class AlertMockData {
  /// Mock des alertes
  static const List<Map<String, dynamic>> alerts = [
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
  ];

  /// Mock des alertes capteurs avec seuils
  static const List<Map<String, dynamic>> sensorAlerts = [
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
  ];

  /// Mock de l'historique des événements d'alerte
  static const List<Map<String, dynamic>> alertHistory = [
    {
      "id": "1",
      "value": "26°C",
      "sensorType": "temperature",
      "cellName": "Cellule 2",
      "dateTime": "2025-12-07T16:45:00",
      "location": "Parcelle1 > Serre 2 > Chappelle 5 > planche 19"
    },
    {
      "id": "2",
      "value": "88%",
      "sensorType": "humiditySurface",
      "cellName": "Cellule 5",
      "dateTime": "2025-12-07T14:30:00",
      "location": "Parcelle2 > Serre 1 > Chappelle 3 > planche 8"
    },
    {
      "id": "3",
      "value": "800 lux",
      "sensorType": "light",
      "cellName": "Cellule 1",
      "dateTime": "2025-12-06T12:15:00",
      "location": "Parcelle1 > Serre 3 > Chappelle 2 > planche 4"
    },
    {
      "id": "4",
      "value": "38%",
      "sensorType": "humiditySurface",
      "cellName": "Cellule 3",
      "dateTime": "2025-12-06T10:20:00",
      "location": "Parcelle1 > Serre 1 > Chappelle 1 > planche 12"
    },
    {
      "id": "5",
      "value": "17°C",
      "sensorType": "temperature",
      "cellName": "Cellule 4",
      "dateTime": "2025-12-05T08:05:00",
      "location": "Parcelle2 > Serre 2 > Chappelle 4 > planche 6"
    },
    {
      "id": "6",
      "value": "95%",
      "sensorType": "humidityDepth",
      "cellName": "Cellule 1",
      "dateTime": "2025-12-04T22:30:00",
      "location": "Parcelle1 > Serre 3 > Chappelle 2 > planche 4"
    }
  ];

  /// Mock des cellules disponibles
  static const List<Map<String, dynamic>> cells = [
    {"id": "1", "name": "Cellule 1"},
    {"id": "2", "name": "Cellule 2"},
    {"id": "3", "name": "Cellule 3"},
    {"id": "4", "name": "Cellule 4"},
    {"id": "5", "name": "Cellule 5"},
  ];

  /// Mock des espaces avec hiérarchie complète
  static const List<Map<String, dynamic>> spaces = [
    {
      "id": "1",
      "name": "Cellule A",
      "serre": "Serre Principale",
      "chapelle": "Chapelle Nord",
      "planche": "Planche 01",
    },
    {
      "id": "2",
      "name": "Cellule B",
      "serre": "Serre Principale",
      "chapelle": "Chapelle Nord",
      "planche": "Planche 02",
    },
    {
      "id": "3",
      "name": "Cellule C",
      "serre": "Serre Principale",
      "chapelle": "Chapelle Sud",
      "planche": "Planche 15",
    },
    {
      "id": "4",
      "name": "Cellule D",
      "serre": "Serre Secondaire",
      "chapelle": "Chapelle Est",
      "planche": "Planche 19",
    },
    {
      "id": "5",
      "name": "Cellule E",
      "serre": "Serre Secondaire",
      "chapelle": "Chapelle Est",
      "planche": "Planche 20",
    },
    {
      "id": "6",
      "name": "Cellule F",
      "serre": "Serre Annexe",
      "chapelle": "Chapelle Unique",
      "planche": "Planche 05",
    },
  ];

  /// Mock des capteurs disponibles
  static const List<Map<String, dynamic>> availableSensors = [
    {"type": "temperature", "displayName": "Température rouge", "index": 0},
    {"type": "temperature", "displayName": "Température marron", "index": 1},
    {"type": "humiditySurface", "displayName": "Humidité surface", "index": 2},
    {"type": "humidityDepth", "displayName": "Humidité profondeur", "index": 3},
    {"type": "light", "displayName": "Luminosité", "index": 4},
    {"type": "rain", "displayName": "Pluie", "index": 5},
  ];

  /// Mock des détails d'une alerte pour édition
  static Map<String, dynamic> alertDetails(String alertId) => {
        "id": alertId,
        "name": "Alerte température serre 1",
        "isActive": true,
        "cellIds": ["1", "2"],
        "sensors": [
          {
            "type": "temperature",
            "index": 0,
            "criticalRange": {"start": -10.0, "end": 40.0},
            "warningRange": {"start": 0.0, "end": 30.0},
          }
        ],
        "isWarningEnabled": true,
      };
}

