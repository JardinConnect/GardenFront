import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/components.dart';

import '../bloc/alert_bloc.dart';
import '../models/alert_models.dart';
import '../widgets/forms/alert_configuration_form.dart';
import '../widgets/forms/alert_conflict_dialog.dart';
import '../widgets/forms/alert_danger_zone.dart';
import '../widgets/forms/alert_table_section.dart';

/// Vue unifiée pour la création et l'édition d'une alerte.
/// En mode création : [alert] et [alertDetails] sont null.
/// En mode édition : [alert] et [alertDetails] sont fournis.
class AlertFormView extends StatefulWidget {
  // Null en mode création
  final Alert? alert;
  final Map<String, dynamic>? alertDetails;
  final List<Map<String, dynamic>> availableSensors;

  const AlertFormView({
    super.key,
    required this.availableSensors,
    this.alert,
    this.alertDetails,
  });

  bool get isEditing => alert != null && alertDetails != null;

  @override
  State<AlertFormView> createState() => _AlertFormViewState();
}

class _AlertFormViewState extends State<AlertFormView> {
  final _nameController = TextEditingController();
  List<String> _selectedCellIds = [];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      // Pré-remplissage depuis les détails existants
      _nameController.text = (widget.alertDetails!['title'] as String?) ?? '';
      _selectedCellIds =
          (widget.alertDetails!['cellIds'] as List<dynamic>?)
              ?.cast<String>() ??
          [];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AlertBloc, AlertState>(
      // Ouvre la popup de conflits dès qu'ils arrivent dans le state
      listenWhen:
          (prev, curr) =>
              curr is AlertLoaded &&
              curr.pendingConflicts != null &&
              curr.pendingConflicts!.isNotEmpty &&
              (prev is! AlertLoaded ||
                  prev.pendingConflicts != curr.pendingConflicts),
      listener: (context, state) {
        if (state is AlertLoaded)
          _showConflictDialog(context, state.pendingConflicts!);
      },
      builder: (context, state) {
        if (state is! AlertLoaded)
          return const Center(child: CircularProgressIndicator());

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Formulaire de configuration (nom + capteurs + seuils)
                    Expanded(
                      child: SingleChildScrollView(
                        child: AlertConfigurationForm(
                          nameController: _nameController,
                          nameValidator: _validateName,
                          selectedSensors: state.selectedSensors,
                          onSensorsChanged:
                              (s) => context.read<AlertBloc>().add(
                                AlertUpdateSensors(sensors: s),
                              ),
                          criticalRanges: state.criticalRanges,
                          warningRanges: state.warningRanges,
                          isWarningEnabled: state.isWarningEnabled,
                          onCriticalRangeChanged:
                              (s, r) => context.read<AlertBloc>().add(
                                AlertUpdateCriticalRange(sensor: s, range: r),
                              ),
                          onWarningRangeChanged:
                              (s, r) => context.read<AlertBloc>().add(
                                AlertUpdateWarningRange(sensor: s, range: r),
                              ),
                          onWarningEnabledChanged:
                              (e) => context.read<AlertBloc>().add(
                                AlertUpdateWarningEnabled(enabled: e),
                              ),
                          availableSensors: widget.availableSensors,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Colonne droite : table de cellules + zone de danger (édition seulement)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: GardenCard(
                              child:
                                  state.cells.isEmpty
                                      ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                      : AlertTableSection(
                                        cells: state.cells,
                                        selectedCellIds: _selectedCellIds,
                                        onSelectionChanged:
                                            (ids) => setState(
                                              () => _selectedCellIds = ids,
                                            ),
                                      ),
                            ),
                          ),
                          // Zone de danger uniquement en édition
                          if (widget.isEditing) ...[
                            const SizedBox(height: 16),
                            AlertDangerZone(alert: widget.alert!),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Button(
                  label:
                      widget.isEditing
                          ? 'Enregistrer les modifications'
                          : 'Créer l\'alerte',
                  icon: widget.isEditing ? Icons.save : Icons.add_alert,
                  onPressed: () => _submit(state),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Header avec bouton retour et titre adapté au mode
  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () => context.read<AlertBloc>().add(AlertHideAddView()),
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
        const SizedBox(height: 16),
        Text(
          widget.isEditing ? 'Modifier l\'alerte' : 'Ajouter une alerte',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ],
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Le nom est obligatoire';
    if (value.trim().length < 3)
      return 'Le nom doit contenir au moins 3 caractères';
    return null;
  }

  void _submit(AlertLoaded state) {
    final name = _nameController.text.trim();
    final nameError = _validateName(name);
    if (nameError != null) {
      context.read<AlertBloc>().add(AlertPushError(message: nameError));
      return;
    }
    if (state.selectedSensors.isEmpty) {
      context.read<AlertBloc>().add(
        const AlertPushError(message: 'Sélectionnez au moins un capteur'),
      );
      return;
    }
    if (_selectedCellIds.isEmpty) {
      context.read<AlertBloc>().add(
        const AlertPushError(message: 'Sélectionnez au moins une cellule'),
      );
      return;
    }

    // Construction des capteurs avec leurs plages
    final sensors =
        state.selectedSensors.map((sensor) {
          final key = '${sensor.type.index}_${sensor.index}';
          final critical =
              state.criticalRanges[key] ?? sensor.type.defaultCriticalRange;
          final warning =
              state.warningRanges[key] ?? sensor.type.defaultWarningRange;
          return SensorRequest(
            type: sensorTypeToApiString(sensor.type),
            index: sensor.index,
            criticalRange: SensorRange(min: critical.start, max: critical.end),
            warningRange: SensorRange(min: warning.start, max: warning.end),
          );
        }).toList();

    final request = AlertCreationRequest(
      title: name,
      isActive: widget.isEditing ? widget.alert!.isActive : true,
      cellIds: _selectedCellIds,
      sensors: sensors,
      warningEnabled: state.isWarningEnabled,
    );

    if (widget.isEditing) {
      context.read<AlertBloc>().add(
        AlertValidateUpdate(alertId: widget.alert!.id, request: request),
      );
    } else {
      context.read<AlertBloc>().add(AlertValidateAlert(request: request));
    }
  }

  // Affiche la popup de conflits et dispatche la confirmation ou l'annulation
  Future<void> _showConflictDialog(
    BuildContext context,
    List<AlertConflict> conflicts,
  ) async {
    final result = await AlertConflictDialog.show(
      context,
      conflicts,
      isEditing: widget.isEditing,
    );
    if (!context.mounted) return;

    if (widget.isEditing) {
      context.read<AlertBloc>().add(
        result != null
            ? AlertConfirmUpdate(overwrite: result)
            : const AlertCancelUpdate(),
      );
    } else {
      context.read<AlertBloc>().add(
        result != null
            ? AlertConfirmCreate(overwrite: result)
            : const AlertCancelCreate(),
      );
    }
  }
}

