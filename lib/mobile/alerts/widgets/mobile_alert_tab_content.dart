import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/design_system.dart';

import '../../../alerts/bloc/alert_bloc.dart';
import '../../../alerts/models/alert_models.dart';
import '../../../alerts/widgets/forms/alert_danger_zone.dart';
import '../../../alerts/widgets/forms/alert_table_section.dart';
import '../../../alerts/widgets/forms/thresholds_section.dart';
import 'mobile_alert_tab_bar.dart';

/// Contenu de l'onglet actif du formulaire d'alerte mobile.
///
/// Délègue le rendu au composant approprié selon l'onglet sélectionné :
/// seuils critiques, seuils d'avertissement, sélection des cellules ou zone de danger.
/// Le scroll est géré par le [CustomScrollView] parent de la page.
class MobileAlertTabContent extends StatelessWidget {
  /// Onglet actuellement affiché.
  final MobileAlertFormTab currentTab;

  /// État chargé du BLoC des alertes.
  final AlertLoaded state;

  /// Identifiants des cellules sélectionnées.
  final List<String> selectedCellIds;

  /// Callback déclenché lorsque la sélection de cellules change.
  final ValueChanged<List<String>> onCellSelectionChanged;

  /// Indique si le formulaire est en mode édition.
  final bool isEditing;

  /// Alerte en cours d'édition, utilisée uniquement pour l'onglet danger.
  final Alert? alert;

  const MobileAlertTabContent({
    super.key,
    required this.currentTab,
    required this.state,
    required this.selectedCellIds,
    required this.onCellSelectionChanged,
    required this.isEditing,
    this.alert,
  });

  @override
  Widget build(BuildContext context) {
    switch (currentTab) {
      case MobileAlertFormTab.critical:
        return Padding(
          padding: EdgeInsets.fromLTRB(GardenSpace.paddingLg, GardenSpace.paddingMd, GardenSpace.paddingLg, 0),
          child: ThresholdsSection(
            selectedSensors: state.selectedSensors,
            criticalRanges: state.criticalRanges,
            warningRanges: state.warningRanges,
            isWarningEnabled: state.isWarningEnabled,
            showOnlyCritical: true,
            hideSectionTitle: true,
            smallToggle: true,
            onCriticalRangeChanged: (s, r) => context.read<AlertBloc>().add(
              AlertUpdateCriticalRange(sensor: s, range: r),
            ),
            onWarningRangeChanged: (s, r) => context.read<AlertBloc>().add(
              AlertUpdateWarningRange(sensor: s, range: r),
            ),
            onWarningEnabledChanged: (e) => context.read<AlertBloc>().add(
              AlertUpdateWarningEnabled(enabled: e),
            ),
          ),
        );

      case MobileAlertFormTab.warning:
        return Padding(
          padding: EdgeInsets.fromLTRB(GardenSpace.paddingLg, GardenSpace.paddingMd, GardenSpace.paddingLg, 0),
          child: ThresholdsSection(
            selectedSensors: state.selectedSensors,
            criticalRanges: state.criticalRanges,
            warningRanges: state.warningRanges,
            isWarningEnabled: state.isWarningEnabled,
            showOnlyWarning: true,
            hideSectionTitle: true,
            smallToggle: true,
            onCriticalRangeChanged: (s, r) => context.read<AlertBloc>().add(
              AlertUpdateCriticalRange(sensor: s, range: r),
            ),
            onWarningRangeChanged: (s, r) => context.read<AlertBloc>().add(
              AlertUpdateWarningRange(sensor: s, range: r),
            ),
            onWarningEnabledChanged: (e) => context.read<AlertBloc>().add(
              AlertUpdateWarningEnabled(enabled: e),
            ),
          ),
        );

      case MobileAlertFormTab.cells:
        return Padding(
          padding: EdgeInsets.only(
            left: GardenSpace.paddingLg,
            right: GardenSpace.paddingLg,
            bottom: GardenSpace.paddingXl,
          ),
          child: state.cells.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : AlertTableSection(
                  cells: state.cells,
                  selectedCellIds: selectedCellIds,
                  onSelectionChanged: onCellSelectionChanged,
                  isMobile: true,
                ),
        );

      case MobileAlertFormTab.danger:
        return Padding(
          padding: EdgeInsets.fromLTRB(GardenSpace.paddingLg, GardenSpace.paddingMd, GardenSpace.paddingLg, 0),
          child: isEditing && alert != null
              ? AlertDangerZone(alert: alert!)
              : const SizedBox.shrink(),
        );
    }
  }
}
