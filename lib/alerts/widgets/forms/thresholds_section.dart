import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'sensors_section.dart';
import 'single_sensor_icon.dart';

/// Configuration pour un type de capteur
class _SensorConfig {
  final double min;
  final double max;
  final String unit;
  final RangeValues defaultCritical;
  final RangeValues defaultWarning;
  final double interval;

  const _SensorConfig({
    required this.min,
    required this.max,
    required this.unit,
    required this.defaultCritical,
    required this.defaultWarning,
    required this.interval,
  });
}

/// Configurations des capteurs centralisées
const Map<SensorType, _SensorConfig> _sensorConfigs = {
  SensorType.temperature: _SensorConfig(
    min: -20,
    max: 50,
    unit: '°C',
    interval: 10,
    defaultCritical: RangeValues(0, 30),
    defaultWarning: RangeValues(5, 25),
  ),
  SensorType.humiditySurface: _SensorConfig(
    min: 0,
    max: 100,
    unit: '%',
    interval: 10,
    defaultCritical: RangeValues(10, 80),
    defaultWarning: RangeValues(20, 70),
  ),
  SensorType.humidityDepth: _SensorConfig(
    min: 0,
    max: 100,
    unit: '%',
    interval: 10,
    defaultCritical: RangeValues(10, 80),
    defaultWarning: RangeValues(20, 70),
  ),
  SensorType.light: _SensorConfig(
    min: 0,
    max: 20000,
    unit: 'lm',
    interval: 5000,
    defaultCritical: RangeValues(100, 10000),
    defaultWarning: RangeValues(500, 8000),
  ),
  SensorType.rain: _SensorConfig(
    min: 0,
    max: 100,
    unit: '%',
    interval: 10,
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

  const ThresholdsSection({
    super.key,
    this.isWarningEnabled = true,
    this.onWarningEnabledChanged,
    this.selectedSensors = const [],
    this.criticalRanges,
    this.warningRanges,
    this.onCriticalRangeChanged,
    this.onWarningRangeChanged,
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
  Widget build(BuildContext context) {
    if (widget.selectedSensors.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        child: Text(
          'Aucun capteur sélectionné. Sélectionnez des capteurs pour configurer des seuils.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[700],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection('Alerte critique', GardenColors.redAlert.shade500, true),
        _buildSection('Avertissement', GardenColors.yellowWarning.shade600, false, hasToggle: true),
      ],
    );
  }

  Widget _buildSection(String title, Color color, bool isCritical, {bool hasToggle = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (hasToggle)
                GardenToggle(
                  isEnabled: _isWarningEnabled,
                  onToggle: (value) {
                    setState(() => _isWarningEnabled = value);
                    widget.onWarningEnabledChanged?.call(value);
                  },
                ),
            ],
          ),
          const SizedBox(height: 12),
          for (final sensor in widget.selectedSensors) ...[
            Opacity(
              opacity: (!isCritical && !_isWarningEnabled) ? 0.5 : 1.0,
              child: _buildSensorSlider(sensor, color, isCritical),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildSensorSlider(SelectedSensor sensor, Color color, bool isCritical) {
    final config = _sensorConfigs[sensor.type]!;
    final key = '${sensor.type.index}_${sensor.index}';
    final range = isCritical
        ? (widget.criticalRanges?[key] ?? config.defaultCritical)
        : (widget.warningRanges?[key] ?? config.defaultWarning);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
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
                tooltipBackgroundColor: color.withValues(alpha: 0.95),
                tooltipTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: SfRangeSlider(
                min: config.min,
                max: config.max,
                values: SfRangeValues(range.start, range.end),
                interval: config.interval,
                showLabels: true,
                showTicks: true,
                enableTooltip: true,
                activeColor: color,
                inactiveColor: color.withValues(alpha: 0.2),
                tooltipTextFormatterCallback: (dynamic actualValue, String formattedText) {
                  return '${actualValue.round()}${config.unit}';
                },
                onChanged: (SfRangeValues values) {
                  final callback = isCritical
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
