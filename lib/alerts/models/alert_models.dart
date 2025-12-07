import 'package:garden_ui/ui/enums.dart';

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
}