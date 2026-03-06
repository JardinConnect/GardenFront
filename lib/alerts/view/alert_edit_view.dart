import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/components.dart';

import '../bloc/alert_bloc.dart';
import '../models/alert_models.dart';
import '../widgets/forms/alert_configuration_form.dart';
import '../widgets/forms/alert_danger_zone.dart';
import '../widgets/forms/alert_table_section.dart';

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
  final _nameController = TextEditingController();
  List<String> _selectedCellIds = [];
  bool _isLoading = true;

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

  void _loadAlertData() {
    try {
      _nameController.text = (widget.alertDetails['title'] as String?) ?? '';
      _selectedCellIds =
          (widget.alertDetails['cellIds'] as List<dynamic>?)?.cast<String>() ??
          [];
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted)
        context.read<AlertBloc>().add(
          AlertPushError(message: 'Erreur de chargement : $e'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return BlocBuilder<AlertBloc, AlertState>(
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
                    // Sélection des cellules + zone de danger
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
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
                          const SizedBox(height: 16),
                          AlertDangerZone(alert: widget.alert),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Button(
                  label: 'Enregistrer les modifications',
                  icon: Icons.save,
                  onPressed: () => _submit(state),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
        const SizedBox(height: 24),
        Text(
          'Modifier l\'alerte',
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

    context.read<AlertBloc>().add(
      AlertUpdateAlert(
        alertId: widget.alert.id,
        request: AlertCreationRequest(
          title: name,
          isActive: widget.alert.isActive,
          cellIds: _selectedCellIds,
          sensors: sensors,
          warningEnabled: state.isWarningEnabled,
        ),
      ),
    );
  }
}
