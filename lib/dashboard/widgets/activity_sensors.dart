import 'package:flutter/material.dart';
import 'package:garden_connect/dashboard/widgets/dialog_box_widget.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:intl/intl.dart';

import '../../alerts/models/alert_models.dart';
import '../../analytics/models/analytics.dart';
import '../../analytics/repository/analytics_repository.dart';

class ActivitySensors extends StatelessWidget {
  final List<AlertEvent> alerts;

  const ActivitySensors({
    super.key,
    required this.alerts,
  });

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Retourne les AlertEvents qui tombent dans la journée donnée.
  List<AlertEvent> _eventsForDay(DateTime day) {
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    return alerts.where((e) =>
    e.timestamp.isAfter(dayStart) && e.timestamp.isBefore(dayEnd),
    ).toList();
  }

  /// Sévérité max du jour : "critical" > "warning" > null (aucun event).
  String? _maxSeverityForDay(List<AlertEvent> dayEvents) {
    if (dayEvents.isEmpty) return null;
    if (dayEvents.any((e) => e.severity.toLowerCase() == 'critical')) {
      return 'critical';
    }
    if (dayEvents.any((e) => e.severity.toLowerCase() == 'warning')) {
      return 'warning';
    }
    return 'ok';
  }

  /// Retourne la cellId de l'event le plus critique du jour.
  /// Priorité : critical > warning > ok.
  String? _mostCriticalCellId(List<AlertEvent> dayEvents) {
    if (dayEvents.isEmpty) return null;

    const order = ['critical', 'warning', 'ok'];
    for (final severity in order) {
      final match = dayEvents
          .where((e) => e.severity.toLowerCase() == severity)
          .toList();
      if (match.isNotEmpty) return match.first.cellId;
    }
    return dayEvents.first.cellId;
  }

  /// Couleur du carré selon la sévérité max.
  Color _colorForSeverity(String? severity) {
    switch (severity) {
      case 'critical':
        return const Color(0xFFE53935); // Rouge
      case 'warning':
        return const Color(0xFFFB8C00); // Orange
      case 'ok':
        return const Color(0xFF4CAF50); // Vert
      default:
        return const Color(0xFFE0E0E0); // Gris clair (aucun event)
    }
  }

  // ─── Tap handler ──────────────────────────────────────────────────────────

  Future<void> _onDayTap(BuildContext context, DateTime day) async {
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final dayEvents = _eventsForDay(day);
    final cellId = _mostCriticalCellId(dayEvents);

    // Jour sans event : pas de dialog utile
    if (cellId == null) return;

    showDialog(
      context: context,
      builder: (_) => _AnalyticsDayDialog(
        date: day,
        cellId: cellId,
        startDate: dayStart,
        endDate: dayEnd,
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    const int daysInWeek = 7;
    const int totalDays = 365;
    final now = DateTime.now();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.all(GardenSpace.paddingMd),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(52, (weekIndex) {
            return Column(
              children: List.generate(daysInWeek, (dayIndex) {
                final dataIndex = weekIndex * daysInWeek + dayIndex;
                if (dataIndex >= totalDays) return const SizedBox.shrink();

                final day = now.subtract(
                  Duration(days: totalDays - dataIndex - 1),
                );
                final dayEvents = _eventsForDay(day);
                final severity = _maxSeverityForDay(dayEvents);

                return GestureDetector(
                  onTap: () => _onDayTap(context, day),
                  child: Tooltip(
                    message: DateFormat('d MMM yyyy', 'fr_FR').format(day),
                    child: Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: _colorForSeverity(severity),
                        borderRadius: BorderRadius.circular(2),
                      ),
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

// ─── Dialog avec chargement async des analytics ───────────────────────────────

class _AnalyticsDayDialog extends StatefulWidget {
  final DateTime date;
  final String cellId;
  final DateTime startDate;
  final DateTime endDate;

  const _AnalyticsDayDialog({
    required this.date,
    required this.cellId,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<_AnalyticsDayDialog> createState() => _AnalyticsDayDialogState();
}

class _AnalyticsDayDialogState extends State<_AnalyticsDayDialog> {
  final _repo = AnalyticsRepository();
  late Future<Analytics> _analyticsFuture;

  @override
  void initState() {
    super.initState();
    _analyticsFuture = _repo.fetchAnalyticsForCell(
      cellId: widget.cellId,
      startDate: widget.startDate,
      endDate: widget.endDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = DateFormat('d MMMM yyyy', 'fr_FR').format(widget.date);

    return FutureBuilder<Analytics>(
      future: _analyticsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return AlertDialog(
            title: Text(title),
            content: Text('Erreur : ${snapshot.error}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fermer'),
              ),
            ],
          );
        }

        return DialogBoxWidget(
          title: title,
          analytics: snapshot.data!,
        );
      },
    );
  }
}