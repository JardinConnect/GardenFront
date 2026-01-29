import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

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
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Confirmer la suppression',
            style: GardenTypography.headingMd,
          ),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer cet élément ? Cette action est irréversible.',
            style: GardenTypography.bodyMd,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onDelete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8),
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
