import 'package:garden_ui/ui/components.dart'; // Pour SensorThreshold, ThresholdValue et enums

/// Modèle représentant une alerte dans le système
class Alert {
  /// Identifiant unique de l'alerte
  final String id;
  
  /// Titre de l'alerte (ex: "Alerte 1")
  final String title;
  
  /// Description de l'alerte
  final String description;
  
  /// Indique si l'alerte est active/activée
  final bool isActive;
  
  /// Types de capteurs associés à l'alerte
  final List<SensorType> sensorTypes;

  const Alert({
    required this.id,
    required this.title,
    required this.description,
    required this.isActive,
    required this.sensorTypes,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isActive: json['isActive'] as bool,
      sensorTypes: (json['sensorTypes'] as List<dynamic>)
          .map((type) => _sensorTypeFromString(type as String))
          .toList(),
    );
  }
}

/// Modèle de données pour un capteur d'alerte avec seuils détaillés
class SensorAlertData {
  final String id;
  final String title;
  final SensorType sensorType;
  final SensorThreshold threshold;
  final bool isEnabled;

  const SensorAlertData({
    required this.id,
    required this.title,
    required this.sensorType,
    required this.threshold,
    required this.isEnabled,
  });

  SensorAlertData copyWith({
    String? id,
    String? title,
    SensorType? sensorType,
    SensorThreshold? threshold,
    bool? isEnabled,
  }) {
    return SensorAlertData(
      id: id ?? this.id,
      title: title ?? this.title,
      sensorType: sensorType ?? this.sensorType,
      threshold: threshold ?? this.threshold,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  factory SensorAlertData.fromJson(Map<String, dynamic> json) {
    return SensorAlertData(
      id: json['id'] as String,
      title: json['title'] as String,
      sensorType: _sensorTypeFromString(json['sensorType'] as String),
      threshold: _sensorThresholdFromJson(json['threshold'] as Map<String, dynamic>),
      isEnabled: json['isEnabled'] as bool,
    );
  }
}

/// Modèle représentant un événement d'alerte (pour l'historique/tableau)
class AlertEvent {
  /// Identifiant unique de l'événement
  final String id;
  
  /// Valeur qui a déclenché l'alerte
  final String value;
  
  /// Type de capteur (température, humidité, etc.)
  final SensorType sensorType;
  
  /// Nom de la cellule concernée
  final String cellName;
  
  /// Heure de déclenchement
  final String time;
  
  /// Date de déclenchement
  final String date;
  
  /// Localisation complète (Parcelle > Serre > Chapelle > planche)
  final String location;

  const AlertEvent({
    required this.id,
    required this.value,
    required this.sensorType,
    required this.cellName,
    required this.time,
    required this.date,
    required this.location,
  });

  factory AlertEvent.fromJson(Map<String, dynamic> json) {
    return AlertEvent(
      id: json['id'] as String,
      value: json['value'] as String,
      sensorType: _sensorTypeFromString(json['sensorType'] as String),
      cellName: json['cellName'] as String,
      time: json['time'] as String,
      date: json['date'] as String,
      location: json['location'] as String,
    );
  }
}

/// Convertit une chaîne en SensorType
SensorType _sensorTypeFromString(String type) {
  switch (type) {
    case 'temperature':
      return SensorType.temperature;
    case 'humiditySurface':
      return SensorType.humiditySurface;
    case 'humidityDepth':
      return SensorType.humidityDepth;
    case 'light':
      return SensorType.light;
    case 'rain':
      return SensorType.rain;
    default:
      throw ArgumentError('Unknown sensor type: $type');
  }
}

/// Convertit une chaîne en MenuAlertType
MenuAlertType _menuAlertTypeFromString(String type) {
  switch (type) {
    case 'none':
      return MenuAlertType.none;
    case 'warning':
      return MenuAlertType.warning;
    case 'error':
      return MenuAlertType.error;
    default:
      throw ArgumentError('Unknown alert type: $type');
  }
}

/// Convertit un JSON en SensorThreshold
SensorThreshold _sensorThresholdFromJson(Map<String, dynamic> json) {
  return SensorThreshold(
    thresholds: (json['thresholds'] as List<dynamic>)
        .map((thresholdJson) => ThresholdValue(
              value: (thresholdJson['value'] as num).toDouble(),
              unit: thresholdJson['unit'] as String,
              label: thresholdJson['label'] as String,
              alertType: _menuAlertTypeFromString(thresholdJson['alertType'] as String),
            ))
        .toList(),
  );
}