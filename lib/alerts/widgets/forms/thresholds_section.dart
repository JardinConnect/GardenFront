import 'package:syncfusion_flutter_core/theme.dart'
    show SfRangeSliderTheme, SfRangeSliderThemeData;
import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'sensors_section.dart';
import 'single_sensor_icon.dart';
import '../../../common/widgets/small_toggle.dart';

/// Configuration pour un type de capteur
class _SensorConfig {
  final double min;
  final double max;
  final String unit;
  final RangeValues defaultCritical;
  final RangeValues defaultWarning;
  final double interval;
  final double stepSize;
  final int decimals;

  const _SensorConfig({
    required this.min,
    required this.max,
    required this.unit,
    required this.defaultCritical,
    required this.defaultWarning,
    required this.interval,
    required this.stepSize,
    required this.decimals,
  });
}

/// Configurations des capteurs centralisées
const Map<SensorType, _SensorConfig> _sensorConfigs = {
  SensorType.airTemperature: _SensorConfig(
    min: -20,
    max: 50,
    unit: '°C',
    interval: 10,
    stepSize: 0.1,
    decimals: 1,
    defaultCritical: RangeValues(0, 30),
    defaultWarning: RangeValues(5, 25),
  ),
  SensorType.soilTemperature: _SensorConfig(
    min: -20,
    max: 50,
    unit: '°C',
    interval: 10,
    stepSize: 0.1,
    decimals: 1,
    defaultCritical: RangeValues(0, 35),
    defaultWarning: RangeValues(5, 28),
  ),
  SensorType.humiditySurface: _SensorConfig(
    min: 0,
    max: 100,
    unit: '%',
    interval: 10,
    stepSize: 0.1,
    decimals: 1,
    defaultCritical: RangeValues(10, 80),
    defaultWarning: RangeValues(20, 70),
  ),
  SensorType.humidityDepth: _SensorConfig(
    min: 0,
    max: 100,
    unit: '%',
    interval: 10,
    stepSize: 0.1,
    decimals: 1,
    defaultCritical: RangeValues(10, 80),
    defaultWarning: RangeValues(20, 70),
  ),
  SensorType.light: _SensorConfig(
    min: 0,
    max: 20000,
    unit: 'lm',
    interval: 5000,
    stepSize: 100,
    decimals: 0,
    defaultCritical: RangeValues(100, 10000),
    defaultWarning: RangeValues(500, 8000),
  ),
  SensorType.rain: _SensorConfig(
    min: 0,
    max: 100,
    unit: '%',
    interval: 10,
    stepSize: 0.1,
    decimals: 1,
    defaultCritical: RangeValues(1, 80),
    defaultWarning: RangeValues(5, 70),
  ),
};

/// Widget de configuration des seuils d'alerte (version simplifiée)
class ThresholdsSection extends StatefulWidget {
  final bool isWarningEnabled;
  final ValueChanged<bool>? onWarningEnabledChanged;
  final List<SelectedSensor> selectedSensors;
  final Map<String, RangeValues>? criticalRanges;
  final Map<String, RangeValues>? warningRanges;
  final void Function(SelectedSensor, RangeValues)? onCriticalRangeChanged;
  final void Function(SelectedSensor, RangeValues)? onWarningRangeChanged;

  /// Si true, n'affiche que la section critique (usage mobile tabs)
  final bool showOnlyCritical;

  /// Si true, n'affiche que la section avertissement (usage mobile tabs)
  final bool showOnlyWarning;

  /// Si true, masque le titre de section (usage mobile — l'info est dans le tab)
  final bool hideSectionTitle;

  /// Si true, utilise un toggle pill compact à la place de GardenToggle
  final bool smallToggle;

  const ThresholdsSection({
    super.key,
    this.isWarningEnabled = true,
    this.onWarningEnabledChanged,
    this.selectedSensors = const [],
    this.criticalRanges,
    this.warningRanges,
    this.onCriticalRangeChanged,
    this.onWarningRangeChanged,
    this.showOnlyCritical = false,
    this.showOnlyWarning = false,
    this.hideSectionTitle = false,
    this.smallToggle = false,
  });

  @override
  State<ThresholdsSection> createState() => _ThresholdsSectionState();
}

class _ThresholdsSectionState extends State<ThresholdsSection> {
  late bool _isWarningEnabled;

