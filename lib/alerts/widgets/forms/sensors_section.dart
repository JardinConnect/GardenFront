import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:garden_ui/ui/enums/sensor_type.dart';
import '../../repository/alert_repository.dart';
import '../../models/alert_models.dart';

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
/// Charge la liste des capteurs disponibles depuis le repository
class SensorsSection extends StatefulWidget {
  /// Liste des capteurs actuellement sélectionnés
  final List<SelectedSensor> selectedSensors;

  /// Callback appelé lors du changement de sélection
  final ValueChanged<List<SelectedSensor>>? onSelectionChanged;

  const SensorsSection({
    super.key,
    this.selectedSensors = const [],
    this.onSelectionChanged,
  });

  @override
  State<SensorsSection> createState() => _SensorsSectionState();
}

class _SensorsSectionState extends State<SensorsSection> {
  // Liste interne des capteurs sélectionnés pour la gestion de l'état
  late List<_SensorData> _selectedSensors;

  // Liste de tous les capteurs disponibles chargés depuis l'API
  List<_SensorData> _allSensors = [];

  // État de chargement
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAvailableSensors();
  }

  /// Charge la liste des capteurs disponibles depuis le repository
  Future<void> _loadAvailableSensors() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Récupère les capteurs disponibles depuis le repository
      final repository = AlertRepository();
      final sensorsData = await repository.fetchAvailableSensors();

      // Convertit les données JSON en objets _SensorData
      final loadedSensors = sensorsData.map((json) {
        return _SensorData(
          _parseSensorType(json['type'] as String),
          json['displayName'] as String,
          json['index'] as int,
        );
      }).toList();

      setState(() {
        _allSensors = loadedSensors;

        // Initialiser la sélection à partir des props
        _selectedSensors = _convertToSensorDataList(widget.selectedSensors);

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement des capteurs: $e';
        _isLoading = false;
      });
    }
  }

  /// Parse une chaîne de caractères en SensorType
  SensorType _parseSensorType(String typeString) {
    switch (typeString) {
      case 'temperature':
        return SensorType.temperature;
      case 'humiditySurface':
        return SensorType.humiditySurface;
      case 'humidityDepth':
        return SensorType.humidityDepth;
      case 'light':
        return SensorType.light;
      case 'rain':
        return SensorType.rain;
      default:
        return SensorType.temperature;
    }
  }

  /// Convertit une liste de SelectedSensor en liste de _SensorData
  List<_SensorData> _convertToSensorDataList(List<SelectedSensor> sensors) {
    final List<_SensorData> result = [];
    for (final sensor in sensors) {
      final matching = _allSensors.where(
        (s) => s.type == sensor.type && s.index == sensor.index
      ).toList();
      result.addAll(matching);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // Afficher un indicateur de chargement
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Afficher un message d'erreur
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadAvailableSensors,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Grille de sélection des capteurs
        _buildSensorsGrid(),
      ],
    );
  }

  /// Construit la grille de capteurs sélectionnables
  Widget _buildSensorsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.7,
      ),
      itemCount: _allSensors.length,
      itemBuilder: (context, index) => _buildSensorCard(_allSensors[index]),
    );
  }

  /// Construit une carte de capteur individuelle
  Widget _buildSensorCard(_SensorData sensor) {
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
              // Icône du capteur au centre
              Center(
                child: GardenIcon(
                  iconName: sensor.type.iconName,
                  size: GardenIconSize.lg,
                  color: getSensorColor(sensor.type, index: sensor.index),
                ),
              ),

              // Indicateur de sélection en haut à droite
              _buildSelectionIndicator(isSelected),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit l'indicateur de sélection (cercle avec check)
  Widget _buildSelectionIndicator(bool isSelected) {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? GardenColors.primary.shade500 : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? GardenColors.primary.shade500
                : Colors.grey.shade400,
            width: 2,
          ),
        ),
        child: isSelected
            ? const Icon(Icons.check, size: 12, color: Colors.white)
            : null,
      ),
    );
  }

  /// Vérifie si un capteur est sélectionné
  bool _isSensorSelected(_SensorData sensor) {
    return _selectedSensors.any(
      (s) => s.type == sensor.type && s.index == sensor.index
    );
  }

  /// Bascule la sélection d'un capteur (sélectionner/désélectionner)
  void _toggleSensor(_SensorData sensor) {
    setState(() {
      if (_isSensorSelected(sensor)) {
        // Retirer le capteur de la sélection
        _selectedSensors.removeWhere(
          (s) => s.type == sensor.type && s.index == sensor.index
        );
      } else {
        // Ajouter le capteur à la sélection
        _selectedSensors.add(sensor);
      }
    });

    // Notifier le parent du changement
    final selectedSensorTypes = _selectedSensors
        .map((s) => SelectedSensor(s.type, s.index))
        .toList();
    widget.onSelectionChanged?.call(selectedSensorTypes);
  }
}

/// Classe de données privée pour un capteur avec ses métadonnées
class _SensorData {
  final SensorType type;
  final String displayName;
  final int index;

  const _SensorData(this.type, this.displayName, this.index);
}
