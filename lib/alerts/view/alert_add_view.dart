import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/components.dart';
import '../bloc/alert_bloc.dart';
import '../widgets/forms/alert_add_header.dart';
import '../widgets/forms/alert_configuration_form.dart';
import '../widgets/forms/sensors_section.dart';
import '../widgets/forms/alert_table_section.dart';
import '../widgets/common/snackbar.dart' as custom_snackbar;

/// Vue pour créer une nouvelle alerte
/// Permet de configurer le nom, les capteurs et les seuils d'alerte
class AlertAddView extends StatefulWidget {
  final List<Map<String, dynamic>> spaces;
  final List<Map<String, dynamic>> availableSensors;

  const AlertAddView({
    super.key,
    required this.spaces,
    required this.availableSensors,
  });

  @override
  State<AlertAddView> createState() => _AlertAddViewState();
}

class _AlertAddViewState extends State<AlertAddView> {
  // Contrôleur pour le nom de l'alerte
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // Permet de nettoyer les contrôles lors de la fermeture de la vue
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

                    const SizedBox(width: 16),

                    // Aperçu du tableau
                    Expanded(
                      flex: 1,
                      child: GardenCard(
                        child: widget.spaces.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : AlertTableSection(spaces: widget.spaces),
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
                  onPressed: () => _handleCreateAlert(state),
                ),
              ),
            ],
          ),
        );
      },
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

  /// Gère la création de l'alerte
  void _handleCreateAlert(AlertLoaded state) {
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

    // TODO: Appeler le repository pour créer l'alerte
    // final alertRepository = context.read<AlertRepository>();
    // alertRepository.createAlert(
    //   name: name,
    //   cellIds: selectedCellIds,
    //   sensors: {
    //     'critical': state.criticalRanges,
    //     'warning': state.isWarningEnabled ? state.warningRanges : null,
    //   },
    //   isWarningEnabled: state.isWarningEnabled,
    // );

    context.read<AlertBloc>().add(AlertHideAddView());
    custom_snackbar.showSnackBarSucces(
      context,
      'Alerte "$name" créée avec succès !',
    );
  }
}