  @override
  void initState() {
    super.initState();
    _isWarningEnabled = widget.isWarningEnabled;
  }

  @override
  void didUpdateWidget(covariant ThresholdsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isWarningEnabled != widget.isWarningEnabled) {
      setState(() {
        _isWarningEnabled = widget.isWarningEnabled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedSensors.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        child: Text(
          'Aucun capteur sélectionné. Sélectionnez des capteurs pour configurer des seuils.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.showOnlyWarning)
          _buildSection('Alerte critique', GardenColors.redAlert.shade500, true),
        if (!widget.showOnlyCritical)
          _buildSection(
            'Avertissement',
            GardenColors.yellowWarning.shade600,
            false,
            hasToggle: true,
          ),
      ],
    );
  }

  Widget _buildSection(
    String title,
    Color color,
    bool isCritical, {
    bool hasToggle = false,
  }) {
    final hideTitle = widget.hideSectionTitle;

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête : masqué si hideSectionTitle + critique
          // En mode warning + hideSectionTitle : toggle avec label descriptif
          if (!hideTitle || (!isCritical && hasToggle))
            Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!hideTitle)
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  if (hideTitle && !isCritical)
                    Text(
                      'Activer les avertissements',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: GardenColors.typography.shade400,
                      ),
                    ),
                  if (hasToggle)
                    widget.smallToggle
                        ? SmallToggle(
                            isEnabled: _isWarningEnabled,
                            onToggle: (value) {
                              setState(() => _isWarningEnabled = value);
                              widget.onWarningEnabledChanged?.call(value);
                            },
                          )
                        : GardenToggle(
                            isEnabled: _isWarningEnabled,
                            onToggle: (value) {
                              setState(() => _isWarningEnabled = value);
                              widget.onWarningEnabledChanged?.call(value);
                            },
                          ),
                ],
              ),
            ),
          for (final sensor in widget.selectedSensors) ...[
            Opacity(
              opacity: (!isCritical && !_isWarningEnabled) ? 0.5 : 1.0,
              child: _buildSensorSlider(sensor, color, isCritical),
            ),
            SizedBox(height: GardenSpace.gapSm),
          ],
        ],
      ),
    );
  }

  Widget _buildSensorSlider(
    SelectedSensor sensor,
    Color color,
    bool isCritical,
  ) {
    final config = _sensorConfigs[sensor.type]!;
    final key = '${sensor.type.index}_${sensor.index}';
    final range =
        isCritical
            ? (widget.criticalRanges?[key] ?? config.defaultCritical)
            : (widget.warningRanges?[key] ?? config.defaultWarning);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: GardenSpace.paddingXs, horizontal: 6),
      child: Row(
        children: [
          // Icône du capteur
          Tooltip(
            message: '${sensor.type.displayName} ${sensor.index + 1}',
            child: SingleSensorIcon(
              sensorType: sensor.type,
              isActive: true,
              index: sensor.index,
              containerSize: 28,
              iconSize: 18,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: SfRangeSliderTheme(
              data: SfRangeSliderThemeData(
                activeTrackHeight: 3,
                inactiveTrackHeight: 3,
                thumbRadius: 7,
                overlayRadius: 14,
                thumbColor: Colors.black,
                overlayColor: color.withValues(alpha: 0.15),
                tooltipBackgroundColor: color,
                tooltipTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                labelOffset: const Offset(0, 4),
                inactiveLabelStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 11,
                ),
                activeLabelStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 11,
                ),
              ),
              child: SfRangeSlider(
                min: config.min,
                max: config.max,
                values: SfRangeValues(range.start, range.end),
                interval: config.interval,
                stepSize: config.stepSize,
                showLabels: true,
                showTicks: true,
                enableTooltip: true,
                tooltipShape: const SfRectangularTooltipShape(),
                activeColor: color,
                inactiveColor: color.withValues(alpha: 0.2),
                tooltipTextFormatterCallback: (
                  dynamic actualValue,
                  String formattedText,
                ) {
                  final val = (actualValue as double).toStringAsFixed(config.decimals);
                  return '$val${config.unit}';
                },
                onChanged: (SfRangeValues values) {
                  final callback =
                      isCritical
                          ? widget.onCriticalRangeChanged
                          : widget.onWarningRangeChanged;
                  callback?.call(sensor, RangeValues(values.start, values.end));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

