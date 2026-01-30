import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/cells/models/cell.dart';
import 'package:garden_connect/settings/cells/bloc/cells_update_frequency_form_bloc.dart';
import 'package:garden_ui/ui/design_system.dart';

class CellsUpdateSelectionWidget extends StatelessWidget {
  final List<Cell> cells;

  const CellsUpdateSelectionWidget({super.key, required this.cells});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CellsUpdateFrequencyFormBloc>().state;

    return DropdownButtonFormField<Cell?>(
      dropdownColor: GardenColors.base.shade50,
      style: GardenTypography.bodyLg.copyWith(
        color: GardenColors.typography.shade900,
      ),
      initialValue: state.selectedCell,
      isExpanded: true,
      items: [
        DropdownMenuItem<Cell?>(
          value: null,
          child: Text('Tous', style: GardenTypography.bodyLg),
        ),
        ...cells.map((cell) {
          return DropdownMenuItem<Cell?>(
            value: cell,
            child: Text(cell.name, style: GardenTypography.bodyLg),
          );
        }),
      ],
      onChanged: (Cell? value) {
        context.read<CellsUpdateFrequencyFormBloc>().add(CellSelectionChanged(value));
      },
    );
  }
}
