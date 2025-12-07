import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:garden_ui/ui/components.dart';
import '../models/alert_models.dart';

/// Composant d'affichage des événements d'alerte sous forme de tableau
class AlertTable extends StatelessWidget {
  /// Liste des événements d'alerte à afficher
  final List<AlertEvent> events;
  
  /// Indique si les en-têtes de colonnes doivent être affichés
  final bool showHeaders;
  
  /// Callback appelé lors de l'archivage d'un événement
  final ValueChanged<AlertEvent>? onDeleteEvent;

  const AlertTable({
    super.key,
    required this.events,
    this.showHeaders = true,
    this.onDeleteEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // En-têtes (optionnel)
        if (showHeaders) _buildHeader(),
        // Liste des événements
        ...events.map((event) => _buildEventRow(event)),
      ],
    );
  }

  /// Construit la ligne d'en-tête du tableau sous forme de carte
  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GardenCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Espace pour l'icône du capteur (pas de titre)
              const SizedBox(width: 32),
              // Cellule
              Expanded(
                flex: 2,
                child: Text(
                  'Cellule',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              // Heure
              Expanded(
                flex: 1,
                child: Text(
                  'Heure',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              // Date
              Expanded(
                flex: 2,
                child: Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              // Localisation
              Expanded(
                flex: 4,
                child: Text(
                  'Localisation',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              // Action (archivage)
              const SizedBox(width: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit une ligne d'événement du tableau sous forme de carte
  Widget _buildEventRow(AlertEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GardenCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Icône du capteur à gauche (pas dans une colonne)
              SizedBox(
                width: 32,
                child: Center(
                  child: GardenIcon(
                    iconName: event.sensorType.iconName,
                    size: GardenIconSize.sm,
                    color: _getSensorColor(event.sensorType),
                  ),
                ),
              ),
              // Cellule
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      size: 16,
                      color: Colors.red.shade600,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '${event.cellName} - ${event.value}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Heure
              Expanded(
                flex: 1,
                child: Text(
                  event.time,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              // Date
              Expanded(
                flex: 2,
                child: Text(
                  event.date,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              // Localisation
              Expanded(
                flex: 4,
                child: Text(
                  event.location,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Bouton d'archivage
              SizedBox(
                width: 40,
                child: IconButton(
                  onPressed: onDeleteEvent != null 
                      ? () => onDeleteEvent!(event)
                      : null,
                  icon: Icon(
                    Icons.inventory_2_outlined,
                    size: 20,
                    color: GardenColors.typography.shade400,
                  ),
                  tooltip: 'Archiver',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Retourne la couleur appropriée pour chaque type de capteur
  Color _getSensorColor(SensorType sensorType) {
    switch (sensorType) {
      case SensorType.temperature:
        return Colors.red.shade600;
      case SensorType.humiditySurface:
        return Colors.blue.shade600;
      case SensorType.humidityDepth:
        return Colors.blue.shade800;
      case SensorType.light:
        return Colors.orange.shade600;
      case SensorType.rain:
        return Colors.purple.shade600;
    }
  }
}