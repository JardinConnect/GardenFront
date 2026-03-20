import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:intl/intl.dart';

import '../../analytics/models/analytics.dart';
import '../../analytics/widgets/analytic_card.dart';
import '../../alerts/models/alert_models.dart';
import 'expandable_card.dart';

class ActivityAlertsDialog extends StatelessWidget {
  final DateTime day;
  final List<AlertEvent> events;

  const ActivityAlertsDialog({
    super.key,
    required this.day,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final sortedEvents = List<AlertEvent>.from(events)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final groups = _groupEvents(sortedEvents);

    final title = DateFormat('d MMMM yyyy', 'fr_FR').format(day);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: GardenRadius.radiusLg),
      clipBehavior: Clip.antiAlias,
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      title: Container(
        color: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded),
              color: Theme.of(context).colorScheme.onPrimary,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(14),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.5,
          child:
              groups.isEmpty
                  ? const Center(child: Text('Aucun événement ce jour'))
                  : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < groups.length; i++) ...[
                          _buildGroup(groups[i], initiallyExpanded: i == 0),
                          if (i < groups.length - 1)
                            SizedBox(height: GardenSpace.gapSm),
                        ],
                      ],
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildGroup(
    _EventGroup group, {
    required bool initiallyExpanded,
  }) {
    final cards =
        group.events
            .map((event) {
              final type = _analyticTypeFromSensorTypeRaw(
                event.sensorTypeRaw,
              );
              if (type == null) {
                return null;
              }
              final status = _severityToAlertStatus(
                event.severity,
              );
              final analytic = _ActivityAnalytic(
                value: event.value,
                occurredAt: event.timestamp,
                type: type,
                alertStatus: status,
              );
              return SizedBox(
                width: 260,
                child: AnalyticCardWidget(
                  analytic: analytic,
                  type: type,
                ),
              );
            })
            .whereType<Widget>()
            .toList();

    return ExpandableCard(
      icon: null,
      title: '',
      titleWidget: Center(
        child: Text(
          DateFormat('HH:mm').format(group.timestamp),
          style: GardenTypography.headingLg,
        ),
      ),
      initiallyExpanded: initiallyExpanded,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.cellName,
              style: GardenTypography.bodyLg.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              group.cellLocation,
              style: GardenTypography.caption,
            ),
            SizedBox(height: GardenSpace.gapSm),
            Wrap(
              spacing: GardenSpace.gapMd,
              runSpacing: GardenSpace.gapMd,
              children: cards,
            ),
          ],
        ),
      ),
    );
  }

  List<_EventGroup> _groupEvents(List<AlertEvent> events) {
    final Map<String, _EventGroup> grouped = {};

    for (final event in events) {
      final key =
          '${event.cellId}|${event.timestamp.year}-${event.timestamp.month}-${event.timestamp.day}-${event.timestamp.hour}-${event.timestamp.minute}';
      final existing = grouped[key];
      if (existing == null) {
        grouped[key] = _EventGroup(
          cellId: event.cellId,
          cellName: event.cellName,
          cellLocation: event.cellLocation,
          timestamp: event.timestamp,
          events: [event],
        );
      } else {
        existing.events.add(event);
      }
    }

    return grouped.values.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }
}

class _ActivityAnalytic extends Analytic {
  final AnalyticType type;

  _ActivityAnalytic({
    required super.value,
    required super.occurredAt,
    required this.type,
    super.alertStatus,
  });

  @override
  AnalyticType getType() => type;
}

class _EventGroup {
  final String cellId;
  final String cellName;
  final String cellLocation;
  final DateTime timestamp;
  final List<AlertEvent> events;

  _EventGroup({
    required this.cellId,
    required this.cellName,
    required this.cellLocation,
    required this.timestamp,
    required this.events,
  });
}

AnalyticType? _analyticTypeFromSensorTypeRaw(String sensorTypeRaw) {
  switch (sensorTypeRaw) {
    case 'air_temperature':
      return AnalyticType.airTemperature;
    case 'soil_temperature':
      return AnalyticType.soilTemperature;
    case 'air_humidity':
      return AnalyticType.airHumidity;
    case 'soil_humidity':
      return AnalyticType.soilHumidity;
    case 'deep_soil_humidity':
      return AnalyticType.deepSoilHumidity;
    case 'light':
      return AnalyticType.light;
    case 'battery':
      return AnalyticType.battery;
  }
  return null;
}

AnalyticAlertStatus _severityToAlertStatus(String severity) {
  final value = severity.toLowerCase();
  if (value == 'critical' || value == 'alert' || value == 'error') {
    return AnalyticAlertStatus.alert;
  }
  if (value == 'warning' || value == 'warn') {
    return AnalyticAlertStatus.warning;
  }
  return AnalyticAlertStatus.ok;
}
