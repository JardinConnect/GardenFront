import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/alert_bloc.dart';
import '../widgets/alerts/sensor_alert_carousel.dart';
import '../models/alert_models.dart';

/// Composant pour l'affichage en cartes des alertes avec carousel
/// Affiche les alertes regroupées par capteurs dans des cartes avec navigation
class AlertCardView extends StatelessWidget {
  final List<SensorAlertData> sensorAlerts;

  const AlertCardView({super.key, required this.sensorAlerts});

  @override
  Widget build(BuildContext context) {
    // Si aucune donnée, afficher un message
    if (sensorAlerts.isEmpty) {
      return const Center(
        child: Text('Aucune alerte de capteur disponible'),
      );
    }

    // Grouper les alertes par type pour créer les cartes
    // Pour l'instant on affiche toutes les alertes dans des cartes individuelles
    // TODO: Implémenter la logique de groupement si nécessaire
    final cards = _buildAlertCards(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: cards,
      ),
    );
  }

  /// Construit la liste des cartes d'alerte
  List<Widget> _buildAlertCards(BuildContext context) {
    // Pour chaque alerte, créer une carte avec carousel
    // Si plusieurs alertes doivent être regroupées, adapter cette logique
    return sensorAlerts.map((sensorAlert) {
      return SizedBox(
        width: 400,
        child: SensorAlertCarousel(
          sensors: [sensorAlert], // Une seule alerte par carte pour l'instant
          onToggle: (sensorId, isEnabled) => _handleToggleAlert(context, sensorId, isEnabled),
        ),
      );
    }).toList();
  }

  /// Gère l'activation/désactivation d'une alerte de capteur
  void _handleToggleAlert(BuildContext context, String alertId, bool isEnabled) {
    context.read<AlertBloc>().add(
      AlertToggleStatus(
        alertId: alertId,
        isActive: isEnabled,
      ),
    );
  }
}
