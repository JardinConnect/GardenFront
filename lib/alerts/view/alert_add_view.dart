import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/components.dart';

import '../bloc/alert_bloc.dart';
import '../models/alert_models.dart';
import '../widgets/forms/alert_add_header.dart';
import '../widgets/forms/alert_configuration_form.dart';
import '../widgets/forms/alert_conflict_dialog.dart';
import '../widgets/forms/alert_table_section.dart';

class AlertAddView extends StatefulWidget {
  final List<Map<String, dynamic>> availableSensors;

  const AlertAddView({super.key, required this.availableSensors});

  @override
  State<AlertAddView> createState() => _AlertAddViewState();
}

class _AlertAddViewState extends State<AlertAddView> {
  final _nameController = TextEditingController();
  List<String> _selectedCellIds = [];

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
              const AlertAddHeader(),
              const SizedBox(height: 24),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Formulaire de configuration (nom + capteurs + seuils)
                    Expanded(
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
                    const SizedBox(width: 16),
                    // Sélection des cellules
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
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Button(
                  label: 'Créer l\'alerte',
                  icon: Icons.add_alert,
                  onPressed: () => _submit(state),
                ),
              ),
            ],
          ),
        );
      },
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

    // Construit la liste de capteurs avec l'index par type
    final indexByType = <SensorType, int>{};
    final sensors =
        state.selectedSensors.map((sensor) {
          final key = '${sensor.type.index}_${sensor.index}';
          final typeIndex = indexByType[sensor.type] ?? 0;
          indexByType[sensor.type] = typeIndex + 1;
          return SensorRequest(
            type: sensorTypeToApiString(sensor.type),
            index: typeIndex,
            criticalRange: SensorRange(
              min: state.criticalRanges[key]?.start ?? 0,
              max: state.criticalRanges[key]?.end ?? 100,
            ),
            warningRange: SensorRange(
              min: state.warningRanges[key]?.start ?? 0,
              max: state.warningRanges[key]?.end ?? 100,
            ),
          );
        }).toList();

    context.read<AlertBloc>().add(
      AlertValidateAlert(
        request: AlertCreationRequest(
          title: name,
          isActive: true,
          cellIds: _selectedCellIds,
          sensors: sensors,
          warningEnabled: state.isWarningEnabled,
        ),
      ),
    );
  }

  // Affiche la popup de résolution des conflits
  Future<void> _showConflictDialog(
    BuildContext context,
    List<AlertConflict> conflicts,
  ) async {
    final result = await AlertConflictDialog.show(context, conflicts);
    if (!context.mounted) return;
    context.read<AlertBloc>().add(
      result != null
          ? AlertConfirmCreate(overwrite: result)
          : const AlertCancelCreate(),
    );
  }
}
