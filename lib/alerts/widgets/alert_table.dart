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
  
  /// Callback appelé lors de l'archivage de tous les événements
  final VoidCallback? onArchiveAll;

  const AlertTable({
    super.key,
    required this.events,
    this.showHeaders = true,
    this.onDeleteEvent,
    this.onArchiveAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header avec compteur et bouton Archive All
        if (showHeaders && events.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${events.length} événement(s) dans l\'historique',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        // En-têtes des colonnes (optionnel)
        if (showHeaders && events.isNotEmpty) _buildHeader(),
        // Message vide si aucun événement
        if (events.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'Aucun événement dans l\'historique',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), // Même padding que les lignes
          child: Row(
            children: [
              // Espace pour l'icône du capteur (pas de titre) - même largeur que les lignes
              const SizedBox(width: 40), // Changement de 32 à 40
              const SizedBox(width: 32), // Même espacement que dans les lignes
              // Valeur de l'alerte
              Expanded(
                flex: 2,
                child: Text(
                  'Valeur',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
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
                flex: 3,
                child: Text(
                  'Localisation',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              // Action (archivage) - bouton pour archiver tout
              SizedBox(
                width: 40,
                child: IconButton(
                  onPressed: onArchiveAll,
                  icon: Icon(
                    Icons.inventory_2_outlined,
                    size: 20,
                    color: GardenColors.typography.shade400,
                  ),
                  tooltip: 'Archiver tout',
                ),
              ),
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), // Réduction du padding horizontal
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Icône du capteur à gauche - plus large et plus à gauche
              SizedBox(
                width: 40, // Augmentation de 32 à 40
                child: Align(
                  alignment: Alignment.centerLeft, // Alignement à gauche
                  child: GardenIcon(
                    iconName: event.sensorType.iconName,
                    size: GardenIconSize.md, // Retour à sm pour réduire la taille
                    color: _getSensorColor(event.sensorType),
                  ),
                ),
              ),
              const SizedBox(width: 32), // Espacement entre l'icône et la valeur
              // Valeur de l'alerte
              Expanded(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: Colors.red.shade600,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        event.value,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // Cellule
              Expanded(
                flex: 2,
                child: Text(
                  event.cellName,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Heure
              Expanded(
                flex: 1,
                child: Text(
                  event.time,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.2,
                  ),
                ),
              ),
              // Date
              Expanded(
                flex: 2,
                child: Text(
                  event.date,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.2,
                  ),
                ),
              ),
              // Localisation
              Expanded(
                flex: 3,
                child: Text(
                  event.location,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.2,
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