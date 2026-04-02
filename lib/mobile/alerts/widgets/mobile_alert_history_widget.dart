import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:intl/intl.dart';

import '../../../alerts/bloc/alert_bloc.dart';
import '../../../alerts/models/alert_models.dart';
import '../../../common/widgets/empty_state_widget.dart';
import '../../../common/widgets/generic_dialog.dart';
import '../../../core/app_assets.dart';

/// Vue de l'historique des alertes pour la version mobile.
///
/// Affiche la liste des événements d'alerte avec la possibilité d'archiver
/// un événement individuel ou tous les événements via un bouton de confirmation.
class MobileAlertHistoryWidget extends StatelessWidget {
  /// Liste des événements d'alerte à afficher.
  final List<AlertEvent> alertEvents;

  const MobileAlertHistoryWidget({super.key, required this.alertEvents});

  @override
  Widget build(BuildContext context) {
    if (alertEvents.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.history_rounded,
        message: "Aucun événement dans l'historique",
        subtitle: "Les déclenchements d'alertes apparaîtront ici.",
      );
    }

    return Column(
      children: [
        // En-tête avec bouton "Archiver tout"
        GardenCard(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Événements récents',
                  style: GardenTypography.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: GardenColors.typography.shade400,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _confirmArchiveAll(context),
                child: Padding(
                  padding: EdgeInsets.all(GardenSpace.paddingXs),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    size: 20,
                    color: GardenColors.typography.shade400,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: GardenSpace.gapMd),
        Expanded(
          child: ListView.separated(
            itemCount: alertEvents.length,
            separatorBuilder: (_, __) => SizedBox(height: GardenSpace.gapSm),
            itemBuilder: (context, index) =>
                _MobileAlertEventRow(event: alertEvents[index]),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmArchiveAll(BuildContext context) async {
    final confirmed = await StyledDialog.show<bool>(
      context,
      title: 'Archiver tout l\'historique',
      headerColor: GardenColors.redAlert.shade500,
      widthFactor: 0.9,
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

/// Ligne d'un événement d'alerte dans la liste mobile.
class _MobileAlertEventRow extends StatelessWidget {
  final AlertEvent event;

  const _MobileAlertEventRow({required this.event});

  @override
  Widget build(BuildContext context) {
    return GardenCard(
      hasBorder: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icône du type de capteur
          event.isBattery
              ? GardenIcon(
                  iconName: 'Batterie',
                  size: GardenIconSize.md,
                  color: Colors.green.shade600,
                )
              : GardenIcon(
                  iconName: event.sensorType.iconName,
                  size: GardenIconSize.md,
                  color: getSensorColor(event.sensorType),
                ),
          SizedBox(width: GardenSpace.gapSm),
          // Valeur et cellule
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 14,
                      color: Colors.red.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      event.value.toString(),
                      style: GardenTypography.bodyMd.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  event.cellName,
                  style: GardenTypography.caption.copyWith(
                    color: GardenColors.typography.shade400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  event.cellLocation,
                  style: GardenTypography.caption.copyWith(
                    color: GardenColors.typography.shade300,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          SizedBox(width: GardenSpace.gapSm),
          // Date et heure
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('dd/MM/yyyy').format(event.timestamp),
                style: GardenTypography.caption.copyWith(
                  color: GardenColors.typography.shade400,
                ),
              ),
              Text(
                DateFormat('HH:mm').format(event.timestamp),
                style: GardenTypography.caption.copyWith(
                  color: GardenColors.typography.shade300,
                ),
              ),
            ],
          ),
          SizedBox(width: GardenSpace.gapSm),
          // Bouton archiver
          GestureDetector(
            onTap: () => context.read<AlertBloc>().add(
              AlertDeleteEvent(eventId: event.id),
            ),
            child: Padding(
              padding: EdgeInsets.all(GardenSpace.paddingXs),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 20,
                color: GardenColors.typography.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Contenu affiché dans la boîte de confirmation d'archivage global.
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
