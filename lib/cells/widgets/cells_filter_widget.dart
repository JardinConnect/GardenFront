import 'package:flutter/material.dart';
import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:garden_ui/ui/design_system.dart';

class CellsFilterWidget extends StatelessWidget {
  final AnalyticType? filter;
  final ValueChanged<AnalyticType?>? onChanged;

  const CellsFilterWidget({
    super.key,
    required this.filter,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<AnalyticType>(
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
        ...AnalyticType.values.map(
              (type) =>
              DropdownMenuItem(
                value: type,
                child: Text(
                  type.name,
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