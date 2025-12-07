import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/alert_bloc.dart';
import '../models/alert_models.dart';
import '../widgets/sensor_alert_carousel.dart';

/// Composant pour l'affichage en cartes des alertes
class AlertCardView extends StatelessWidget {
  final List<SensorAlertData> sensorAlerts;

  const AlertCardView({super.key, required this.sensorAlerts});

  @override
  Widget build(BuildContext context) {
    if (sensorAlerts.isEmpty) {
      return const Center(child: Text('Aucune donnée de capteur disponible'));
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          // Première carte avec les 2 premiers capteurs
          if (sensorAlerts.length >= 2)
            SizedBox(
              width: 400,
              child: SensorAlertCarousel(
                sensors: sensorAlerts.take(2).toList(),
                onToggle: (sensorId, isEnabled) {
                  context.read<AlertBloc>().add(
                    AlertToggleStatus(
                      alertId: sensorId,
                      isActive: isEnabled,
                    ),
                  );
                },
              ),
            ),
          // Deuxième carte avec les 2 suivants
          if (sensorAlerts.length >= 4)
            SizedBox(
              width: 400,
              child: SensorAlertCarousel(
                sensors: sensorAlerts.skip(2).take(2).toList(),
                onToggle: (sensorId, isEnabled) {
                  context.read<AlertBloc>().add(
                    AlertToggleStatus(
                      alertId: sensorId,
                      isActive: isEnabled,
                    ),
                  );
                },
              ),
            ),
          // Troisième carte avec le reste
          if (sensorAlerts.length > 4)
            SizedBox(
              width: 400,
              child: SensorAlertCarousel(
                sensors: sensorAlerts.skip(4).toList(),
                onToggle: (sensorId, isEnabled) {
                  context.read<AlertBloc>().add(
                    AlertToggleStatus(
                      alertId: sensorId,
                      isActive: isEnabled,
                    ),
                  );
                },
              ),
            ),
          // Cas où il y a moins de 2 capteurs
          if (sensorAlerts.length < 2)
            SizedBox(
              width: 400,
              child: SensorAlertCarousel(
                sensors: sensorAlerts,
                onToggle: (sensorId, isEnabled) {
                  context.read<AlertBloc>().add(
                    AlertToggleStatus(
                      alertId: sensorId,
                      isActive: isEnabled,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}