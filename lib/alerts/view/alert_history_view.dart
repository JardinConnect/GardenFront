import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/alert_bloc.dart';
import '../models/alert_models.dart';
import '../widgets/history/alert_history_table.dart';
import '../../../common/widgets/generic_dialog.dart';

class AlertHistoryView extends StatelessWidget {
  final List<AlertEvent> alertEvents;

  const AlertHistoryView({super.key, required this.alertEvents});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertTable(
        events: alertEvents,
        onArchiveEvent: (event) => context.read<AlertBloc>().add(AlertDeleteEvent(eventId: event.id)),
        onArchiveAll: alertEvents.isNotEmpty ? () => _confirmArchiveAll(context) : null,
      ),
    );
  }

  // Demande confirmation avant d'archiver tout l'historique
  Future<void> _confirmArchiveAll(BuildContext context) async {
    final confirmed = await StyledDialog.show<bool>(
      context,
      title: 'Archiver tout l\'historique',
      widthFactor: 0.3,
      content: _ArchiveAllContent(count: alertEvents.length),
    );
    if (confirmed == true && context.mounted) {
      context.read<AlertBloc>().add(AlertArchiveAll());
    }
  }
}

class _ArchiveAllContent extends StatelessWidget {
  final int count;

  const _ArchiveAllContent({required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Êtes-vous sûr de vouloir archiver les $count événements ?\nCette action est irréversible.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler'),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.archive_rounded, size: 16),
              label: const Text('Archiver tout'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}