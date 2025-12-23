import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/components.dart';

import '../bloc/alert_bloc.dart';
import '../models/alert_models.dart';
import '../widgets/common/snackbar.dart' as custom_snackbar;
import '../widgets/forms/alert_configuration_form.dart';
import '../widgets/forms/alert_danger_zone.dart';
import '../widgets/forms/alert_table_section.dart';
import '../widgets/forms/sensors_section.dart';

/// Vue pour modifier/visualiser une alerte existante
/// Réutilise les composants de la vue d'ajout avec les données pré-remplies
class AlertEditView extends StatefulWidget {
  final Alert alert;
  final List<Map<String, dynamic>> spaces;
  final Map<String, dynamic> alertDetails;
  final List<Map<String, dynamic>> availableSensors;

  const AlertEditView({
    super.key,
    required this.alert,
    required this.spaces,
    required this.alertDetails,
    required this.availableSensors,
  });

  @override
  State<AlertEditView> createState() => _AlertEditViewState();
}

class _AlertEditViewState extends State<AlertEditView> {
  // Contrôleur pour le nom de l'alerte
  final TextEditingController _nameController = TextEditingController();

  // État de chargement
  bool _isLoading = true;
  List<String> _selectedCellIds = [];

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

  /// Charge les données de l'alerte depuis les détails reçus en paramètre
  void _loadAlertData() {
    try {
      // Charger le nom de l'alerte
      _nameController.text = widget.alertDetails['name'] as String;

      // Charger les IDs des cellules sélectionnées
      _selectedCellIds = (widget.alertDetails['cellIds'] as List).cast<String>();

      // Charger l'état de l'activation des avertissements
      final isWarningEnabled = widget.alertDetails['isWarningEnabled'] as bool;

      // Charger les capteurs sélectionnés
      final sensorsData = widget.alertDetails['sensors'] as List;
      final selectedSensors = <SelectedSensor>[];
      final criticalRanges = <String, RangeValues>{};
      final warningRanges = <String, RangeValues>{};

      for (final sensorJson in sensorsData) {
        final typeString = sensorJson['type'] as String;
        final type = _parseSensorType(typeString);
        final index = sensorJson['index'] as int;

        // Charger les plages critiques et d'avertissement
        final key = '${type.index}_$index';

        if (sensorJson['criticalRange'] != null) {
          final criticalRange = sensorJson['criticalRange'] as Map;
          criticalRanges[key] = RangeValues(
            (criticalRange['start'] as num).toDouble(),
            (criticalRange['end'] as num).toDouble(),
          );
        }

        if (sensorJson['warningRange'] != null) {
          final warningRange = sensorJson['warningRange'] as Map;
          warningRanges[key] = RangeValues(
            (warningRange['start'] as num).toDouble(),
            (warningRange['end'] as num).toDouble(),
          );
        }

        selectedSensors.add(SelectedSensor(type, index));
      }

      // Mettre à jour le bloc avec les données chargées
      context.read<AlertBloc>().add(AlertUpdateSensors(sensors: selectedSensors));
      // Les ranges et isWarningEnabled seront mis à jour par le bloc via copyWith
      final currentState = context.read<AlertBloc>().state as AlertLoaded;
      context.read<AlertBloc>().emit(currentState.copyWith(
        selectedSensors: selectedSensors,
        criticalRanges: criticalRanges,
        warningRanges: warningRanges,
        isWarningEnabled: isWarningEnabled,
      ));

      setState(() {
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
      return const Center(child: CircularProgressIndicator());
    }

    return BlocBuilder<AlertBloc, AlertState>(
      builder: (context, state) {
        if (state is! AlertLoaded) {
          return const Center(child: CircularProgressIndicator());
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
                          selectedSensors: state.selectedSensors,
                          onSensorsChanged: (sensors) {
                            context.read<AlertBloc>().add(AlertUpdateSensors(sensors: sensors));
                          },
                          criticalRanges: state.criticalRanges,
                          warningRanges: state.warningRanges,
                          isWarningEnabled: state.isWarningEnabled,
                          onCriticalRangeChanged: (sensor, range) {
                            context.read<AlertBloc>().add(
                              AlertUpdateCriticalRange(sensor: sensor, range: range),
                            );
                          },
                          onWarningRangeChanged: (sensor, range) {
                            context.read<AlertBloc>().add(
                              AlertUpdateWarningRange(sensor: sensor, range: range),
                            );
                          },
                          onWarningEnabledChanged: (enabled) {
                            context.read<AlertBloc>().add(
                              AlertUpdateWarningEnabled(enabled: enabled),
                            );
                          },
                          availableSensors: widget.availableSensors,
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
                              child: widget.spaces.isEmpty
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : AlertTableSection(
                                      spaces: widget.spaces,
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
                          AlertDangerZone(alert: widget.alert),
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
                  onPressed: () => _handleSaveAlert(state),
                ),
              ),
            ],
          ),
        );
      },
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
  void _handleSaveAlert(AlertLoaded state) {
    final name = _nameController.text.trim();
    final validationError = _validateAlertName(name);

    if (validationError != null) {
      custom_snackbar.showSnackBarError(context, validationError);
      return;
    }

    if (state.selectedSensors.isEmpty) {
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
    //     'critical': state.criticalRanges,
    //     'warning': state.isWarningEnabled ? state.warningRanges : null,
    //   },
    //   isWarningEnabled: state.isWarningEnabled,
    // );

    context.read<AlertBloc>().add(AlertHideAddView());
    custom_snackbar.showSnackBarSucces(
      context,
      'Alerte "$name" modifiée avec succès !',
    );
  }
}
