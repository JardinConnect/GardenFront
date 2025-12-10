import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/components.dart';
import '../../bloc/alert_bloc.dart';

/// Widget pour la zone de danger avec le bouton de suppression d'alerte
/// Affiche un avertissement et permet de supprimer l'alerte
class AlertDangerZone extends StatelessWidget {
  final String alertId;
  final String alertName;

  const AlertDangerZone({
    super.key,
    required this.alertId,
    required this.alertName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red,
          width: 2,
        ),
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
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 24,
                ),
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
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
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
      context.read<AlertBloc>().add(AlertDeleteAlert(alertId: alertId));
    }
  }

  /// Affiche une boîte de dialogue de confirmation pour la suppression
  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            const SizedBox(width: 8),
            const Text('Confirmer la suppression'),
          ],
        ),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer l\'alerte "$alertName" ?\n\n'
          'Cette action est irréversible et toutes les données seront perdues.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          // Bouton Annuler
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          // Bouton Supprimer (en rouge)
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

