import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/settings/cells/bloc/cells_update_frequency_form_bloc.dart';
import 'package:garden_ui/ui/design_system.dart';

class CellNumberDailyUpdateSelectionWidget extends StatelessWidget {
  const CellNumberDailyUpdateSelectionWidget({super.key});

  List<DropdownMenuItem<int>> get _items {
    List<DropdownMenuItem<int>> items = [];
    for (int i = 0; i < 8; i++) {
      items.add(
        DropdownMenuItem<int>(
          value: i + 1,
          child: Text("${i + 1} par jour", style: GardenTypography.bodyLg),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CellsUpdateFrequencyFormBloc>().state;
    return DropdownButtonFormField<int>(
      dropdownColor: GardenColors.base.shade50,
      style: GardenTypography.bodyLg.copyWith(
        color: GardenColors.typography.shade900,
      ),
      isExpanded: true,
      value: state.dailyUpdateCount,
      items: _items,
      onChanged: (int? value) {
        if (value != null) {
          context.read<CellsUpdateFrequencyFormBloc>().add(DailyUpdateCountChanged(value));
        }
      },
    );
  }
}
