import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/design_system.dart';

import '../bloc/alert_bloc.dart';
import '../models/alert_models.dart';
import '../widgets/history/alert_history_table.dart';
import '../../../common/widgets/generic_dialog.dart';
import '../../../core/app_assets.dart';

class AlertHistoryView extends StatelessWidget {
  final List<AlertEvent> alertEvents;

  const AlertHistoryView({super.key, required this.alertEvents});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertTable(
        events: alertEvents,
        onArchiveEvent:
            (event) => context.read<AlertBloc>().add(
              AlertDeleteEvent(eventId: event.id),
            ),
        onArchiveAll:
            alertEvents.isNotEmpty ? () => _confirmArchiveAll(context) : null,
      ),
    );
  }

  Future<void> _confirmArchiveAll(BuildContext context) async {
    final confirmed = await StyledDialog.show<bool>(
      context,
      title: 'Archiver tout l\'historique',
      headerColor: GardenColors.redAlert.shade500,
      widthFactor: 0.4,
      imagePath: AppAssets.deleteAlertV2,
      content: _ArchiveAllContent(count: alertEvents.length),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
          child: Text('Annuler', style: GardenTypography.bodyMd),
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
          icon: const Icon(Icons.archive_rounded, size: 16),
          label: const Text('Archiver tout'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
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
    return Container(
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
              'Êtes-vous sûr de vouloir archiver les $count événements ?\nCette action est irréversible.',
              style: GardenTypography.bodyMd.copyWith(
                color: Colors.red.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
