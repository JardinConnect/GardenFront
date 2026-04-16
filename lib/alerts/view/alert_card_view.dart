import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:garden_ui/ui/models/sensor_threshold.dart';
import 'package:garden_ui/ui/widgets/organisms/SensorAlertCard/sensor_alert_card.dart';

import '../bloc/alert_bloc.dart';
import '../models/alert_models.dart';
import '../../common/widgets/empty_state_widget.dart';

class AlertCardView extends StatelessWidget {
  final List<Alert> alerts;

  const AlertCardView({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.thunderstorm_outlined,
        message: 'Aucune alerte configurée',
        subtitle: 'Créez votre première alerte en cliquant sur le bouton +',
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: GardenSpace.paddingMd,
        vertical: GardenSpace.paddingMd,
      ),
      child: Wrap(
        spacing: GardenSpace.gapMd,
        runSpacing: GardenSpace.gapMd,
        // Clé stable par alerte pour préserver le state de pagination
        children:
            alerts
                .map((a) => _AlertCard(key: ValueKey(a.id), alert: a))
                .toList(),
      ),
    );
  }
}

class _AlertCard extends StatefulWidget {
  final Alert alert;

  const _AlertCard({super.key, required this.alert});

  @override
  State<_AlertCard> createState() => _AlertCardState();
}

class _AlertCardState extends State<_AlertCard> {
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.alert.isActive;
  }

  @override
  Widget build(BuildContext context) {
    final sensors = widget.alert.sensors;
    if (sensors.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      width: 400,
      child: SensorAlertCard(
        title: widget.alert.title,
        sensors: sensors
            .map((s) => (
                  sensorType: s.sensorType,
                  threshold: SensorThreshold(
                    thresholds: s.threshold.thresholds.take(6).toList(),
                  ),
                  iconColor: getSensorColor(s.sensorType),
                ))
            .toList(),
        isEnabled: _isEnabled,
        onToggle: (value) {
          setState(() => _isEnabled = value);
          context.read<AlertBloc>().add(
            AlertToggleStatus(alertId: widget.alert.id, isActive: value),
          );
        },
        onTap: () => context.read<AlertBloc>().add(
          AlertShowEditView(alertId: widget.alert.id),
        ),
      ),
    );
  }
}
