import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:garden_ui/ui/models/sensor_threshold.dart';
import 'package:garden_ui/ui/widgets/organisms/SensorAlertCard/sensor_alert_card.dart';

import '../bloc/alert_bloc.dart';
import '../models/alert_models.dart';

class AlertCardView extends StatelessWidget {
  final List<Alert> alerts;

  const AlertCardView({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const Center(child: Text('Aucune alerte disponible'));
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: GardenSpace.paddingMd),
      child: Wrap(
        spacing: GardenSpace.paddingMd,
        runSpacing: GardenSpace.paddingMd,
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

    return SizedBox(
      width: 400,
      child: SensorAlertCard(
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
        // Tap sur la carte → ouvre l'édition
        onTap:
            () => context.read<AlertBloc>().add(
              AlertShowEditView(alertId: widget.alert.id),
            ),
      ),
    );
  }
}
