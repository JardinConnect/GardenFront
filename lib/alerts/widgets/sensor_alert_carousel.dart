import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import '../models/alert_models.dart';

/// Modèle de données pour un capteur d'alerte
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
}

/// Composant carousel pour afficher les alertes de capteurs
/// Utilise le SensorAlertCard avec pagination intégrée
class SensorAlertCarousel extends StatefulWidget {
  /// Liste des données de capteurs à afficher
  final List<SensorAlertData> sensors;
  
  /// Callback appelé quand l'état d'activation d'un capteur change
  final void Function(String sensorId, bool isEnabled)? onToggle;
  
  /// Index de la page courante (optionnel)
  final int? initialPage;

  const SensorAlertCarousel({
    super.key,
    required this.sensors,
    this.onToggle,
    this.initialPage,
  });

  @override
  State<SensorAlertCarousel> createState() => _SensorAlertCarouselState();
}

class _SensorAlertCarouselState extends State<SensorAlertCarousel> {
  late int currentPage;
  late List<SensorAlertData> sensors;

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPage ?? 0;
    sensors = List.from(widget.sensors);
    
    // Assure-toi que la page courante est valide
    if (currentPage >= sensors.length) {
      currentPage = sensors.isNotEmpty ? sensors.length - 1 : 0;
    }
  }

  @override
  void didUpdateWidget(SensorAlertCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Met à jour les données si elles ont changé
    if (widget.sensors != oldWidget.sensors) {
      sensors = List.from(widget.sensors);
      
      // Vérifie que la page courante est toujours valide
      if (currentPage >= sensors.length) {
        currentPage = sensors.isNotEmpty ? sensors.length - 1 : 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si aucun capteur, affiche un message
    if (sensors.isEmpty) {
      return Container(
        width: 400,
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Aucune alerte configurée',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    final currentSensor = sensors[currentPage];

    return SensorAlertCard(
      sensorType: currentSensor.sensorType,
      threshold: currentSensor.threshold,
      isEnabled: currentSensor.isEnabled,
      onToggle: (value) {
        setState(() {
          sensors[currentPage] = currentSensor.copyWith(isEnabled: value);
        });
        
        // Notifie le parent du changement
        widget.onToggle?.call(currentSensor.id, value);
      },
      totalPages: sensors.length,
      currentPage: currentPage,
      onPageChanged: (index) {
        setState(() {
          currentPage = index;
        });
      },
    );
  }
}