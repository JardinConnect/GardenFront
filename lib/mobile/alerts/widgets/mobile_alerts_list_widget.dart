import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garden_connect/alerts/alerts.dart';
import 'package:garden_connect/common/widgets/small_toggle.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:go_router/go_router.dart';

const int _flexTitle   = 3;
const int _flexSensors = 2;
const int _flexToggle  = 1;

/// Liste des alertes en mode tableau pour la version mobile.
///
/// Affiche un en-tête de colonnes suivi de la liste des alertes.
/// Chaque ligne permet d'accéder au formulaire d'édition de l'alerte correspondante.
class MobileAlertsListWidget extends StatelessWidget {
  /// Liste des alertes à afficher.
  final List<Alert> alerts;

  const MobileAlertsListWidget({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const Center(child: Text('Aucune alerte disponible'));
    }

    return Column(
      children: [
        GardenCard(
          child: _AlertRow(
            title: Text("Nom de l'alerte", style: GardenTypography.caption),
            sensors: Center(child: Text("Capteurs", style: GardenTypography.caption)),
            toggle: Center(child: Text("Actif", style: GardenTypography.caption)),
          ),
        ),
        SizedBox(height: GardenSpace.gapMd),
        Expanded(
          child: ListView.separated(
            itemCount: alerts.length,
            separatorBuilder: (_, __) => SizedBox(height: GardenSpace.gapSm),
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return GardenCard(
                hasBorder: true,
                onTap: () => context.push('/m/alerts/${alert.id}/edit'),
                child: _AlertRow(
                  title: Text(
                    alert.title,
                    style: GardenTypography.caption,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  sensors: Center(
                    child: _MobileSensorIconsGrid(
                      activeSensorTypes:
                          alert.sensors.map((s) => s.sensorType).toList(),
                    ),
                  ),
                  toggle: Center(
                    child: SmallToggle(
                      enabledIcon: Icons.check,
                      isEnabled: alert.isActive,
                      onToggle: (_) => context.read<AlertBloc>().add(
                        AlertToggleStatus(
                          alertId: alert.id,
                          isActive: !alert.isActive,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Ligne partagée entre l'en-tête et les items de la liste.
///
/// Garantit l'alignement des colonnes entre l'en-tête et les données.
class _AlertRow extends StatelessWidget {
  final Widget title;
  final Widget sensors;
  final Widget toggle;

  const _AlertRow({
    required this.title,
    required this.sensors,
    required this.toggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: _flexTitle, child: title),
        Expanded(flex: _flexSensors, child: Center(child: sensors)),
        Expanded(flex: _flexToggle, child: Center(child: toggle)),
      ],
    );
  }
}

/// Grille 2×3 d'icônes représentant l'état d'activation de chaque type de capteur.
class _MobileSensorIconsGrid extends StatelessWidget {
  /// Types de capteurs actifs pour l'alerte.
  final List<SensorType> activeSensorTypes;

  static const _allSensors = [
    SensorType.airTemperature,
    SensorType.soilTemperature,
    SensorType.humiditySurface,
    SensorType.humidityDepth,
    SensorType.light,
    SensorType.rain,
  ];

  static const double _containerSize = 22.0;
  static const double _iconSize = 13.0;
  static const double _gap = 3.0;

  const _MobileSensorIconsGrid({required this.activeSensorTypes});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildRow(_allSensors.sublist(0, 3), [0, 1, 2]),
        const SizedBox(height: _gap),
        _buildRow(_allSensors.sublist(3, 6), [3, 4, 5]),
      ],
    );
  }

  Widget _buildRow(List<SensorType> sensors, List<int> indices) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(sensors.length, (i) {
        final sensor = sensors[i];
        final isActive = activeSensorTypes.contains(sensor);
        final color = getSensorColor(sensor, index: indices[i]);
        return Padding(
          padding: EdgeInsets.only(left: i == 0 ? 0 : _gap),
          child: Container(
            width: _containerSize,
            height: _containerSize,
            decoration: BoxDecoration(
              borderRadius: GardenRadius.radiusXs,
              color: isActive
                  ? color.withValues(alpha: 0.2)
                  : Colors.grey.shade200,
            ),
            child: Center(
              child: SvgPicture.asset(
                'lib/ui/assets/icons/Icon=${sensor.iconName}, Size=75.svg',
                package: 'garden_ui',
                width: _iconSize,
                height: _iconSize,
                colorFilter: ColorFilter.mode(
                  isActive ? color : Colors.grey.shade500,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
