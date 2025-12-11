import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'sensors_section.dart';
import 'SingleSensorIcon.dart';

/// Composant pour la section des seuils
class ThresholdsSection extends StatefulWidget {
  final bool isWarningEnabled;
  final ValueChanged<bool>? onWarningEnabledChanged;

  /// Nouvelle API: liste des capteurs sélectionnés et ranges par capteur
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
          'Aucun capteur sélectionné. Sélectionnez 1 à 6 capteurs pour configurer des seuils.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Alerte critique
        _buildCriticalSection(context),
        // Section Avertissement
        _buildWarningSection(context),
      ],
    );
  }

  Widget _buildCriticalSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alerte critique',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          // Une ligne/gauge par capteur sélectionné
          for (final sensor in widget.selectedSensors) ...[
            _buildSensorLine(sensor, isCritical: true),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Widget _buildWarningSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Avertissement',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              GardenToggle(
                isEnabled: _isWarningEnabled,
                onToggle: (bool value) {
                  setState(() {
                    _isWarningEnabled = value;
                  });
                  widget.onWarningEnabledChanged?.call(value);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final sensor in widget.selectedSensors) ...[
            Opacity(
              opacity: _isWarningEnabled ? 1.0 : 0.5,
              child: _buildSensorLine(sensor, isCritical: false),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Widget _buildSensorLine(SelectedSensor sensor, {required bool isCritical}) {
    final key = _sensorKey(sensor);
    final RangeValues range = (isCritical
        ? (widget.criticalRanges != null && widget.criticalRanges!.containsKey(key)
        ? widget.criticalRanges![key]!
        : _defaultCriticalRange(sensor))
        : (widget.warningRanges != null && widget.warningRanges!.containsKey(key)
        ? widget.warningRanges![key]!
        : _defaultWarningRange(sensor)));

    final color = isCritical ? GardenColors.redAlert.shade500 : GardenColors.yellowWarning.shade600;

    // Determine axis min, max and unit based on sensor type
    final _TypeAxis axis = _axisForType(sensor.type);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // centre verticalement icône + gauge
        children: [
          // Icone à gauche, taille réduite pour coller à la gauge
          Tooltip(
            message: '${sensor.type.displayName} ${sensor.index + 1} (${axis.unit})',
            child: SingleSensorIcon(
              sensorType: sensor.type,
              isActive: true,
              index: sensor.index,
              containerSize: 28,
              iconSize: 18,
            ),
          ),

          const SizedBox(width: 10),

          // La gauge prend l'espace restant
          Expanded(
            child: _buildSyncfusionGauge(
              range: range,
              color: color,
              min: axis.min,
              max: axis.max,
              unit: axis.unit,
              onChanged: (values) {
                if (isCritical) {
                  widget.onCriticalRangeChanged?.call(sensor, values);
                } else {
                  widget.onWarningRangeChanged?.call(sensor, values);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  RangeValues _defaultCriticalRange(SelectedSensor s) {
    switch (s.type) {
      case SensorType.temperature:
        return const RangeValues(0, 30);
      case SensorType.humiditySurface:
      case SensorType.humidityDepth:
      return const RangeValues(10, 80);
      case SensorType.light:
        return const RangeValues(100, 10000);
      case SensorType.rain:
        return const RangeValues(1, 80);
    }
  }

  RangeValues _defaultWarningRange(SelectedSensor s) {
    switch (s.type) {
      case SensorType.temperature:
        return const RangeValues(0, 30);
      case SensorType.humiditySurface:
      case SensorType.humidityDepth:
        return const RangeValues(10, 80);
      case SensorType.light:
        return const RangeValues(100, 10000);
      case SensorType.rain:
        return const RangeValues(1, 80);
    }
  }

  String _sensorKey(SelectedSensor s) => '${s.type.index}_${s.index}';

  // Axis info per sensor type
  _TypeAxis _axisForType(SensorType t) {
    switch (t) {
      case SensorType.temperature:
        return _TypeAxis(min: -20, max: 50, unit: '°C');
      case SensorType.humiditySurface:
      case SensorType.humidityDepth:
        return _TypeAxis(min: 0, max: 100, unit: '%');
      case SensorType.light:
        return _TypeAxis(min: 0, max: 20000, unit: 'lm');
      case SensorType.rain:
        return _TypeAxis(min: 0, max: 100, unit: '%');
    }
  }

  Widget _buildSyncfusionGauge({
    required RangeValues range,
    required Color color,
    required double min,
    required double max,
    required String unit,
    ValueChanged<RangeValues>? onChanged,
  }) {
    return Container(
      height: 75,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SfLinearGauge(
                minimum: min,
                maximum: max,
                orientation: LinearGaugeOrientation.horizontal,
                majorTickStyle: const LinearTickStyle(
                  length: 8,
                  thickness: 2,
                  color: Colors.grey,
                ),
                minorTickStyle: const LinearTickStyle(
                  length: 4,
                  thickness: 1,
                  color: Colors.grey,
                ),
                axisLabelStyle: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
                interval: ((max - min) / 6).roundToDouble(),
                minorTicksPerInterval: 4,
                showTicks: true,
                showLabels: true,
                markerPointers: [
                  LinearShapePointer(
                    value: range.start,
                    shapeType: LinearShapePointerType.circle,
                    color: color,
                    height: 12,
                    width: 12,
                    position: LinearElementPosition.cross,
                    onChanged:
                        onChanged != null
                            ? (value) {
                              if (value < range.end) {
                                onChanged(RangeValues(value, range.end));
                              }
                            }
                            : null,
                  ),
                  LinearShapePointer(
                    value: range.end,
                    shapeType: LinearShapePointerType.circle,
                    color: color,
                    height: 12,
                    width: 12,
                    position: LinearElementPosition.cross,
                    onChanged:
                        onChanged != null
                            ? (value) {
                              if (value > range.start) {
                                onChanged(RangeValues(range.start, value));
                              }
                            }
                            : null,
                  ),
                ],
                ranges: [
                  LinearGaugeRange(
                    startValue: range.start,
                    endValue: range.end,
                    color: color.withValues(alpha: 0.3),
                    position: LinearElementPosition.cross,
                  ),
                ],
              ),

              // Labels avec positionnement précis basé sur la largeur réelle
              _buildValueLabel(
                value: range.start,
                color: color,
                width: constraints.maxWidth,
                unit: unit,
                min: min,
                max: max,
              ),

              _buildValueLabel(
                value: range.end,
                color: color,
                width: constraints.maxWidth,
                unit: unit,
                min: min,
                max: max,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildValueLabel({
    required double value,
    required Color color,
    required double width,
    required String unit,
    required double min,
    required double max,
  }) {
    final double relativePosition = (value - min) / (max - min);
    final double leftPosition = (relativePosition * width) - 20; // -20 pour centrer

    return Positioned(
      left: leftPosition.clamp(0, width - 40),
      top: -0.5,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '${_formatValue(value, unit)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  String _formatValue(double value, String unit) {
    if (unit == '°C') return '${value.round()}°C';
    if (unit == '%') return '${value.round()}%';
    if (unit == 'lm') return '${value.round()} lm';
    return '${value.round()} $unit';
  }
}

class _TypeAxis {
  final double min;
  final double max;
  final String unit;

  _TypeAxis({required this.min, required this.max, required this.unit});
}
