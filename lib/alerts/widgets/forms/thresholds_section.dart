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
      crossAxisAlignment: CrossAxisAlignment.start,
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
      padding: const EdgeInsets.all(12), // Réduit de 16 à 12
      decoration: BoxDecoration(
        border: Border.all(color: GardenColors.primary.shade500, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alerte critique',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: GardenColors.redAlert.shade700,
            ),
          ),
          const SizedBox(height: 12), // Réduit de 16 à 12
          _buildSyncfusionGauge(
            range: _criticalRange,
            color: GardenColors.redAlert.shade500,
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
      padding: const EdgeInsets.all(12), // Réduit de 16 à 12
      decoration: BoxDecoration(
        border: Border.all(
          color: _isWarningEnabled
            ? GardenColors.primary.shade500
            : Colors.grey.shade300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
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
                  color: _isWarningEnabled
                    ? GardenColors.blueInfo.shade700
                    : Colors.grey.shade600,
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
            color: _isWarningEnabled
              ? GardenColors.blueInfo.shade500
              : Colors.grey.shade400,
            onChanged: _isWarningEnabled ? (RangeValues values) {
              setState(() {
                _warningRange = values;
              });
              widget.onWarningRangeChanged?.call(values);
            } : null,
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
      height: 45, // Réduit de 60 à 45
      child: SfLinearGauge(
        minimum: -20,
        maximum: 50,
        orientation: LinearGaugeOrientation.horizontal,
        majorTickStyle: const LinearTickStyle(
          length: 6, // Réduit de 8 à 6
          thickness: 1,
          color: Colors.grey,
        ),
        axisLabelStyle: TextStyle(
          fontSize: 10, // Réduit de 12 à 10
          color: Colors.grey.shade600,
        ),
        interval: 20, // Augmenté de 10 à 20 pour moins de labels
        showTicks: true,
        showLabels: true,
        markerPointers: [
          LinearShapePointer(
            value: range.start,
            shapeType: LinearShapePointerType.circle,
            color: color,
            height: 12, // Taille réduite
            width: 12,
            position: LinearElementPosition.cross,
            onChanged: onChanged != null ? (value) {
              if (value < range.end) {
                onChanged(RangeValues(value, range.end));
              }
            } : null,
          ),
          LinearShapePointer(
            value: range.end,
            shapeType: LinearShapePointerType.circle,
            color: color,
            height: 12, // Taille réduite
            width: 12,
            position: LinearElementPosition.cross,
            onChanged: onChanged != null ? (value) {
              if (value > range.start) {
                onChanged(RangeValues(range.start, value));
              }
            } : null,
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
        // Suppression du barPointer pour simplifier
      ),
    );
  }
}
