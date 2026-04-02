import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:garden_ui/ui/models/sensor_threshold.dart';
import 'package:garden_ui/ui/widgets/organisms/SensorAlertCard/sensor_alert_card.dart';
import 'package:go_router/go_router.dart';

import '../../../alerts/bloc/alert_bloc.dart';
import '../../../alerts/models/alert_models.dart';
import '../../../common/widgets/empty_state_widget.dart';

/// Liste des alertes en mode carte pour la version mobile.
///
/// Chaque alerte est affichée sous forme de [SensorAlertCard] occupant
/// toute la largeur disponible. La pagination permet de naviguer entre
/// les capteurs d'une même alerte.
class MobileAlertsCardWidget extends StatelessWidget {
  /// Liste des alertes à afficher.
  final List<Alert> alerts;

  const MobileAlertsCardWidget({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.thunderstorm_outlined,
        message: 'Aucune alerte configurée',
        subtitle: 'Créez votre première alerte en cliquant sur le bouton +',
      );
    }

    return ListView.separated(
      itemCount: alerts.length,
      separatorBuilder: (_, __) => SizedBox(height: GardenSpace.gapMd),
      itemBuilder: (context, index) =>
          _MobileAlertCard(key: ValueKey(alerts[index].id), alert: alerts[index]),
    );
  }
}

/// Carte individuelle d'une alerte avec gestion de la pagination des capteurs.
class _MobileAlertCard extends StatefulWidget {
  /// Alerte à afficher.
  final Alert alert;

  const _MobileAlertCard({super.key, required this.alert});

  @override
  State<_MobileAlertCard> createState() => _MobileAlertCardState();
}

class _MobileAlertCardState extends State<_MobileAlertCard> {
  late bool _isEnabled;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.alert.isActive;
  }

  @override
  Widget build(BuildContext context) {
    final sensors = widget.alert.sensors;
    if (sensors.isEmpty) return const SizedBox.shrink();

    final sensor = sensors[_currentPage.clamp(0, sensors.length - 1)];

    return SensorAlertCard(
      title: widget.alert.title,
      sensorType: sensor.sensorType,
      threshold: SensorThreshold(
        thresholds: sensor.threshold.thresholds.take(6).toList(),
      ),
      isEnabled: _isEnabled,
      onToggle: (value) {
        setState(() => _isEnabled = value);
        context.read<AlertBloc>().add(
          AlertToggleStatus(alertId: widget.alert.id, isActive: value),
        );
      },
      totalPages: sensors.length,
      currentPage: _currentPage,
      onPageChanged: (page) => setState(() => _currentPage = page),
      iconColor: getSensorColor(sensor.sensorType),
      onTap: () => context.push('/m/alerts/${widget.alert.id}/edit'),
    );
  }
}
