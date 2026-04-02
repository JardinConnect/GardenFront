import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:go_router/go_router.dart';

import '../../../alerts/bloc/alert_bloc.dart';
import '../../../alerts/models/alert_models.dart';
import '../../../alerts/widgets/forms/alert_conflict_dialog.dart';
import '../../../alerts/widgets/forms/sensors_section.dart';
import '../../common/widgets/mobile_header.dart';
import '../widgets/mobile_alert_name_row.dart';
import '../widgets/mobile_alert_tab_bar.dart';
import '../widgets/mobile_alert_tab_content.dart';

/// Formulaire mobile de création ou d'édition d'une alerte.
///
/// En mode création, [alertId] est null et le formulaire est vide.
/// En mode édition, [alertId] correspond à l'identifiant de l'alerte à modifier,
/// et le formulaire est pré-rempli avec les données existantes.
class MobileAlertFormPage extends StatefulWidget {
  /// Identifiant de l'alerte à modifier. Null en mode création.
  final String? alertId;

  const MobileAlertFormPage({super.key, this.alertId});

  /// Indique si la page est en mode édition.
  bool get isEditing => alertId != null;

  @override
  State<MobileAlertFormPage> createState() => _MobileAlertFormPageState();
}

class _MobileAlertFormPageState extends State<MobileAlertFormPage> {
  final _nameController = TextEditingController();
  List<String> _selectedCellIds = [];
  MobileAlertFormTab _currentTab = MobileAlertFormTab.critical;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bloc = context.read<AlertBloc>();
      if (widget.isEditing) {
        bloc.add(AlertShowEditView(alertId: widget.alertId!));
      } else {
        bloc.add(const AlertShowAddView());
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Pré-remplit le formulaire depuis l'état BLoC lors du premier chargement en édition.
  void _initFromState(AlertLoaded state) {
    if (_initialized) return;
    if (widget.isEditing && state.alertDetails != null && state.editingAlert != null) {
      _nameController.text = (state.alertDetails!['title'] as String?) ?? '';
      _selectedCellIds =
          (state.alertDetails!['cellIds'] as List<dynamic>?)?.cast<String>() ?? [];
      _initialized = true;
    } else if (!widget.isEditing) {
      _initialized = true;
    }
    _nameController.addListener(() => setState(() {}));
  }

  /// Vérifie que le formulaire est valide et prêt à être soumis.
  bool _isFormReady(AlertLoaded state) =>
      _nameController.text.trim().isNotEmpty &&
      state.selectedSensors.isNotEmpty &&
      _selectedCellIds.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AlertBloc, AlertState>(
      listenWhen: (prev, curr) {
        if (curr is! AlertLoaded || prev is! AlertLoaded) return false;
        final hasNewConflicts = curr.pendingConflicts != null &&
            curr.pendingConflicts!.isNotEmpty &&
            prev.pendingConflicts != curr.pendingConflicts;
        final addViewClosed = prev.isShowingAddView && !curr.isShowingAddView;
        final editViewClosed = prev.isShowingEditView && !curr.isShowingEditView;
        return hasNewConflicts || addViewClosed || editViewClosed;
      },
      listener: (context, state) {
        if (state is! AlertLoaded) return;
        if (state.pendingConflicts != null && state.pendingConflicts!.isNotEmpty) {
          _showConflictDialog(context, state.pendingConflicts!);
          return;
        }
        if (!state.isShowingAddView && !state.isShowingEditView) {
          context.pop();
        }
      },
      builder: (context, state) {
        if (state is! AlertLoaded) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (widget.isEditing &&
            (state.editingAlert == null || state.alertDetails == null)) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        _initFromState(state);

        final ready = _isFormReady(state);

        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: MobileHeader(),
          body: SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: GardenSpace.paddingLg),
                    child: Text(
                      widget.isEditing ? 'Modifier l\'alerte' : 'Nouvelle alerte',
                      style: GardenTypography.headingSm.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: GardenSpace.gapMd)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: GardenSpace.paddingLg),
                    child: MobileAlertNameRow(
                      controller: _nameController,
                      isReady: ready,
                      onSubmit: () => _submit(state),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: GardenSpace.gapMd)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: GardenSpace.paddingLg),
                    child: GardenCard(
                      child: SensorsSection(
                        selectedSensors: state.selectedSensors,
                        onSelectionChanged: (s) => context.read<AlertBloc>().add(
                          AlertUpdateSensors(sensors: s),
                        ),
                        availableSensors: state.availableSensors,
                        compact: true,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: GardenSpace.gapMd)),
                SliverToBoxAdapter(
                  child: MobileAlertTabBar(
                    currentTab: _currentTab,
                    isEditing: widget.isEditing,
                    onTabChanged: (tab) => setState(() => _currentTab = tab),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: GardenSpace.gapMd)),
                SliverToBoxAdapter(
                  child: MobileAlertTabContent(
                    currentTab: _currentTab,
                    state: state,
                    selectedCellIds: _selectedCellIds,
                    onCellSelectionChanged: (ids) => setState(() => _selectedCellIds = ids),
                    isEditing: widget.isEditing,
                    alert: state.editingAlert,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Valide et soumet le formulaire au BLoC sous forme de [AlertCreationRequest].
  ///
  /// Affiche une erreur si le nom est trop court, si aucun capteur ou aucune
  /// cellule n'est sélectionné. En mode édition, déclenche [AlertValidateUpdate],
  /// en mode création [AlertValidateAlert].
  void _submit(AlertLoaded state) {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      context.read<AlertBloc>().add(AlertPushError(message: 'Le nom est obligatoire'));
      return;
    }
    if (state.selectedSensors.isEmpty) {
      context.read<AlertBloc>().add(const AlertPushError(message: 'Sélectionnez au moins un capteur'));
      return;
    }
    if (_selectedCellIds.isEmpty) {
      context.read<AlertBloc>().add(const AlertPushError(message: 'Sélectionnez au moins une cellule'));
      return;
    }

    final sensors = state.selectedSensors.map((sensor) {
      final key = '${sensor.type.index}_${sensor.index}';
      final critical = state.criticalRanges[key] ?? sensor.type.defaultCriticalRange;
      final warning = state.warningRanges[key] ?? sensor.type.defaultWarningRange;
      return SensorRequest(
        type: sensorTypeToApiString(sensor.type),
        index: sensor.index,
        criticalRange: SensorRange(min: critical.start, max: critical.end),
        warningRange: SensorRange(min: warning.start, max: warning.end),
      );
    }).toList();

    final request = AlertCreationRequest(
      title: name,
      isActive: widget.isEditing ? state.editingAlert!.isActive : true,
      cellIds: _selectedCellIds,
      sensors: sensors,
      warningEnabled: state.isWarningEnabled,
    );

    if (widget.isEditing) {
      context.read<AlertBloc>().add(AlertValidateUpdate(alertId: widget.alertId!, request: request));
    } else {
      context.read<AlertBloc>().add(AlertValidateAlert(request: request));
    }
  }

  /// Affiche la boîte de dialogue de gestion des conflits, puis traite la réponse
  /// de l'utilisateur en confirmant ou annulant l'opération en cours.
  Future<void> _showConflictDialog(BuildContext context, List<AlertConflict> conflicts) async {
    final result = await AlertConflictDialog.show(context, conflicts, isEditing: widget.isEditing);
    if (!context.mounted) return;

    if (widget.isEditing) {
      context.read<AlertBloc>().add(
        result != null ? AlertConfirmUpdate(overwrite: result) : const AlertCancelUpdate(),
      );
    } else {
      context.read<AlertBloc>().add(
        result != null ? AlertConfirmCreate(overwrite: result) : const AlertCancelCreate(),
      );
    }
  }
}
