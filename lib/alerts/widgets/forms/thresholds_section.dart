import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

/// Composant pour la section des seuils
class ThresholdsSection extends StatefulWidget {
  final RangeValues criticalRange;
  final RangeValues warningRange;
  final bool isWarningEnabled;
  final ValueChanged<RangeValues>? onCriticalRangeChanged;
  final ValueChanged<RangeValues>? onWarningRangeChanged;
  final ValueChanged<bool>? onWarningEnabledChanged;

  const ThresholdsSection({
    super.key,
    this.criticalRange = const RangeValues(-15, 45),
    this.warningRange = const RangeValues(-5, 30),
    this.isWarningEnabled = true,
    this.onCriticalRangeChanged,
    this.onWarningRangeChanged,
    this.onWarningEnabledChanged,
  });

  @override
  State<ThresholdsSection> createState() => _ThresholdsSectionState();
}

class _ThresholdsSectionState extends State<ThresholdsSection> {
  late RangeValues _criticalRange;
  late RangeValues _warningRange;
  late bool _isWarningEnabled;

  @override
  void initState() {
    super.initState();
    _criticalRange = widget.criticalRange;
    _warningRange = widget.warningRange;
    _isWarningEnabled = widget.isWarningEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section Alerte critique
        _buildCriticalSection(),
        const SizedBox(height: 16), // Réduit de 24 à 16
        // Section Avertissement
        _buildWarningSection(),
      ],
    );
  }

  Widget _buildCriticalSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alerte critique',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black, // Titre en noir
            ),
          ),
          const SizedBox(height: 12), // Réduit de 16 à 12
          _buildSyncfusionGauge(
            range: _criticalRange,
            color: GardenColors.redAlert.shade500, // Slider critique en rouge
            onChanged: (RangeValues values) {
              setState(() {
                _criticalRange = values;
              });
              widget.onCriticalRangeChanged?.call(values);
            },
          ),
          const SizedBox(height: 12), // Réduit de 16 à 12
          _buildSyncfusionGauge(
            range: _criticalRange,
            color: GardenColors.redAlert.shade500, // Slider critique en rouge
            onChanged: (RangeValues values) {
              setState(() {
                _criticalRange = values;
              });
              widget.onCriticalRangeChanged?.call(values);
            },
          ),
          const SizedBox(height: 12), // Réduit de 16 à 12
          _buildSyncfusionGauge(
            range: _criticalRange,
            color: GardenColors.redAlert.shade500, // Slider critique en rouge
            onChanged: (RangeValues values) {
              setState(() {
                _criticalRange = values;
              });
              widget.onCriticalRangeChanged?.call(values);
            },
          ),
          const SizedBox(height: 12), // Réduit de 16 à 12
          _buildSyncfusionGauge(
            range: _criticalRange,
            color: GardenColors.redAlert.shade500, // Slider critique en rouge
            onChanged: (RangeValues values) {
              setState(() {
                _criticalRange = values;
              });
              widget.onCriticalRangeChanged?.call(values);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWarningSection() {
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
                  color: Colors.black, // Titre en noir
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
          const SizedBox(height: 12), // Réduit de 16 à 12
          _buildSyncfusionGauge(
            range: _warningRange,
            color:
                _isWarningEnabled
                    ? GardenColors
                        .yellowWarning
                        .shade600 // Slider avertissement en jaune
                    : Colors.grey.shade400,
            onChanged:
                _isWarningEnabled
                    ? (RangeValues values) {
                      setState(() {
                        _warningRange = values;
                      });
                      widget.onWarningRangeChanged?.call(values);
                    }
                    : null,
          ),
          const SizedBox(height: 12), // Réduit de 16 à 12
          _buildSyncfusionGauge(
            range: _warningRange,
            color:
                _isWarningEnabled
                    ? GardenColors
                        .yellowWarning
                        .shade600 // Slider avertissement en jaune
                    : Colors.grey.shade400,
            onChanged:
                _isWarningEnabled
                    ? (RangeValues values) {
                      setState(() {
                        _warningRange = values;
                      });
                      widget.onWarningRangeChanged?.call(values);
                    }
                    : null,
          ),
          const SizedBox(height: 12), // Réduit de 16 à 12
          _buildSyncfusionGauge(
            range: _warningRange,
            color:
                _isWarningEnabled
                    ? GardenColors
                        .yellowWarning
                        .shade600 // Slider avertissement en jaune
                    : Colors.grey.shade400,
            onChanged:
                _isWarningEnabled
                    ? (RangeValues values) {
                      setState(() {
                        _warningRange = values;
                      });
                      widget.onWarningRangeChanged?.call(values);
                    }
                    : null,
          ),
          const SizedBox(height: 12), // Réduit de 16 à 12
          _buildSyncfusionGauge(
            range: _warningRange,
            color:
                _isWarningEnabled
                    ? GardenColors
                        .yellowWarning
                        .shade600 // Slider avertissement en jaune
                    : Colors.grey.shade400,
            onChanged:
                _isWarningEnabled
                    ? (RangeValues values) {
                      setState(() {
                        _warningRange = values;
                      });
                      widget.onWarningRangeChanged?.call(values);
                    }
                    : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSyncfusionGauge({
    required RangeValues range,
    required Color color,
    ValueChanged<RangeValues>? onChanged,
  }) {
    return Container(
      height: 75,
      // Augmenté de 65 à 75 pour faire place aux labels plus éloignés
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SfLinearGauge(
                minimum: -20,
                maximum: 50,
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
                interval: 10,
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
              ),

              _buildValueLabel(
                value: range.end,
                color: color,
                width: constraints.maxWidth,
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
  }) {
    // Calcul précis de la position basé sur la largeur réelle
    final double relativePosition = (value - (-20)) / (50 - (-20));
    final double leftPosition =
        (relativePosition * width) - 20; // -20 pour centrer le label

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
          '${value.round()}°C',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
