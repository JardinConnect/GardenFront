import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/components.dart';
import '../bloc/alert_bloc.dart';
import '../models/alert_models.dart';
import '../widgets/alerts/sensor_icons_row.dart';

/// Composant pour l'affichage en liste des alertes
class AlertListView extends StatelessWidget {
  final List<Alert> alerts;

  const AlertListView({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const Center(child: Text('Aucune alerte disponible'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: GardenCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: SizedBox(
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
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
                        ),

                        TooltipIconButton(
                          onPressed: () {
                            // TODO Action personnalisée ici
                          },
                          size: TooltipSize.lg,
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: alert.isActive,
                          onChanged: (value) {
                            context.read<AlertBloc>().add(
                              AlertToggleStatus(
                                alertId: alert.id,
                                isActive: value,
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    Align(
                      alignment: Alignment.centerLeft + const Alignment(0.55, 0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 260),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SensorIconsRow(
                            activeSensorTypes: alert.sensorTypes,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
