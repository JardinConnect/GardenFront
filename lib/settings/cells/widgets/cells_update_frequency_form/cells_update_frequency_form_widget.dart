import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/cells/models/cell.dart';
import 'package:garden_connect/settings/cells/bloc/cells_update_frequency_form_bloc.dart';
import 'package:garden_connect/settings/cells/widgets/cells_update_frequency_form/cell_number_daily_update_selection_widget.dart';
import 'package:garden_connect/settings/cells/widgets/cells_update_frequency_form/cell_update_schedule_list_widget.dart';
import 'package:garden_connect/settings/cells/widgets/cells_update_frequency_form/cells_update_selection_widget.dart';
import 'package:garden_connect/settings/cells/widgets/cells_update_frequency_form/cell_update_frequency_selection_widget.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

class CellsUpdateFrequencyFormWidget extends StatelessWidget {
  final List<Cell> cells;

  const CellsUpdateFrequencyFormWidget({super.key, required this.cells});

  @override
  Widget build(BuildContext context) {
    var labelStyle = GardenTypography.bodyLg.copyWith(
      fontWeight: FontWeight.w500,
    );

    return GardenCard(
      hasBorder: true,
      hasShadow: false,
      child: Column(
        spacing: GardenSpace.gapMd,
        children: [
          Row(
            spacing: GardenSpace.gapMd,
            children: [
              Icon(
                Icons.cloud_download_outlined,
                color: GardenColors.primary.shade500,
              ),
              Text(
                "Mise à jour des cellules",
                style: GardenTypography.bodyLg.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: GardenSpace.gapSm,
            children: [
              Text("Cellules :", style: labelStyle),
              CellsUpdateSelectionWidget(cells: cells),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: GardenSpace.gapSm,
            children: [
              Text("Fréquence de relevé :", style: labelStyle),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: GardenSpace.gapXs,
                children: [
                  Text(
                    "Nombre de relevés des capteurs pour les cellules",
                    style: GardenTypography.caption,
                  ),
                  CellUpdateFrequencySelectionWidget(),
                ],
              ),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: GardenSpace.gapSm,
            children: [
              Text("Fréquence de mise à jour :", style: labelStyle),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: GardenSpace.gapXs,
                children: [
                  Text(
                    "Nombre d’envois des données des cellules pour mettre à jour la base de données.\n⚠️ Un nombre élevé d’envois de données peut avoir un impact sur les batteries des cellules.\nNous nous conseillons de ne pas dépasser les 4 envois par jour.",
                    style: GardenTypography.caption,
                  ),
                  CellNumberDailyUpdateSelectionWidget(),
                ],
              ),
            ],
          ),

          CellUpdateScheduleListWidget(),

          Button(
            label: "Sauvegarder",
            onPressed: () {
              context.read<CellsUpdateFrequencyFormBloc>().add(
                FormSubmitted(cells: cells),
              );
            },
          ),
        ],
      ),
    );
  }
}
