import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

/// Composant pour la section de sélection des capteurs
class SensorsSection extends StatefulWidget {
  final List<SensorType> selectedSensors;
  final ValueChanged<List<SensorType>>? onSelectionChanged;

  const SensorsSection({
    super.key,
    this.selectedSensors = const [],
    this.onSelectionChanged,
  });

  @override
  State<SensorsSection> createState() => _SensorsSectionState();
}

class _SensorsSectionState extends State<SensorsSection> {
  late List<_SensorData> _selectedSensors;

  @override
  void initState() {
    super.initState();
    // Convertir la liste de SensorType en liste de _SensorData sélectionnés
    _selectedSensors = [];
    for (final sensorType in widget.selectedSensors) {
      final matchingSensors = _allSensors.where((s) => s.type == sensorType).toList();
      _selectedSensors.addAll(matchingSensors);
    }
  }

  /// Liste de tous les capteurs disponibles (incluant 2 thermomètres)
  final List<_SensorData> _allSensors = [
    _SensorData(SensorType.temperature, 'Température rouge', 0),
    _SensorData(SensorType.temperature, 'Température marron', 1),
    _SensorData(SensorType.humiditySurface, 'Humidité surface', 2),
    _SensorData(SensorType.humidityDepth, 'Humidité profondeur', 3),
    _SensorData(SensorType.light, 'Luminosité', 4),
    _SensorData(SensorType.rain, 'Pluie', 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Grille de capteurs
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.7,
          ),
          itemCount: _allSensors.length,
          itemBuilder: (context, index) {
            final sensor = _allSensors[index];
            final isSelected = _isSensorSelected(sensor);

            return GestureDetector(
              onTap: () => _toggleSensor(sensor),
              child: Container(
                decoration: BoxDecoration(
                  border: isSelected
                    ? Border.all(
                        color: GardenColors.primary.shade500,
                        width: 1,
                      )
                    : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GardenCard(
                  hasShadow: true,
                  child: Stack(
                    children: [
                      // Contenu principal
                      Center(
                        child: GardenIcon(
                          iconName: sensor.type.iconName,
                          size: GardenIconSize.lg,
                          color: _getSensorColor(sensor),
                        ),
                      ),

                      // Cercle de sélection en haut à droite
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                              ? GardenColors.primary.shade500
                              : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                ? GardenColors.primary.shade500
                                : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.white,
                              )
                            : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Vérifie si un capteur est sélectionné
  bool _isSensorSelected(_SensorData sensor) {
    return _selectedSensors.any((s) => s.type == sensor.type && s.index == sensor.index);
  }

  /// Toggle la sélection d'un capteur
  void _toggleSensor(_SensorData sensor) {
    setState(() {
      if (_isSensorSelected(sensor)) {
        _selectedSensors.removeWhere((s) => s.type == sensor.type && s.index == sensor.index);
      } else {
        _selectedSensors.add(sensor);
      }
    });

    // Convertir en liste de SensorType pour le callback
    final sensorTypes = _selectedSensors.map((s) => s.type).toSet().toList();
    widget.onSelectionChanged?.call(sensorTypes);
  }

  /// Retourne la couleur appropriée pour chaque capteur
  Color _getSensorColor(_SensorData sensor) {
    // Thermomètre rouge (index 0)
    if (sensor.type == SensorType.temperature && sensor.index == 0) {
      return GardenColors.redAlert.shade500;
    }
    // Thermomètre marron (index 1)
    if (sensor.type == SensorType.temperature && sensor.index == 1) {
      return Colors.brown;
    }

    switch (sensor.type) {
      case SensorType.temperature:
        return GardenColors.redAlert.shade500;
      case SensorType.humiditySurface:
        return GardenColors.blueInfo.shade400;
      case SensorType.humidityDepth:
        return GardenColors.blueInfo.shade600;
      case SensorType.light:
        return GardenColors.secondary.shade400;
      case SensorType.rain:
        return GardenColors.blueInfo.shade500;
    }
  }
}

/// Classe de données pour un capteur avec son index
class _SensorData {
  final SensorType type;
  final String displayName;
  final int index;

  const _SensorData(this.type, this.displayName, this.index);
}
