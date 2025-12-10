import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import '../../models/alert_models.dart';

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

  List<SensorAlertData> _allSensors(List<SensorAlertData> input) {
    return input;
  }

  @override
  void initState() {
    super.initState();
    sensors = _allSensors(widget.sensors);
    currentPage = widget.initialPage ?? 0;
    if (currentPage >= sensors.length) {
      currentPage = sensors.isNotEmpty ? sensors.length - 1 : 0;
    }
  }

  @override
  void didUpdateWidget(SensorAlertCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sensors != oldWidget.sensors) {
      sensors = _allSensors(widget.sensors);
      if (currentPage >= sensors.length) {
        currentPage = sensors.isNotEmpty ? sensors.length - 1 : 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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

    final List<ThresholdValue> limitedThresholds = currentSensor.threshold.thresholds.take(6).toList();

    return SensorAlertCard(
      sensorType: currentSensor.sensorType,
      threshold: SensorThreshold(thresholds: limitedThresholds),
      isEnabled: currentSensor.isEnabled,
      onToggle: (value) {
        setState(() {
          sensors[currentPage] = currentSensor.copyWith(isEnabled: value);
        });
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