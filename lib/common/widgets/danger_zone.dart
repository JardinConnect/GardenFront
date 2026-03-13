import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

import '../../core/app_assets.dart';
import 'generic_dialog.dart';

class DangerZone extends StatelessWidget {
  final String title;
  final String description;
  final String deleteButtonLabel;
  final VoidCallback onDelete;

  const DangerZone({
    super.key,
    required this.title,
    required this.description,
    required this.deleteButtonLabel,
    required this.onDelete,
  });

  void _showDeleteConfirmationDialog(BuildContext context) {
    StyledDialog.show<bool>(
      context,
      title: 'Confirmer la suppression',
      headerColor: GardenColors.redAlert.shade500,
      dismissible: false,
      widthFactor: 0.4,
      imagePath: AppAssets.deleteAlertV2,
      content: Container(
        padding: EdgeInsets.all(GardenSpace.paddingSm),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: GardenRadius.radiusSm,
          border: Border.all(color: Colors.red, width: 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 18),
            SizedBox(width: GardenSpace.gapSm),
            Expanded(
              child: Text(
              'Êtes-vous sûr de vouloir supprimer cet élément ?\nLes espaces enfants seront supprimés\nCette action est irréversible.',
              style: GardenTypography.bodyMd.copyWith(color: Colors.red.shade800),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
          child: Text('Annuler', style: GardenTypography.bodyMd),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(true);
            onDelete();
          },
          icon: const Icon(Icons.delete_forever_rounded, size: 16),
          label: const Text('Supprimer'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
        borderRadius: GardenRadius.radiusMd,
      ),
      child: GardenCard(
        child: Padding(
          padding: EdgeInsets.all(GardenSpace.paddingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: GardenSpace.gapMd,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 24,
                  ),
                  SizedBox(width: GardenSpace.gapSm),
                  Text(
                    title,
                    style: GardenTypography.headingSm.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              Text(
                description,
                style: GardenTypography.bodyMd.copyWith(
                  color: Colors.grey[700],
                ),
              ),
              Center(
                child: Button(
                  label: deleteButtonLabel,
                  icon: Icons.delete_outline,
                  severity: ButtonSeverity.danger,
                  onPressed: () => _showDeleteConfirmationDialog(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
