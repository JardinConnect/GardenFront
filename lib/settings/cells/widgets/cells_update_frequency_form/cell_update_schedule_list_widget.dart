import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/settings/cells/bloc/cells_update_frequency_form_bloc.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

class CellUpdateScheduleListWidget extends StatelessWidget {
  const CellUpdateScheduleListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CellsUpdateFrequencyFormBloc>().state;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 250),
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          spacing: GardenSpace.gapSm,
          children: List.generate(state.updateTimes.length, (index) {
            final time = state.updateTimes[index];

            return Row(
              spacing: GardenSpace.gapMd,
              children: [
                Text("${index + 1}", style: GardenTypography.bodyLg),
                SizedBox(
                  width: 150,
                  child: InkWell(
                    onTap: () async {
                      final TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: time,
                        cancelText: "Annuler",
                        confirmText: "Confirmer",
                        hourLabelText: "Heures",
                        minuteLabelText: "Minutes",
                        helpText: "Mise à jour n°${index + 1}",
                        builder: (context, child) {
                          return MediaQuery(
                            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        },
                      );
                      if(!context.mounted) return;
                      if (newTime != null) {
                        context.read<CellsUpdateFrequencyFormBloc>().add(
                          UpdateTimeChanged(index: index, newTime: newTime),
                        );
                      }
                    },
                    child: GardenCard(
                      hasShadow: false,
                      hasBorder: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
                            style: GardenTypography.bodyLg,
                          ),
                          Icon(
                            Icons.access_time_outlined,
                            color: GardenColors.primary.shade500,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}