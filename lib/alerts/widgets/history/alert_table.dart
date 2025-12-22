import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:garden_ui/ui/components.dart';
import '../../models/alert_models.dart';

/// Widget d'affichage des événements d'alerte sous forme de tableau
/// Présente l'historique complet des alertes déclenchées avec toutes les informations
/// Permet l'archivage individuel ou en masse des événements
class AlertTable extends StatelessWidget {
  /// Liste des événements d'alerte à afficher
  final List<AlertEvent> events;

  /// Indique si les en-têtes de colonnes doivent être affichés
  final bool showHeaders;

  /// Callback appelé lors de l'archivage d'un événement individuel
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
        // En-tête avec compteur d'événements
        if (showHeaders && events.isNotEmpty) _buildHeaderInfo(context),

        // Ligne d'en-tête du tableau
        if (showHeaders && events.isNotEmpty) _buildTableHeader(),

        // Message si aucun événement
        if (events.isEmpty) _buildEmptyState(),

        // Liste des événements
        ...events.map((event) => _buildEventRow(event)),
      ],
    );
  }

  /// Construit l'en-tête avec le compteur d'événements
  Widget _buildHeaderInfo(BuildContext context) {
    return Padding(
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
    );
  }

  /// Construit l'état vide (aucun événement)
  Widget _buildEmptyState() {
    return const Center(
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
    );
  }

  /// Construit la ligne d'en-tête du tableau avec les titres des colonnes
  Widget _buildTableHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GardenCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            children: [
              // Espace pour l'icône du capteur (même largeur que les lignes)
              const SizedBox(width: 40),
              const SizedBox(width: 32), // Espacement

              // Colonne: Valeur de l'alerte
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

              // Colonne: Cellule concernée
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

              // Colonne: Heure de déclenchement
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

              // Colonne: Date de déclenchement
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

              // Colonne: Localisation précise
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

              // Bouton pour archiver tous les événements
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

  /// Construit une ligne d'événement du tableau
  /// Affiche toutes les informations de l'événement d'alerte
  Widget _buildEventRow(AlertEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GardenCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Icône du type de capteur
              _buildSensorIcon(event.sensorType),
              const SizedBox(width: 32),

              // Valeur qui a déclenché l'alerte
              _buildValueCell(event.value),

              // Nom de la cellule concernée
              _buildCellNameCell(event.cellName),

              // Heure de déclenchement
              _buildTimeCell(event.dateTime),

              // Date de déclenchement
              _buildDateCell(event.dateTime),

              // Localisation complète
              _buildLocationCell(event.location),

              // Bouton d'archivage de l'événement
              _buildArchiveButton(event),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit l'icône du capteur avec sa couleur appropriée
  Widget _buildSensorIcon(SensorType sensorType) {
    return SizedBox(
      width: 40,
      child: Align(
        alignment: Alignment.centerLeft,
        child: GardenIcon(
          iconName: sensorType.iconName,
          size: GardenIconSize.md,
          color: _getSensorColor(sensorType),
        ),
      ),
    );
  }

  /// Construit la cellule de la valeur avec icône d'avertissement
  Widget _buildValueCell(String value) {
    return Expanded(
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
              value,
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
    );
  }

  /// Construit la cellule du nom de la cellule
  Widget _buildCellNameCell(String cellName) {
    return Expanded(
      flex: 2,
      child: Text(
        cellName,
        style: const TextStyle(
          fontSize: 14,
          height: 1.2,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// Construit la cellule de l'heure
  Widget _buildTimeCell(DateTime dateTime) {
    final timeFormat = DateFormat('HH:mm');
    return Expanded(
      flex: 1,
      child: Text(
        timeFormat.format(dateTime),
        style: const TextStyle(
          fontSize: 14,
          height: 1.2,
        ),
      ),
    );
  }

  /// Construit la cellule de la date
  Widget _buildDateCell(DateTime dateTime) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return Expanded(
      flex: 2,
      child: Text(
        dateFormat.format(dateTime),
        style: const TextStyle(
          fontSize: 14,
          height: 1.2,
        ),
      ),
    );
  }

  /// Construit la cellule de la localisation
  Widget _buildLocationCell(String location) {
    return Expanded(
      flex: 3,
      child: Text(
        location,
        style: TextStyle(
          fontSize: 12,
          height: 1.2,
          color: Colors.grey.shade600,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// Construit le bouton d'archivage d'un événement
  Widget _buildArchiveButton(AlertEvent event) {
    return SizedBox(
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
    );
  }

  /// Retourne la couleur appropriée pour chaque type de capteur
  /// Permet une identification visuelle rapide du type d'alerte
  Color _getSensorColor(SensorType sensorType) {
    switch (sensorType) {
      case SensorType.temperature:
        return Colors.red.shade600; // Rouge pour température
      case SensorType.humiditySurface:
        return Colors.blue.shade600; // Bleu clair pour humidité de surface
      case SensorType.humidityDepth:
        return Colors.blue.shade800; // Bleu foncé pour humidité profonde
      case SensorType.light:
        return Colors.orange.shade600; // Orange pour luminosité
      case SensorType.rain:
        return Colors.purple.shade600; // Violet pour pluviosité
    }
  }
}

