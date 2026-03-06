import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:intl/intl.dart';

import '../../models/alert_models.dart';

class AlertTable extends StatelessWidget {
  final List<AlertEvent> events;
  final ValueChanged<AlertEvent>? onArchiveEvent;
  final VoidCallback? onArchiveAll;

  const AlertTable({
    super.key,
    required this.events,
    this.onArchiveEvent,
    this.onArchiveAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(GardenSpace.paddingXs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (events.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  "Aucun événement dans l'historique",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else
            _buildTableHeader(context),
          SizedBox(height: GardenSpace.gapSm),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            separatorBuilder: (_, __) => SizedBox(height: GardenSpace.gapSm),
            itemBuilder: (_, index) => _buildEventRow(events[index], context),
          ),
        ],
      ),
    );
  }

  static const double _colGap = 32;

  Widget _buildTableHeader(BuildContext context) {
    return GardenCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 32),
          const SizedBox(width: _colGap),
          Expanded(flex: 2, child: _headerCell('Valeur')),
          const SizedBox(width: _colGap),
          Expanded(flex: 3, child: _headerCell('Cellule')),
          const SizedBox(width: _colGap),
          Expanded(flex: 2, child: _headerCell('Date')),
          const SizedBox(width: _colGap),
          Expanded(flex: 2, child: _headerCell('Heure')),
          const SizedBox(width: _colGap),
          Expanded(flex: 3, child: _headerCell('Localisation')),
          const SizedBox(width: _colGap),
          // Bouton archiver tout
          GestureDetector(
            onTap: onArchiveAll,
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

  Widget _headerCell(String label) {
    return Text(
      label,
      style: GardenTypography.bodyLg.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildEventRow(AlertEvent event, BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GardenCard(
        hasBorder: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icône du capteur
            SizedBox(
              width: 32,
              child: GardenIcon(
                iconName: event.sensorType.iconName,
                size: GardenIconSize.md,
                color: getSensorColor(event.sensorType),
              ),
            ),
            const SizedBox(width: _colGap),
            // Valeur
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: Colors.red.shade600,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      event.value.toString(),
                      style: GardenTypography.bodyLg,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: _colGap),
            // Cellule
            Expanded(
              flex: 3,
              child: Text(
                event.cellName,
                style: GardenTypography.bodyLg,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: _colGap),
            // Date
            Expanded(
              flex: 2,
              child: Text(
                DateFormat('dd/MM/yyyy').format(event.timestamp),
                style: GardenTypography.bodyLg,
              ),
            ),
            const SizedBox(width: _colGap),
            // Heure
            Expanded(
              flex: 2,
              child: Text(
                DateFormat('HH:mm').format(event.timestamp),
                style: GardenTypography.bodyLg,
              ),
            ),
            const SizedBox(width: _colGap),
            // Localisation
            Expanded(
              flex: 3,
              child: Text(
                event.cellLocation,
                style: GardenTypography.bodyLg.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: _colGap),
            // Bouton archiver
            GestureDetector(
              onTap:
                  onArchiveEvent != null ? () => onArchiveEvent!(event) : null,
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
    );
  }
}
