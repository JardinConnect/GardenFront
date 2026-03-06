import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import '../../../common/widgets/generic_dialog.dart';
import '../../bloc/alert_bloc.dart';
import '../../models/alert_models.dart';

/// Widget pour la zone de danger avec le bouton de suppression d'alerte
/// Affiche un avertissement et permet de supprimer l'alerte
class AlertDangerZone extends StatelessWidget {
  final Alert alert;

  const AlertDangerZone({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre de la zone de danger
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Zone de danger',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              'La suppression d\'une alerte est irréversible. Toutes les données associées seront perdues.',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),

            const SizedBox(height: 16),

            // Bouton de suppression
            Button(
              label: 'Supprimer l\'alerte',
              icon: Icons.delete_forever,
              onPressed: () => _handleDeleteAlert(context),
              severity: ButtonSeverity.danger,
            ),
          ],
        ),
      ),
    );
  }

  /// Gère la suppression de l'alerte avec confirmation
  Future<void> _handleDeleteAlert(BuildContext context) async {
    // Afficher une boîte de dialogue de confirmation
    final confirmed = await _showDeleteConfirmationDialog(context);

    if (confirmed == true && context.mounted) {
      // Envoyer l'événement de suppression au Bloc
      context.read<AlertBloc>().add(AlertDeleteAlert(alertId: alert.id));
    }
  }

  /// Affiche une boîte de dialogue de confirmation pour la suppression
  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return StyledDialog.show<bool>(
      context,
      title: 'Confirmer la suppression',
      dismissible: false,
      widthFactor: 0.3,
      content: _DeleteConfirmContent(alertTitle: alert.title),
    );
  }
}

/// Contenu de la dialog de suppression — utilise son propre contexte pour les pops
class _DeleteConfirmContent extends StatelessWidget {
  final String alertTitle;

  const _DeleteConfirmContent({required this.alertTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(GardenSpace.paddingSm),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red, width: 2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Êtes-vous sûr de vouloir supprimer l\'alerte "$alertTitle" ?\n'
                  'Cette action est irréversible et toutes les données associées seront perdues.',
                  style: GardenTypography.bodyMd.copyWith(
                    color: Colors.red.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: GardenSpace.gapMd),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Annuler', style: GardenTypography.bodyMd),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.delete_forever_rounded, size: 16),
              label: const Text('Supprimer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
