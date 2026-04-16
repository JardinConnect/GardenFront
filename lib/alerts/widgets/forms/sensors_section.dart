import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import '../../models/alert_models.dart';

const _availableSensors = [
  (type: SensorType.airTemperature, displayName: 'Température air'),
  (type: SensorType.rain, displayName: 'Humidité air'),
  (type: SensorType.light, displayName: 'Luminosité'),
  (type: SensorType.soilTemperature, displayName: 'Température sol'),
  (type: SensorType.humiditySurface, displayName: 'Humidité basse sol'),
  (type: SensorType.humidityDepth, displayName: 'Humidité haute sol'),
];

/// Classe représentant un capteur sélectionné avec son type et son index
class SelectedSensor {
  final SensorType type;
  final int index;

  const SelectedSensor(this.type, this.index);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SelectedSensor &&
            runtimeType == other.runtimeType &&
            type == other.type &&
            index == other.index;
  }

  @override
  int get hashCode => type.hashCode ^ index.hashCode;
}

/// Widget de sélection des capteurs pour une alerte
/// Affiche une grille de capteurs sélectionnables avec distinction visuelle
class SensorsSection extends StatelessWidget {
  /// Liste des capteurs actuellement sélectionnés
  final List<SelectedSensor> selectedSensors;

  /// Callback appelé lors du changement de sélection
  final ValueChanged<List<SelectedSensor>>? onSelectionChanged;

  /// Mode compact pour mobile : icône plus petite, ratio plus carré
  final bool compact;

  const SensorsSection({
    super.key,
    this.selectedSensors = const [],
    this.onSelectionChanged,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return _buildSensorsGrid();
  }

  Widget _buildSensorsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: GardenSpace.gapMd,
        mainAxisSpacing: GardenSpace.gapMd,
        childAspectRatio: compact ? 1.1 : 1.7,
      ),
      itemCount: _availableSensors.length,
      itemBuilder: (context, i) => _buildSensorCard(_availableSensors[i]),
    );
  }

  Widget _buildSensorCard(({SensorType type, String displayName}) sensor) {
    final isSelected = selectedSensors.any((s) => s.type == sensor.type);

    return GestureDetector(
      onTap: () {
        final current = List<SelectedSensor>.from(selectedSensors);
        if (isSelected) {
          current.removeWhere((s) => s.type == sensor.type);
        } else {
          current.add(SelectedSensor(sensor.type, 0));
        }
        onSelectionChanged?.call(current);
      },
      child: Container(
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: GardenColors.primary.shade500, width: 1)
              : null,
          borderRadius: GardenRadius.radiusSm,
        ),
        child: GardenCard(
          hasShadow: true,
          child: Stack(
            children: [
              Center(
                child: GardenIcon(
                  iconName: sensor.type.iconName,
                  size: compact ? GardenIconSize.md : GardenIconSize.lg,
                  color: getSensorColor(sensor.type),
                ),
              ),
              _buildSelectionIndicator(isSelected),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator(bool isSelected) {
    final size = compact ? 14.0 : 20.0;
    final iconSize = compact ? 9.0 : 12.0;
    final pos = compact ? 0.0 : 8.0;

    return Positioned(
      top: pos,
      right: pos,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? GardenColors.primary.shade500 : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? GardenColors.primary.shade500
                : Colors.grey.shade400,
            width: compact ? 1.5 : 2,
          ),
        ),
        child: isSelected
            ? Icon(Icons.check, size: iconSize, color: Colors.white)
            : null,
      ),
    );
  }
}
