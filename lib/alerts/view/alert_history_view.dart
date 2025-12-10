import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/alert_bloc.dart';
import '../models/alert_models.dart';
import '../widgets/history/alert_table.dart';

/// Composant pour l'affichage de l'historique des alertes
/// Permet de visualiser tous les événements d'alerte déclenchés
/// et de les archiver individuellement ou en masse
class AlertHistoryView extends StatelessWidget {
  final List<AlertEvent> alertEvents;

  const AlertHistoryView({super.key, required this.alertEvents});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertTable(
        events: alertEvents,
        showHeaders: true,
        onDeleteEvent: (event) => _handleArchiveEvent(context, event),
        onArchiveAll: alertEvents.isNotEmpty
            ? () => _handleArchiveAll(context) 
            : null,
      ),
    );
  }

  /// Gère l'archivage d'un événement spécifique
  /// Envoie l'événement au Bloc pour archiver
  void _handleArchiveEvent(BuildContext context, AlertEvent event) {
    context.read<AlertBloc>().add(AlertDeleteEvent(eventId: event.id));
  }

  /// Gère l'archivage de tous les événements de l'historique
  /// Affiche une boîte de dialogue de confirmation avant d'archiver
  Future<void> _handleArchiveAll(BuildContext context) async {
    if (alertEvents.isEmpty) return;

    // Afficher une boîte de dialogue de confirmation
    final confirmed = await _showArchiveAllConfirmationDialog(context);

    // Si l'utilisateur confirme et que le contexte est toujours monté
    if (confirmed == true && context.mounted) {
      context.read<AlertBloc>().add(AlertArchiveAll());
    }
  }

  /// Affiche une boîte de dialogue de confirmation pour l'archivage total
  /// Retourne true si l'utilisateur confirme, false sinon
  Future<bool?> _showArchiveAllConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Archiver tout l\'historique'),
        content: Text(
          'Êtes-vous sûr de vouloir archiver tous les ${alertEvents.length} événements ?\n\n'
          'Cette action est irréversible.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          // Bouton Annuler
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          // Bouton Archiver tout (en rouge pour indiquer l'importance)
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Archiver tout'),
          ),
        ],
      ),
    );
  }
}