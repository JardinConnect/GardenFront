import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garden_ui/ui/components.dart';
import '../../models/alert_models.dart';

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
    final color = getSensorColor(sensorType, index: index);

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
}
