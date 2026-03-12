import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/alerts/alerts.dart';
import 'package:garden_ui/ui/components.dart';

import '../../common/widgets/generic_list_item.dart';

class AlertListView extends StatelessWidget {
  final List<Alert> alerts;

  const AlertListView({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const Center(child: Text('Aucune alerte disponible'));
    }

    return GenericListWidget(
      items:
          alerts
              .map(
                (alert) => GenericListItem(
                  label: alert.title,
                  hoverable: true,
                  // Icônes des capteurs associés à l'alerte
                  extraWidget: SensorIconsRow(
                    activeSensorTypes:
                        alert.sensors.map((s) => s.sensorType).toList(),
                    iconSize: GardenIconSize.sm,
                  ),
                  // Toggle actif/inactif
                  trailingWidget: GardenToggle(
                    enabledIcon: Icons.check,
                    isEnabled: alert.isActive,
                    onToggle:
                        (_) => context.read<AlertBloc>().add(
                          AlertToggleStatus(
                            alertId: alert.id,
                            isActive: !alert.isActive,
                          ),
                        ),
                  ),
                  // Tap sur la ligne → ouvre l'édition
                  onTap:
                      () => context.read<AlertBloc>().add(
                        AlertShowEditView(alertId: alert.id),
                      ),
                ),
              )
              .toList(),
    );
  }
}
