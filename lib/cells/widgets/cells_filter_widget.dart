import 'package:flutter/material.dart';
import 'package:garden_connect/cells/models/analytic_metric.dart';
import 'package:garden_ui/ui/design_system.dart';

class CellsFilterWidget extends StatelessWidget {
  final AnalyticMetric? filter;
  final ValueChanged<AnalyticMetric?>? onChanged;

  const CellsFilterWidget({
    super.key,
    required this.filter,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<AnalyticMetric>(
      decoration: const InputDecoration(
        hintText: "Filtre",
      ),
      dropdownColor: GardenColors.base.shade50,
      style: GardenTypography.bodyLg.copyWith(
        color: GardenColors.typography.shade900,
      ),
      initialValue: filter,
      isExpanded: true,
      items: [
        DropdownMenuItem(
          value: null,
          child: Text(
            "Filtre",
            style: GardenTypography.bodyLg.copyWith(
              color:
              GardenColors.typography.shade900,
            ),
          ),
        ),
        ...AnalyticMetric.values.map(
              (metric) =>
              DropdownMenuItem(
                value: metric,
                child: Text(
                  metric.label,
                  style:
                  GardenTypography.bodyLg.copyWith(
                    color: GardenColors
                        .typography.shade900,
                  ),
                ),
              ),
        ),
      ],
      onChanged: onChanged,
    );
  }

}