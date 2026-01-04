import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garden_ui/ui/components.dart';
import '../../models/alert_models.dart';

/// Composant d'affichage d'une ligne d'icônes de capteurs
class SensorIconsRow extends StatelessWidget {
  /// Liste des types de capteurs actifs à afficher
  final List<SensorType> activeSensorTypes;

  /// Taille des icônes
  final GardenIconSize iconSize;

  const SensorIconsRow({
    super.key,
    required this.activeSensorTypes,
    this.iconSize = GardenIconSize.sm,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Température rouge
        _buildSensorIcon(SensorType.temperature, activeSensorTypes.contains(SensorType.temperature), 0),
        const SizedBox(width: 6),
        // Température marron (deuxième thermomètre)
        _buildSensorIcon(SensorType.temperature, activeSensorTypes.contains(SensorType.temperature), 1),
        const SizedBox(width: 6),
        // Humidité surface
        _buildSensorIcon(SensorType.humiditySurface, activeSensorTypes.contains(SensorType.humiditySurface), 2),
        const SizedBox(width: 6),
        // Humidité profondeur
        _buildSensorIcon(SensorType.humidityDepth, activeSensorTypes.contains(SensorType.humidityDepth), 3),
        const SizedBox(width: 6),
        // Luminosité
        _buildSensorIcon(SensorType.light, activeSensorTypes.contains(SensorType.light), 4),
        const SizedBox(width: 6),
        // Pluie
        _buildSensorIcon(SensorType.rain, activeSensorTypes.contains(SensorType.rain), 5),
      ],
    );
  }

  /// Widget local pour afficher une icône SVG avec une taille personnalisée
  Widget _customSensorIcon(String iconName, double size, Color color) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: SvgPicture.asset(
          'lib/ui/assets/icons/Icon=$iconName, Size=75.svg',
          package: 'garden_ui',
          width: size,
          height: size,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ),
    );
  }

  /// Construit une icône de capteur avec fond coloré et état actif/inactif
  Widget _buildSensorIcon(SensorType sensorType, bool isActive, int index) {
    final color = getSensorColor(sensorType, index: index);

    // Augmentation de la taille du conteneur uniquement
    const double iconContainerSize = 36; // Anciennement 28
    // Taille personnalisée pour l'icône
    const double customIconSize = 20.0; // Taille personnalisée souhaitée

    return Container(
      width: iconContainerSize,
      height: iconContainerSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isActive ? color.withValues(alpha: 0.2) : Colors.grey.shade200,
      ),
      child: Center(
        child: _customSensorIcon(
          sensorType.iconName,
          customIconSize,
          isActive ? color : Colors.grey.shade500,
        ),
      ),
    );
  }
}