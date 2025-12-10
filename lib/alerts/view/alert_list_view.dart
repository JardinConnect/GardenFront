import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/components.dart';
import '../bloc/alert_bloc.dart';
import '../models/alert_models.dart';
import '../widgets/alerts/sensor_icons_row.dart';

/// Composant pour l'affichage en liste des alertes
/// Affiche chaque alerte dans une carte avec ses capteurs et un switch d'activation
class AlertListView extends StatelessWidget {
  final List<Alert> alerts;

  const AlertListView({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    // Affichage d'un message si aucune alerte n'est disponible
    if (alerts.isEmpty) {
      return const Center(
        child: Text('Aucune alerte disponible'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: alerts.length,
      itemBuilder: (context, index) => _AlertListItem(alert: alerts[index]),
    );
  }
}

/// Widget représentant une seule alerte dans la liste
class _AlertListItem extends StatelessWidget {
  final Alert alert;

  const _AlertListItem({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GardenCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ligne principale avec titre et contrôles
              _buildMainRow(context),

              // Icônes des capteurs positionnées au centre
              _buildSensorIcons(),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit la ligne principale avec le titre et les boutons d'action
  Widget _buildMainRow(BuildContext context) {
    return Row(
      children: [
        // Titre de l'alerte (prend tout l'espace disponible)
        Expanded(
          child: Text(
            alert.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Bouton d'information avec tooltip
        TooltipIconButton(
          onPressed: () => _handleShowAlertDetails(context),
          size: TooltipSize.lg,
        ),

        const SizedBox(width: 8),

        // Switch pour activer/désactiver l'alerte
        Switch(
          value: alert.isActive,
          onChanged: (value) => _handleToggleAlert(context, value),
        ),
      ],
    );
  }

  /// Construit la rangée d'icônes des capteurs au centre
  Widget _buildSensorIcons() {
    return Align(
      alignment: const Alignment(-0.40, 0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 260),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SensorIconsRow(
            activeSensorTypes: alert.sensorTypes,
          ),
        ),
      ),
    );
  }

  /// Gère le changement de statut de l'alerte
  void _handleToggleAlert(BuildContext context, bool isActive) {
    context.read<AlertBloc>().add(
      AlertToggleStatus(
        alertId: alert.id,
        isActive: isActive,
      ),
    );
  }

  /// Gère l'affichage des détails de l'alerte (modification)
  void _handleShowAlertDetails(BuildContext context) {
    context.read<AlertBloc>().add(
      AlertShowEditView(alertId: alert.id),
    );
  }
}
