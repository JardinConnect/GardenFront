import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/components.dart';
import '../bloc/alert_bloc.dart';
import '../repository/alert_repository.dart';
import '../widgets/forms/alert_configuration_form.dart';
import '../widgets/forms/sensors_section.dart';
import '../widgets/forms/alert_table_section.dart';
import '../widgets/forms/alert_danger_zone.dart';
import '../widgets/common/snackbar.dart' as custom_snackbar;

/// Vue pour modifier/visualiser une alerte existante
/// Réutilise les composants de la vue d'ajout avec les données pré-remplies
class AlertEditView extends StatefulWidget {
  final String alertId;

  const AlertEditView({super.key, required this.alertId});

  @override
  State<AlertEditView> createState() => _AlertEditViewState();
}

class _AlertEditViewState extends State<AlertEditView> {
  // Contrôleur pour le nom de l'alerte
  final TextEditingController _nameController = TextEditingController();

  // État de la configuration de l'alerte
  List<SelectedSensor> _selectedSensors = [];
  final Map<String, RangeValues> _criticalRanges = {};
  final Map<String, RangeValues> _warningRanges = {};
  bool _isWarningEnabled = true;
  List<String> _selectedCellIds = [];

  // État de chargement
  bool _isLoading = true;
  String _alertName = '';

