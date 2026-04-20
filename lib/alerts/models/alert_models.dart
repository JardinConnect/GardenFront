import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

/// Extension pour ajouter les plages par défaut aux types de capteurs
extension SensorTypeExtension on SensorType {
  /// Retourne la plage critique par défaut selon le type de capteur
  RangeValues get defaultCriticalRange {
    switch (this) {
      case SensorType.airTemperature:
      case SensorType.soilTemperature:
        return const RangeValues(-10, 40);
      case SensorType.humiditySurface:
      case SensorType.humidityDepth:
        return const RangeValues(10, 90);
      case SensorType.light:
        return const RangeValues(100, 15000);
      case SensorType.rain:
        return const RangeValues(0, 80);
    }
  }

  /// Retourne la plage d'avertissement par défaut selon le type de capteur
  RangeValues get defaultWarningRange {
    switch (this) {
      case SensorType.airTemperature:
      case SensorType.soilTemperature:
        return const RangeValues(0, 30);
      case SensorType.humiditySurface:
      case SensorType.humidityDepth:
        return const RangeValues(20, 80);
      case SensorType.light:
        return const RangeValues(500, 10000);
      case SensorType.rain:
        return const RangeValues(5, 70);
    }
  }
}

/// Modèle représentant une alerte dans le système
class Alert {
  /// Identifiant unique de l'alerte
  final String id;

  /// Titre de l'alerte (ex: "Alerte 1")
  final String title;

  /// Indique si l'alerte est active/activée
  final bool isActive;

  /// Types de capteurs associés à l'alerte
  final List<SensorAlertData> sensors;

  // Indique si le warning est actif
  final bool warningEnabled;

  const Alert({
    required this.id,
    required this.title,
    required this.isActive,
    required this.sensors,
    required this.warningEnabled,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] as String,
      title: json['title'] as String,
      isActive: json['isActive'] as bool,
      sensors:
          (json['sensors'] as List<dynamic>?)
              ?.map((sensorJson) => _sensorAlertDataFromApiJson(sensorJson))
              // La batterie ne doit pas être affichée/configurée dans les alertes
              .where((s) => s.id != 'battery')
              .toList() ??
          [],
      warningEnabled: json['warningEnabled'] as bool? ?? true,
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
      sensorType: sensorTypeFromString(json['sensorType'] as String),
      threshold: _sensorThresholdFromJson(
        json['threshold'] as Map<String, dynamic>,
      ),
      isEnabled: json['isEnabled'] as bool,
    );
  }
}

/// Modèle représentant un événement d'alerte (pour l'historique/tableau)
class AlertEvent {
  final String id;
  final String alertId;
  final String alertTitle;
  final String cellId;
  final String cellName;
  final String cellLocation;
  final String sensorTypeRaw;
  final SensorType sensorType;
  final String severity;
  final double value;
  final double thresholdMin;
  final double thresholdMax;
  final DateTime timestamp;
  final bool isArchived;

  const AlertEvent({
    required this.id,
    required this.alertId,
    required this.alertTitle,
    required this.cellId,
    required this.cellName,
    required this.cellLocation,
    required this.sensorTypeRaw,
    required this.sensorType,
    required this.severity,
    required this.value,
    required this.thresholdMin,
    required this.thresholdMax,
    required this.timestamp,
    required this.isArchived,
  });

  /// Vrai si cet événement concerne la batterie (non représentable par SensorType)
  bool get isBattery => sensorTypeRaw == 'battery';

