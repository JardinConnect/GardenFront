import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/components.dart';
import '../bloc/alert_bloc.dart';
import '../repository/alert_repository.dart';
import '../widgets/forms/alert_add_header.dart';
import '../widgets/forms/alert_configuration_form.dart';
import '../widgets/forms/sensors_section.dart';
import '../widgets/forms/alert_table_section.dart';
import '../widgets/common/snackbar.dart' as custom_snackbar;

/// Vue pour créer une nouvelle alerte
/// Permet de configurer le nom, les capteurs et les seuils d'alerte
class AlertAddView extends StatefulWidget {
  const AlertAddView({super.key});

  @override
  State<AlertAddView> createState() => _AlertAddViewState();
}

class _AlertAddViewState extends State<AlertAddView> {
  // Contrôleur pour le nom de l'alerte
  final TextEditingController _nameController = TextEditingController();

  // État de la configuration de l'alerte
  List<SelectedSensor> _selectedSensors = [];
  final Map<String, RangeValues> _criticalRanges = {};
  final Map<String, RangeValues> _warningRanges = {};
  bool _isWarningEnabled = true;

  // État du chargement des espaces
  List<Map<String, dynamic>> _spaces = [];
  bool _isLoadingSpaces = true;

  @override
  void initState() {
    super.initState();
    _loadSpaces();
  }

  /// Charge la liste des espaces depuis le repository
  Future<void> _loadSpaces() async {
    try {
      final repository = AlertRepository();
      final spaces = await repository.fetchSpaces();
      setState(() {
        _spaces = spaces;
        _isLoadingSpaces = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingSpaces = false;
      });
      if (mounted) {
        custom_snackbar.showSnackBarError(
          context,
          'Erreur lors du chargement des espaces: $e',
        );
      }
    }
  }

  // Permet de nettoyer les contrôles lors de la fermeture de la vue
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec bouton retour et titre
          const AlertAddHeader(),

          const SizedBox(height: 24),

          // Contenu principal : configuration et aperçu
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Formulaire de configuration
                Expanded(
                  flex: 1,
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

                const SizedBox(width: 16),

                // Aperçu du tableau
                Expanded(
                  flex: 1,
                  child: GardenCard(
                    child: _isLoadingSpaces
                        ? const Center(child: CircularProgressIndicator())
                        : AlertTableSection(spaces: _spaces),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Bouton de création
          Center(
            child: Button(
              label: "Créer Alerte",
              icon: Icons.add_alert,
              onPressed: _handleCreateAlert,
            ),
          ),
        ],
      ),
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

  /// Gère la création de l'alerte
  void _handleCreateAlert() {
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

    // TODO: Appeler le repository pour créer l'alerte
    // final alertRepository = context.read<AlertRepository>();
    // alertRepository.createAlert(
    //   name: name,
    //   cellIds: selectedCellIds,
    //   sensors: {
    //     'critical': _criticalRanges,
    //     'warning': _isWarningEnabled ? _warningRanges : null,
    //   },
    //   isWarningEnabled: _isWarningEnabled,
    // );

    context.read<AlertBloc>().add(AlertHideAddView());
    custom_snackbar.showSnackBarSucces(
      context,
      'Alerte "$name" créée avec succès !',
    );
  }
}