  @override
  void initState() {
    super.initState();
    _loadAlertData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Charge les données de l'alerte depuis le repository
  Future<void> _loadAlertData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Récupérer les données depuis le Repository
      final alertRepository = AlertRepository();
      final alertData = await alertRepository.fetchAlertDetails(widget.alertId);

      setState(() {
        // Charger le nom de l'alerte
        _nameController.text = alertData['name'] as String;
        _alertName = alertData['name'] as String;

        // Charger les IDs des cellules sélectionnées
        _selectedCellIds = (alertData['cellIds'] as List).cast<String>();

        // Charger l'état de l'activation des avertissements
        _isWarningEnabled = alertData['isWarningEnabled'] as bool;

        // Charger les capteurs sélectionnés
        final sensorsData = alertData['sensors'] as List;
        _selectedSensors = sensorsData.map((sensorJson) {
          final typeString = sensorJson['type'] as String;
          final type = _parseSensorType(typeString);
          final index = sensorJson['index'] as int;

          // Charger les plages critiques et d'avertissement
          final key = '${type.index}_$index';

          if (sensorJson['criticalRange'] != null) {
            final criticalRange = sensorJson['criticalRange'] as Map;
            _criticalRanges[key] = RangeValues(
              (criticalRange['start'] as num).toDouble(),
              (criticalRange['end'] as num).toDouble(),
            );
          }

          if (sensorJson['warningRange'] != null) {
            final warningRange = sensorJson['warningRange'] as Map;
            _warningRanges[key] = RangeValues(
              (warningRange['start'] as num).toDouble(),
              (warningRange['end'] as num).toDouble(),
            );
          }

          return SelectedSensor(type, index);
        }).toList();

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        custom_snackbar.showSnackBarError(
          context,
          'Erreur lors du chargement de l\'alerte: $e',
        );
      }
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec bouton retour et titre modifié
          _buildHeader(context),

          const SizedBox(height: 24),

          // Contenu principal : configuration et aperçu
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Formulaire de configuration (gauche)
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: AlertConfigurationForm(
                      nameController: _nameController,
                      nameValidator: _validateAlertName,
                      selectedSensors: _selectedSensors,
                      onSensorsChanged: _onSensorsChanged,
                      criticalRanges: _criticalRanges,
                      warningRanges: _warningRanges,
                      isWarningEnabled: _isWarningEnabled,
                      onCriticalRangeChanged: _onCriticalRangeChanged,
                      onWarningRangeChanged: _onWarningRangeChanged,
                      onWarningEnabledChanged: _onWarningEnabledChanged,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Colonne droite : Tableau des cellules + Zone de danger
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Tableau de sélection des cellules (hauteur réduite)
                      Expanded(
                        flex: 3,
                        child: GardenCard(
                          child: AlertTableSection(
                            selectedSpaceIds: _selectedCellIds,
                            onSelectionChanged: (selectedIds) {
                              setState(() {
                                _selectedCellIds = selectedIds;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Zone de danger en dessous
                      AlertDangerZone(
                        alertId: widget.alertId,
                        alertName: _alertName,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Bouton de sauvegarde des modifications
          Center(
            child: Button(
              label: "Enregistrer les modifications",
              icon: Icons.save,
              onPressed: _handleSaveAlert,
            ),
          ),
        ],
      ),
    );
  }

  /// Construit l'en-tête personnalisé pour la modification
  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bouton retour
        TextButton(
          onPressed: () => _handleBack(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back_ios, size: 16),
              SizedBox(width: 4),
              Text(
                'Retour',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Titre
        Text(
          'Modifier l\'alerte',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ],
    );
  }

  /// Gère le changement de sélection des capteurs
  void _onSensorsChanged(List<SelectedSensor> sensors) {
    setState(() {
      _selectedSensors = sensors;

      // Initialiser les plages pour les nouveaux capteurs
      for (final sensor in sensors) {
        final key = '${sensor.type.index}_${sensor.index}';
        _criticalRanges.putIfAbsent(key, () => _getDefaultCriticalRange(sensor));
        _warningRanges.putIfAbsent(key, () => _getDefaultWarningRange(sensor));
      }

      // Nettoyer les plages des capteurs désélectionnés
      _criticalRanges.removeWhere((key, _) =>
        !sensors.any((s) => '${s.type.index}_${s.index}' == key)
      );
      _warningRanges.removeWhere((key, _) =>
        !sensors.any((s) => '${s.type.index}_${s.index}' == key)
      );
    });
  }

  /// Retourne la plage critique par défaut selon le type de capteur
  RangeValues _getDefaultCriticalRange(SelectedSensor sensor) {
    switch (sensor.type) {
      case SensorType.temperature: return const RangeValues(-10, 40);
      case SensorType.humiditySurface:
      case SensorType.humidityDepth: return const RangeValues(10, 90);
      case SensorType.light: return const RangeValues(100, 15000);
      case SensorType.rain: return const RangeValues(0, 80);
    }
  }

  /// Retourne la plage d'avertissement par défaut selon le type de capteur
  RangeValues _getDefaultWarningRange(SelectedSensor sensor) {
    switch (sensor.type) {
      case SensorType.temperature: return const RangeValues(0, 30);
      case SensorType.humiditySurface:
      case SensorType.humidityDepth: return const RangeValues(20, 80);
      case SensorType.light: return const RangeValues(500, 10000);
      case SensorType.rain: return const RangeValues(5, 70);
    }
  }

  /// Gère le changement de plage critique
  void _onCriticalRangeChanged(SelectedSensor sensor, RangeValues range) {
    setState(() => _criticalRanges['${sensor.type.index}_${sensor.index}'] = range);
  }

  /// Gère le changement de plage d'avertissement
  void _onWarningRangeChanged(SelectedSensor sensor, RangeValues range) {
    setState(() => _warningRanges['${sensor.type.index}_${sensor.index}'] = range);
  }

  /// Gère l'activation/désactivation des avertissements
  void _onWarningEnabledChanged(bool enabled) {
    setState(() => _isWarningEnabled = enabled);
  }

  /// Valide le nom de l'alerte
  String? _validateAlertName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le nom de l\'alerte est obligatoire';
    }
    if (value.trim().length < 3) {
      return 'Le nom doit contenir au moins 3 caractères';
    }
    return null;
  }

  /// Gère le retour à la vue précédente
  void _handleBack(BuildContext context) {
    context.read<AlertBloc>().add(AlertHideAddView());
  }

  /// Gère la sauvegarde des modifications
  void _handleSaveAlert() {
    final name = _nameController.text.trim();
    final validationError = _validateAlertName(name);

    if (validationError != null) {
      custom_snackbar.showSnackBarError(context, validationError);
      return;
    }

    if (_selectedSensors.isEmpty) {
      custom_snackbar.showSnackBarError(
        context,
        'Veuillez sélectionner au moins un capteur',
      );
      return;
    }

    if (_selectedCellIds.isEmpty) {
      custom_snackbar.showSnackBarError(
        context,
        'Veuillez sélectionner au moins une cellule',
      );
      return;
    }

    // TODO: Appeler le repository pour mettre à jour l'alerte
    // final alertRepository = context.read<AlertRepository>();
    // alertRepository.updateAlert(
    //   alertId: widget.alertId,
    //   name: name,
    //   cellIds: _selectedCellIds,
    //   sensors: {
    //     'critical': _criticalRanges,
    //     'warning': _isWarningEnabled ? _warningRanges : null,
    //   },
    //   isWarningEnabled: _isWarningEnabled,
    // );

    context.read<AlertBloc>().add(AlertHideAddView());
    custom_snackbar.showSnackBarSucces(
      context,
      'Alerte "$name" modifiée avec succès !',
    );
  }
}

