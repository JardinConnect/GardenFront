import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/settings/cells/bloc/cells_update_frequency_form_bloc.dart';
import 'package:garden_ui/ui/design_system.dart';

class CellUpdateFrequencyItem {
  final String name;
  final Duration value;

  const CellUpdateFrequencyItem({required this.name, required this.value});
}

class CellUpdateFrequencySelectionWidget extends StatelessWidget {
  final List<CellUpdateFrequencyItem> _items;

  const CellUpdateFrequencySelectionWidget({
    super.key,
    List<CellUpdateFrequencyItem> items = const [
      CellUpdateFrequencyItem(
        name: "Toutes les 15 min",
        value: Duration(minutes: 15),
      ),
      CellUpdateFrequencyItem(
        name: "Toutes les 30 min",
        value: Duration(minutes: 30),
      ),
      CellUpdateFrequencyItem(
        name: "Toutes les heures",
        value: Duration(hours: 1),
      ),
      CellUpdateFrequencyItem(
        name: "Toutes les 2 heures",
        value: Duration(hours: 2),
      ),
    ],
  }) : _items = items;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CellsUpdateFrequencyFormBloc>().state;

    return DropdownButtonFormField<Duration>(
      dropdownColor: GardenColors.base.shade50,
      style: GardenTypography.bodyLg.copyWith(
        color: GardenColors.typography.shade900,
      ),
      isExpanded: true,
      initialValue: state.measurementFrequency,
      items: [
        ..._items.map((item) {
          return DropdownMenuItem<Duration>(
            value: item.value,
            child: Text(item.name, style: GardenTypography.bodyLg),
          );
        }),
      ],
      onChanged: (Duration? value) {
        if (value != null) {
          context.read<CellsUpdateFrequencyFormBloc>().add(MeasurementFrequencyChanged(value));
        }
      },
    );
  }
}
