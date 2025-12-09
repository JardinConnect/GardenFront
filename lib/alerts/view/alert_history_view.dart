import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/alert_bloc.dart';
import '../models/alert_models.dart';
import '../widgets/history/alert_table.dart';

/// Composant pour l'affichage de l'historique des alertes
class AlertHistoryView extends StatelessWidget {
  final List<AlertEvent> alertEvents;

  const AlertHistoryView({super.key, required this.alertEvents});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertTable(
        events: alertEvents,
        showHeaders: true,
        onDeleteEvent: (event) {
          context.read<AlertBloc>().add(AlertDeleteEvent(eventId: event.id));
        },
        onArchiveAll: alertEvents.isNotEmpty 
            ? () => _handleArchiveAll(context) 
            : null,
      ),
    );
  }

  Future<void> _handleArchiveAll(BuildContext context) async {
    if (alertEvents.isEmpty) return;

    // Dialog de confirmation
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archiver tout l\'historique'),
        content: Text('Êtes-vous sûr de vouloir archiver tous les ${alertEvents.length} événements ?\nCette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Archiver tout'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<AlertBloc>().add(AlertArchiveAll());
    }
  }
}