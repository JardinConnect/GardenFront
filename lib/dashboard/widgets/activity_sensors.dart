import 'package:flutter/material.dart';
import 'package:garden_connect/dashboard/widgets/dialog_box_widget.dart';
import 'package:garden_ui/ui/foundation/color/color_design_system.dart';

import '../../analytics/models/analytics.dart';

class ActivitySensors extends StatelessWidget {
  final Analytics analytics;

  const ActivitySensors({
    super.key,
    required this.analytics,
  });

  Color _getColorForAlertStatus(AnalyticAlertStatus? status) {
    if (status == null) {
      return Colors.grey.shade200;
    }

    switch (status) {
      case AnalyticAlertStatus.ok:
        return GardenColors.tertiary.shade700;
      case AnalyticAlertStatus.warning:
        return GardenColors.yellowWarning.shade400;
      case AnalyticAlertStatus.alert:
        return GardenColors.redAlert.shade600;
    }
  }

  AnalyticAlertStatus? _getMostCriticalStatusForDay(DateTime day) {
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final allAnalytics = analytics.getAllAnalytics();

    final dayAnalytics = allAnalytics.where((analytic) {
      return analytic.occurredAt.isAfter(dayStart) &&
          analytic.occurredAt.isBefore(dayEnd);
    }).toList();

    if (dayAnalytics.isEmpty) {
      return null;
    }

    bool hasAlert = dayAnalytics.any((a) => a.alertStatus == AnalyticAlertStatus.alert);
    bool hasWarning = dayAnalytics.any((a) => a.alertStatus == AnalyticAlertStatus.warning);

    if (hasAlert) {
      return AnalyticAlertStatus.alert;
    } else if (hasWarning) {
      return AnalyticAlertStatus.warning;
    } else {
      return AnalyticAlertStatus.ok;
    }
  }

  @override
  Widget build(BuildContext context) {
    const int daysInWeek = 7;
    const int totalDays = 365;
    final now = DateTime.now();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: List.generate(52, (weekIndex) {
            return Column(
              children: List.generate(daysInWeek, (dayIndex) {
                final dataIndex = weekIndex * daysInWeek + dayIndex;

                if (dataIndex >= totalDays) {
                  return const SizedBox.shrink();
                }

                final dayDate = now.subtract(Duration(days: totalDays - dataIndex - 1));
                final mostCriticalStatus = _getMostCriticalStatusForDay(dayDate);

                return GestureDetector(
                  onTap: () {
                    final dayStart = DateTime(dayDate.year, dayDate.month, dayDate.day);
                    final dayEnd = dayStart.add(const Duration(days: 1));

                    final dayAnalytics = analytics.filterByDateRange(dayStart, dayEnd);

                    showDialog(
                      context: context,
                      builder: (context) => DialogBoxWidget(
                        title: 'Activité du ${dayDate.day}/${dayDate.month}/${dayDate.year}',
                        analytics: dayAnalytics,
                      ),
                    );
                  },
                  child: Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: _getColorForAlertStatus(mostCriticalStatus),
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
}