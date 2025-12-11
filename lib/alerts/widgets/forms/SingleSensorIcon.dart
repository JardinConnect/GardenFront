import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

/// Icône isolée pour un capteur
class SingleSensorIcon extends StatelessWidget {
  /// Type de capteur à afficher
  final SensorType sensorType;

  /// Si le capteur est actif ou non (change la couleur)
  final bool isActive;

  /// Taille du conteneur (carré)
  final double containerSize;

  /// Taille de l'icône SVG interne
  final double iconSize;

  /// Index éventuel utilisé pour distinguer les thermomètres (rouge/marron)
  final int index;

  const SingleSensorIcon({
    super.key,
    required this.sensorType,
    required this.isActive,
    this.index = 0,
    this.containerSize = 36,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getSensorColor(sensorType, index);

    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isActive ? color.withValues(alpha: 0.2) : Colors.grey.shade200,
      ),
      child: Center(
        child: SvgPicture.asset(
          'lib/ui/assets/icons/Icon=${sensorType.iconName}, Size=75.svg',
          package: 'garden_ui',
          width: iconSize,
          height: iconSize,
          colorFilter: ColorFilter.mode(
            isActive ? color : Colors.grey.shade500,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  /// Détermine la couleur du capteur (même logique que ta version précédente)
  Color _getSensorColor(SensorType sensorType, int index) {
    if (sensorType == SensorType.temperature && index == 0) {
      return GardenColors.redAlert.shade500;
    }
    if (sensorType == SensorType.temperature && index == 1) {
      return Colors.brown;
    }

    switch (sensorType) {
      case SensorType.temperature:
        return GardenColors.redAlert.shade500;
      case SensorType.humiditySurface:
        return GardenColors.blueInfo.shade400;
      case SensorType.humidityDepth:
        return GardenColors.blueInfo.shade400;
      case SensorType.light:
        return GardenColors.secondary.shade300;
      case SensorType.rain:
        return GardenColors.blueInfo.shade400;
    }
  }
}
