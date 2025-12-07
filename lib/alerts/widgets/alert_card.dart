import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import '../models/alert_models.dart';
import 'sensor_icons_row.dart';

/// Composant d'affichage d'une alerte sous forme de carte
class AlertCard extends StatelessWidget {
  /// L'alerte à afficher
  final Alert alert;

  /// Callback appelé lors du changement d'état de l'alerte
  final ValueChanged<bool> onActiveChanged;

  const AlertCard({
    super.key,
    required this.alert,
    required this.onActiveChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GardenCard(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // Contenu principal (titre, description, icônes)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre de l'alerte
                    Text(
                      alert.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Description et icônes sur la même ligne
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          alert.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Icônes des capteurs basées sur les sensorTypes
                        SensorIconsRow(
                          activeSensorTypes: alert.sensorTypes,
                          iconSize: GardenIconSize.sm,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Toggle pour activation/désactivation à droite
              GardenToggle(
                isEnabled: alert.isActive,
                onToggle: onActiveChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}