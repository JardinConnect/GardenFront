import 'package:flutter/material.dart';
import 'package:garden_ui/ui/enums/alert.dart';
import 'package:garden_ui/ui/enums/sensor_type.dart';
import 'package:garden_ui/ui/models/sensor_threshold.dart';
import 'package:garden_ui/ui/models/threshold_value.dart';
import '../widgets/alerts/sensor_alert_carousel.dart';
import '../models/alert_models.dart';

/// Composant pour l'affichage en cartes des alertes (mock)
class AlertCardView extends StatelessWidget {
  const AlertCardView({super.key, required List<SensorAlertData> sensorAlerts});

  /// Données mock : chaque sous-liste = une carte
  List<List<SensorAlertData>> get _mockCards => [
    // Card simple (1 capteur)
    [
      SensorAlertData(
        id: '1',
        title: 'Température unique',
        sensorType: SensorType.temperature,
        threshold: SensorThreshold(thresholds: [
          ThresholdValue(
              value: 35,
              unit: '°C',
              label: 'maximale',
              alertType: MenuAlertType.error),
          ThresholdValue(
              value: 2,
              unit: '°C',
              label: 'minimale',
              alertType: MenuAlertType.error),
        ]),
        isEnabled: true,
      ),
    ],
    // Card carrousel (2 capteurs)
    [
      SensorAlertData(
        id: '2a',
        title: 'Humidité Surface',
        sensorType: SensorType.temperature,
        threshold: SensorThreshold(thresholds: [
          ThresholdValue(
              value: 40,
              unit: '°C',
              label: 'maximale',
              alertType: MenuAlertType.error),
          ThresholdValue(
              value: 0,
              unit: '°C',
              label: 'minimale',
              alertType: MenuAlertType.error),
        ]),
        isEnabled: true,
      ),
      SensorAlertData(
        id: '2b',
        title: 'Lumière',
        sensorType: SensorType.temperature,
        threshold: SensorThreshold(thresholds: [
          ThresholdValue(
              value: 10000,
              unit: ' lux',
              label: 'maximale',
              alertType: MenuAlertType.error),
          ThresholdValue(
              value: 1000,
              unit: ' lux',
              label: 'minimale',
              alertType: MenuAlertType.error),
        ]),
        isEnabled: true,
      ),
    ],
    // Card carrousel (3 capteurs)
    [
      SensorAlertData(
        id: '3a',
        title: 'Température',
        sensorType: SensorType.temperature,
        threshold: SensorThreshold(thresholds: [
          ThresholdValue(
              value: 40,
              unit: '°C',
              label: 'maximale',
              alertType: MenuAlertType.warning),
          ThresholdValue(
              value: 30,
              unit: '°C',
              label: 'maximale',
              alertType: MenuAlertType.error),
          ThresholdValue(
              value: 10,
              unit: '°C',
              label: 'minimale',
              alertType: MenuAlertType.warning),
          ThresholdValue(
              value: 0,
              unit: '°C',
              label: 'minimale',
              alertType: MenuAlertType.error),
        ]),
        isEnabled: true,
      ),
      SensorAlertData(
        id: '3b',
        title: 'Humidité Profonde',
        sensorType: SensorType.temperature,
        threshold: SensorThreshold(thresholds: [
          ThresholdValue(
              value: 40,
              unit: '°C',
              label: 'maximale',
              alertType: MenuAlertType.warning),
          ThresholdValue(
              value: 30,
              unit: '°C',
              label: 'maximale',
              alertType: MenuAlertType.error),
          ThresholdValue(
              value: 10,
              unit: '°C',
              label: 'minimale',
              alertType: MenuAlertType.warning),
          ThresholdValue(
              value: 0,
              unit: '°C',
              label: 'minimale',
              alertType: MenuAlertType.error),
        ]),
        isEnabled: false,
      ),
      SensorAlertData(
        id: '3c',
        title: 'Pluie',
        sensorType: SensorType.temperature,
        threshold: SensorThreshold(thresholds: [
          ThresholdValue(
              value: 40,
              unit: '°C',
              label: 'maximale',
              alertType: MenuAlertType.warning),
          ThresholdValue(
              value: 30,
              unit: '°C',
              label: 'maximale',
              alertType: MenuAlertType.error),
          ThresholdValue(
              value: 10,
              unit: '°C',
              label: 'minimale',
              alertType: MenuAlertType.warning),
          ThresholdValue(
              value: 0,
              unit: '°C',
              label: 'minimale',
              alertType: MenuAlertType.error),
        ]),
        isEnabled: true,
      ),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    // Chaque sous-liste = une card
    final cards = _mockCards
        .map(
          (group) => SizedBox(
        width: 400,
        child: SensorAlertCarousel(
          sensors: group,
          onToggle: (sensorId, isEnabled) {
          },
        ),
      ),
    )
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: cards,
      ),
    );
  }
}
