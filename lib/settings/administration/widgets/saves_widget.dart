import 'package:flutter/material.dart';
import 'package:garden_connect/settings/administration/widgets/administration_card_widget.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

class SavesWidget extends StatelessWidget {
  const SavesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AdministrationCardWidget(
      title: "Sauvegardes",
      subtitle: "Gérez vos sauvegardes",
      icon: Icons.backup_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: GardenSpace.gapMd,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                label: "Créer une sauvegarde",
                icon: Icons.file_download_outlined,
                onPressed: () => {},
              ),
            ],
          ),
          Text("Vos dernières sauvegardes", style: GardenTypography.bodyLg),
          Column(
            spacing: GardenSpace.gapSm,
            children: [
              _buildSaveCard("04/05/2026"),
              _buildSaveCard("14/02/2026"),
              _buildSaveCard("02/01/2026"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSaveCard(String date) {
    return GardenCard(
      child: Row(
        children: [
          Expanded(
            child: Row(
              spacing: GardenSpace.gapSm,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: GardenColors.primary.shade500,
                ),
                Text(date),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: GardenSpace.gapSm,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: GardenColors.tertiary.shade500,
                  ),
                ),
                Text("Terminée"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
