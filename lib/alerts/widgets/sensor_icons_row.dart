import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

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

  /// Construit une icône de capteur avec fond coloré et état actif/inactif
  Widget _buildSensorIcon(SensorType sensorType, bool isActive, int index) {
    final color = _getSensorColor(sensorType, index);

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4), // Coins légèrement arrondis pour un carré
        color: isActive ? color.withValues(alpha: 0.2) : Colors.grey.shade200, // Couleurs plus légères
      ),
      child: Center(
        child: GardenIcon(
          iconName: sensorType.iconName,
          size: GardenIconSize.sm,
          color: isActive ? color : Colors.grey.shade500, // Couleur d'origine pour l'icône
        ),
      ),
    );
  }

  /// Retourne la couleur appropriée pour chaque type de capteur
  Color _getSensorColor(SensorType sensorType, int index) {
    // Thermomètre rouge (index 0)
    if (sensorType == SensorType.temperature && index == 0) {
      return GardenColors.redAlert.shade500;
    }
    // Thermomètre marron (index 1)
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