import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import 'alert_name_input.dart';
import 'sensors_section.dart';
import 'thresholds_section.dart';

/// Widget pour la configuration d'une alerte
/// Contient le formulaire de saisie du nom, la sélection des capteurs et la configuration des seuils
class AlertConfigurationForm extends StatelessWidget {
  final TextEditingController nameController;
  final String? Function(String?)? nameValidator;
  final List<SelectedSensor> selectedSensors;
  final ValueChanged<List<SelectedSensor>>? onSensorsChanged;
  final Map<String, RangeValues> criticalRanges;
  final Map<String, RangeValues> warningRanges;
  final bool isWarningEnabled;
  final void Function(SelectedSensor, RangeValues)? onCriticalRangeChanged;
  final void Function(SelectedSensor, RangeValues)? onWarningRangeChanged;
  final ValueChanged<bool>? onWarningEnabledChanged;

  const AlertConfigurationForm({
    super.key,
    required this.nameController,
    this.nameValidator,
    required this.selectedSensors,
    this.onSensorsChanged,
    required this.criticalRanges,
    required this.warningRanges,
    required this.isWarningEnabled,
    this.onCriticalRangeChanged,
    this.onWarningRangeChanged,
    this.onWarningEnabledChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GardenCard(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Champ de saisie du nom de l'alerte
            AlertNameInput(
              controller: nameController,
              validator: nameValidator,
            ),

            const SizedBox(height: 24),

            // Section de sélection des capteurs
            SensorsSection(
              selectedSensors: selectedSensors,
              onSelectionChanged: onSensorsChanged,
            ),

            const SizedBox(height: 16),

            // Section de configuration des seuils
            ThresholdsSection(
              selectedSensors: selectedSensors,
              criticalRanges: criticalRanges,
              warningRanges: warningRanges,
              isWarningEnabled: isWarningEnabled,
              onCriticalRangeChanged: onCriticalRangeChanged,
              onWarningRangeChanged: onWarningRangeChanged,
              onWarningEnabledChanged: onWarningEnabledChanged,
            ),
          ],
        ),
      ),
    );
  }
}

