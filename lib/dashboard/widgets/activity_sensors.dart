import 'package:flutter/material.dart';
import 'package:garden_connect/dashboard/widgets/activity_alerts_dialog.dart';
import 'package:garden_ui/ui/design_system.dart';

import '../../analytics/models/analytics.dart';
import '../../analytics/repository/analytics_repository.dart';
import '../../alerts/models/alert_models.dart';
import '../../alerts/repository/alert_repository.dart';

class ActivitySensors extends StatefulWidget {
  const ActivitySensors({super.key});

  @override
  State<ActivitySensors> createState() => _ActivitySensorsState();
}

class _ActivitySensorsState extends State<ActivitySensors> {
  final AnalyticsRepository _analyticsRepository = AnalyticsRepository();
  final AlertRepository _alertRepository = AlertRepository();
  late final Future<_ActivityData> _activityDataFuture;

  @override
  void initState() {
    super.initState();
    _activityDataFuture = _loadActivityData();
  }

  Future<_ActivityData> _loadActivityData() async {
    final now = DateTime.now();
    final oneYearAgo = now.subtract(const Duration(days: 365));

    final results = await Future.wait([
      _analyticsRepository.fetchActivityAnalytics(),
      _alertRepository.fetchAlertEventsByDateRange(oneYearAgo, now),
    ]);

    return _ActivityData(
      analytics: results[0] as Analytics,
      events: results[1] as List<AlertEvent>,
    );
  }

  Color _getColorForDaySeverity(_DaySeverity severity) {
    switch (severity) {
      case _DaySeverity.ok:
        return GardenColors.primary.shade700;
      case _DaySeverity.warning:
        return GardenColors.yellowWarning.shade400;
      case _DaySeverity.critical:
        return GardenColors.redAlert.shade600;
    }
  }

  _DaySeverity _getMostCriticalSeverityForDay(
    DateTime day,
    List<AlertEvent> events,
  ) {
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final dayEvents = events.where((event) {
      return !event.timestamp.isBefore(dayStart) &&
          event.timestamp.isBefore(dayEnd);
    }).toList();

    if (dayEvents.isEmpty) {
      return _DaySeverity.ok;
    }

    bool hasCritical = dayEvents.any(
      (e) => _normalizeSeverity(e.severity) == _DaySeverity.critical,
    );
    bool hasWarning = dayEvents.any(
      (e) => _normalizeSeverity(e.severity) == _DaySeverity.warning,
    );

    if (hasCritical) {
      return _DaySeverity.critical;
    } else if (hasWarning) {
      return _DaySeverity.warning;
    } else {
      return _DaySeverity.ok;
    }
  }

  _DaySeverity _normalizeSeverity(String severity) {
    final value = severity.toLowerCase();
    if (value == 'critical' || value == 'alert' || value == 'error') {
      return _DaySeverity.critical;
    }
    if (value == 'warning' || value == 'warn') {
      return _DaySeverity.warning;
    }
    return _DaySeverity.ok;
  }

  Widget _buildActivityGrid(
    BuildContext context,
    Analytics _,
    List<AlertEvent> events,
  ) {
    const int daysInWeek = 7;
    const int totalDays = 365;
    final now = DateTime.now();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.all(GardenSpace.paddingMd),
        child: Row(
          children: List.generate(52, (weekIndex) {
            return Column(
              children: List.generate(daysInWeek, (dayIndex) {
                final dataIndex = weekIndex * daysInWeek + dayIndex;

                if (dataIndex >= totalDays) {
                  return const SizedBox.shrink();
                }

                final dayDate = now.subtract(
                  Duration(days: totalDays - dataIndex - 1),
                );
                final mostCriticalStatus =
                    _getMostCriticalSeverityForDay(dayDate, events);

                return GestureDetector(
                  onTap: mostCriticalStatus == _DaySeverity.ok
                      ? null
                      : () {
                    final dayStart = DateTime(
                      dayDate.year,
                      dayDate.month,
                      dayDate.day,
                    );
                    final dayEnd = dayStart.add(const Duration(days: 1));

                    final dayEvents = events.where((event) {
                      return !event.timestamp.isBefore(dayStart) &&
                          event.timestamp.isBefore(dayEnd);
                    }).toList();

                    showDialog(
                      context: context,
                      builder: (context) => ActivityAlertsDialog(
                        day: dayDate,
                        events: dayEvents,
                      ),
                    );
                  },
                  child: Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: _getColorForDaySeverity(mostCriticalStatus),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_ActivityData>(
      future: _activityDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Erreur: ${snapshot.error}'),
          );
        }

        final data = snapshot.data ?? _ActivityData.empty();
        return _buildActivityGrid(context, data.analytics, data.events);
      },
    );
  }
}

enum _DaySeverity { ok, warning, critical }

class _ActivityData {
  final Analytics analytics;
  final List<AlertEvent> events;

  const _ActivityData({
    required this.analytics,
    required this.events,
  });

  factory _ActivityData.empty() {
    return _ActivityData(analytics: Analytics(), events: const []);
  }
}