  factory AlertEvent.fromJson(Map<String, dynamic> json) {
    return AlertEvent(
      id: json['id'] as String,
      alertId: json['alertId'] as String,
      alertTitle: json['alertTitle'] as String,
      cellId: json['cellId'] as String,
      cellName: json['cellName'] as String,
      cellLocation: json['cellLocation'] as String,
      sensorTypeRaw: json['sensorType'] as String,
      sensorType: sensorTypeFromString(json['sensorType'] as String),
      severity: json['severity'] as String,
      value: (json['value'] as num).toDouble(),
      thresholdMin: (json['thresholdMin'] as num).toDouble(),
      thresholdMax: (json['thresholdMax'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isArchived: json['isArchived'] as bool,
    );
  }
}

// Convertit une chaîne en SensorType (snake_case API → SensorType)
SensorType sensorTypeFromString(String type) {
  switch (type) {
    case 'air_temperature':
      return SensorType.airTemperature;
    case 'soil_humidity':
      return SensorType.humiditySurface;
    case 'deep_soil_humidity':
      return SensorType.humidityDepth;
    case 'light':
      return SensorType.light;
    case 'soil_temperature':
      return SensorType.soilTemperature;
    case 'air_humidity':
      return SensorType.rain;
    default:
      return SensorType
          .airTemperature; // Valeur par défaut pour éviter les erreurs
  }
}

/// Convertit un SensorType en string pour l'API (ex: airTemperature → air_temperature)
String sensorTypeToApiString(SensorType type) {
  switch (type) {
    case SensorType.airTemperature:
      return 'air_temperature';
    case SensorType.soilTemperature:
      return 'soil_temperature';
    case SensorType.humiditySurface:
      return 'soil_humidity';
    case SensorType.humidityDepth:
      return 'deep_soil_humidity';
    case SensorType.light:
      return 'light';
    case SensorType.rain:
      return 'air_humidity';
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
    thresholds:
        (json['thresholds'] as List<dynamic>)
            .map(
              (thresholdJson) => ThresholdValue(
                value: (thresholdJson['value'] as num).toDouble(),
                unit: thresholdJson['unit'] as String,
                label: thresholdJson['label'] as String,
                alertType: _menuAlertTypeFromString(
                  thresholdJson['alertType'] as String,
                ),
              ),
            )
            .toList(),
  );
}

// Retourne la couleur appropriée pour chaque type de capteur
Color getSensorColor(SensorType sensorType, {int index = 0}) {
  // Couleurs par défaut selon le type
  switch (sensorType) {
    case SensorType.airTemperature:
      return GardenColors.redAlert.shade500;
    case SensorType.soilTemperature:
      return Colors.brown;
    case SensorType.humiditySurface:
      return GardenColors.blueInfo.shade400;
    case SensorType.humidityDepth:
      return GardenColors.blueInfo.shade600;
    case SensorType.light:
      return GardenColors.secondary.shade400;
    case SensorType.rain:
      return GardenColors.blueInfo.shade500;
  }
}

// Convertit un JSON de capteur depuis l'API en SensorAlertData
SensorAlertData _sensorAlertDataFromApiJson(Map<String, dynamic> json) {
  final criticalRange = json['criticalRange'] as Map<String, dynamic>;
  final warningRange = json['warningRange'] as Map<String, dynamic>?;

  return SensorAlertData(
    id: json['type'] as String,
    title: json['type'] as String,
    sensorType: sensorTypeFromString(json['type'] as String),
    threshold: SensorThreshold(
      thresholds: [
        // Ligne 1 : Min warning | Min critique
        if (warningRange != null)
          ThresholdValue(
            value: (warningRange['min'] as num).toDouble(),
            unit: _getUnitForSensorType(json['type'] as String),
            label: 'Min warning',
            alertType: MenuAlertType.warning,
          ),
        ThresholdValue(
          value: (criticalRange['min'] as num).toDouble(),
          unit: _getUnitForSensorType(json['type'] as String),
          label: 'Min critique',
          alertType: MenuAlertType.error,
        ),
        // Ligne 2 : Max warning | Max critique
        if (warningRange != null)
          ThresholdValue(
            value: (warningRange['max'] as num).toDouble(),
            unit: _getUnitForSensorType(json['type'] as String),
            label: 'Max warning',
            alertType: MenuAlertType.warning,
          ),
        ThresholdValue(
          value: (criticalRange['max'] as num).toDouble(),
          unit: _getUnitForSensorType(json['type'] as String),
          label: 'Max critique',
          alertType: MenuAlertType.error,
        ),
      ],
    ),

    isEnabled: true,
  );
}

// Retourne l'unité appropriée selon le type de capteur
String _getUnitForSensorType(String type) {
  switch (type) {
    case 'air_temperature':
    case 'soil_temperature':
      return '°C';
    case 'soil_humidity':
    case 'air_humidity':
    case 'deep_soil_humidity':
      return '%';
    case 'light':
      return 'lux';
    default:
      return '';
  }
}

/// Modèle léger pour représenter une cellule dans le formulaire d'alerte
class CellItem {
  final String id;
  final String name;
  final String location;

  const CellItem({required this.id, required this.name, this.location = ''});

  factory CellItem.fromJson(Map<String, dynamic> json) {
    return CellItem(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String? ?? '',
    );
  }
}

class SensorRange {
  final double min;
  final double max;

  const SensorRange({required this.min, required this.max});

  Map<String, dynamic> toJson() => {"min": min, "max": max};
}

class SensorRequest {
  final String type;
  final int index;
  final String sensor_id;
  final SensorRange criticalRange;
  final SensorRange warningRange;

  const SensorRequest({
    required this.type,
    required this.index,
    required this.sensor_id,
    required this.criticalRange,
    required this.warningRange,
  });

  Map<String, dynamic> toJson() => {
    "type": type,
    "index": index,
    "sensor_id": sensor_id,
    "criticalRange": criticalRange.toJson(),
    "warningRange": warningRange.toJson(),
  };
}

class AlertCreationRequest {
  final String title;
  final bool isActive;
  final List<String> cellIds;
  final List<SensorRequest> sensors;
  final bool warningEnabled;
  final bool overwriteExisting;

  const AlertCreationRequest({
    required this.title,
    required this.isActive,
    required this.cellIds,
    required this.sensors,
    required this.warningEnabled,
    this.overwriteExisting = false,
  });

  AlertCreationRequest copyWith({bool? overwriteExisting}) {
    return AlertCreationRequest(
      title: title,
      isActive: isActive,
      cellIds: cellIds,
      sensors: sensors,
      warningEnabled: warningEnabled,
      overwriteExisting: overwriteExisting ?? this.overwriteExisting,
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "isActive": isActive,
    "cellIds": cellIds,
    "sensors": sensors.map((s) => s.toJson()).toList(),
    "warningEnabled": warningEnabled,
    "overwriteExisting": overwriteExisting,
  };
}

/// Un conflit détecté lors de la validation d'une alerte
class AlertConflict {
  final String cellId;
  final String cellName;
  final String sensorType;
  final String existingAlertId;
  final String existingAlertTitle;
  final String message;

  const AlertConflict({
    required this.cellId,
    required this.cellName,
    required this.sensorType,
    required this.existingAlertId,
    required this.existingAlertTitle,
    required this.message,
  });

  factory AlertConflict.fromJson(Map<String, dynamic> json) {
    return AlertConflict(
      cellId: json['cellId'] as String,
      cellName: json['cellName'] as String,
      sensorType: json['sensorType'] as String,
      existingAlertId: json['existingAlertId'] as String,
      existingAlertTitle: json['existingAlertTitle'] as String,
      message: json['message'] as String,
    );
  }
}

/// Réponse de validation d'une alerte
class AlertValidationResponse {
  final List<AlertConflict> conflicts;
  final bool hasConflicts;

  const AlertValidationResponse({
    required this.conflicts,
    required this.hasConflicts,
  });

  factory AlertValidationResponse.fromJson(Map<String, dynamic> json) {
    return AlertValidationResponse(
      conflicts:
          (json['conflicts'] as List<dynamic>)
              .map((c) => AlertConflict.fromJson(c as Map<String, dynamic>))
              .toList(),
      hasConflicts: json['hasConflicts'] as bool,
    );
  }
}

/// Requête de validation avant création d'une alerte
class AlertValidationRequest {
  final List<String> cellIds;
  final List<String> sensorTypes;

  const AlertValidationRequest({
    required this.cellIds,
    required this.sensorTypes,
  });

  Map<String, dynamic> toJson() => {
    "cellIds": cellIds,
    "sensorTypes": sensorTypes,
  };
}
