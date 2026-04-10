import 'package:flutter/material.dart';
import 'package:garden_connect/settings/administration/widgets/administration_card_widget.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

class AdminDangerZoneWidget extends StatelessWidget {
  const AdminDangerZoneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AdministrationCardWidget(
      title: "Zone de danger",
      subtitle: "Actions irréversibles et critiques",
      icon: Icons.warning_amber_rounded,
      iconColor: GardenColors.redAlert.shade500,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: GardenColors.redAlert.shade50,
          borderRadius: GardenRadius.radiusSm,
          border: BoxBorder.all(color: GardenColors.redAlert.shade500),
        ),
        child: Padding(
          padding: EdgeInsets.all(GardenSpace.paddingMd),
          child: Column(
            spacing: GardenSpace.gapMd,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Attention !",
                style: GardenTypography.headingSm.copyWith(
                  color: GardenColors.redAlert.shade600,
                ),
              ),
              Text(
                "Ces actions sont irréversibles. Procédez avec prudence. Assurez-vous d'avoir sauvegardé vos données avant toute action.",
                style: GardenTypography.bodyMd,
              ),

              Column(
                spacing: GardenSpace.gapMd,
                children: [
                  _buildDangerCard(
                    "Rétablit tous les réglages du système à leurs valeurs d’origine sans toucher aux données.",
                    "Réinitialiser les paramètres",
                    Icons.autorenew_outlined,
                  ),
                  _buildDangerCard(
                    "Supprime définitivement toutes les mesures enregistrées par les cellules.",
                    "Effacer l'historique des cellules",
                    Icons.delete_outline_outlined,
                  ),
                  _buildDangerCard(
                    "Retire chaque cellule de la cellule mère et réinitialise leurs liaisons LoRa.",
                    "Dissocier toutes les cellules",
                    Icons.highlight_off_outlined,
                  ),
                  _buildDangerCard(
                    "Efface l’ensemble de la structure hiérarchique des espaces et zones.",
                    "Supprimer tous les espaces",
                    Icons.report_outlined,
                  ),
                  _buildDangerCard(
                    "Supprime l’ensemble des données du Raspberry Pi.",
                    "Suppression complète",
                    Icons.delete_forever_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDangerCard(
    String title,
    String buttonLabel,
    IconData buttonIcon,
  ) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: GardenColors.redAlert.shade50,
              borderRadius: GardenRadius.radiusSm,
              border: BoxBorder.all(color: GardenColors.redAlert.shade500),
              boxShadow: GardenShadow.shadowSm,
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: GardenSpace.gapMd,
                vertical: GardenSpace.gapMd,
              ),
              child: Column(
                spacing: GardenSpace.gapMd,
                children: [
                  Text(title, style: GardenTypography.bodyMd),
                  Button(
                    label: buttonLabel,
                    icon: buttonIcon,
                    severity: ButtonSeverity.danger,
                    onPressed: () => {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
