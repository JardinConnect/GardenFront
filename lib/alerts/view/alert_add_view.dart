import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/components.dart';
import '../bloc/alert_bloc.dart';
import '../widgets/forms/alert_name_input.dart';
import '../widgets/forms/sensors_section.dart';
import '../widgets/forms/thresholds_section.dart';
import '../widgets/forms/alert_table_section.dart';
import '../widgets/common/snackbar.dart' as custom_snackbar;

/// Vue pour ajouter une nouvelle alerte
class AlertAddView extends StatefulWidget {
  const AlertAddView({super.key});

  @override
  State<AlertAddView> createState() => _AlertAddViewState();
}

class _AlertAddViewState extends State<AlertAddView> {
  List<SelectedSensor> _selectedSensors = [];

  // Separate maps for critical and warning ranges per sensor key
  Map<String, RangeValues> _criticalRanges = {};
  Map<String, RangeValues> _warningRanges = {};
  bool _isWarningEnabled = true;

  void _onSensorsChanged(List<SelectedSensor> sensors) {
    setState(() {
      _selectedSensors = sensors;
      // Ensure maps have entries for each selected sensor (optional)
      for (final s in sensors) {
        final key = _sensorKey(s);
        _criticalRanges.putIfAbsent(key, () => const RangeValues(-10, 40));
        _warningRanges.putIfAbsent(key, () => const RangeValues(0, 30));
      }
      // Remove ranges for unselected sensors
      _criticalRanges.removeWhere((k, v) => !sensors.any((s) => _sensorKey(s) == k));
      _warningRanges.removeWhere((k, v) => !sensors.any((s) => _sensorKey(s) == k));
    });
  }

  String _sensorKey(SelectedSensor s) => '${s.type.index}_${s.index}';

  void _onCriticalRangeChanged(SelectedSensor s, RangeValues range) {
    setState(() {
      _criticalRanges[_sensorKey(s)] = range;
    });
  }

  void _onWarningRangeChanged(SelectedSensor s, RangeValues range) {
    setState(() {
      _warningRanges[_sensorKey(s)] = range;
    });
  }

  void _onWarningEnabledChanged(bool enabled) {
    setState(() {
      _isWarningEnabled = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec bouton retour
          Row(
            children: [
              TextButton(
                onPressed: () {
                  context.read<AlertBloc>().add(AlertHideAddView());
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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
            ],
          ),
          const SizedBox(height: 16),
          // Titre
          Text(
            'Ajouter une alerte',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 24),
          // Row avec deux GardenCards côte à côte
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // GardenCard de gauche - Configuration
                Expanded(
                  flex: 1,
                  child: GardenCard(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Input pour le nom de l'alerte
                          const AlertNameInput(),
                          const SizedBox(height: 24),

                          // Section capteurs
                          SensorsSection(
                            selectedSensors: _selectedSensors,
                            onSelectionChanged: _onSensorsChanged,
                          ),
                          const SizedBox(height: 16),

                          // Section seuils - passe la liste de capteurs sélectionnés et les maps
                          ThresholdsSection(
                            selectedSensors: _selectedSensors,
                            criticalRanges: _criticalRanges,
                            warningRanges: _warningRanges,
                            isWarningEnabled: _isWarningEnabled,
                            onCriticalRangeChanged: _onCriticalRangeChanged,
                            onWarningRangeChanged: _onWarningRangeChanged,
                            onWarningEnabledChanged: _onWarningEnabledChanged,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // GardenCard de droite - Tableau
                Expanded(
                  flex: 1,
                  child: GardenCard(child: const AlertTableSection()),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Bouton Créer Alerte centré en bas
          Center(
            child: Button(
              label: "Créer Alerte",
              icon: Icons.add_alert,
              onPressed: () {
                context.read<AlertBloc>().add(AlertHideAddView());
                custom_snackbar.showSnackBarSucces(
                  context,
                  "Alerte créée avec succès !",
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
