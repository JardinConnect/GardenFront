import 'package:flutter/material.dart';
import 'package:garden_connect/alerts/models/alert_models.dart';
import 'package:garden_connect/alerts/repository/alert_repository.dart';
import 'package:garden_connect/alerts/widgets/alerts/sensor_icons_row.dart';
import 'package:garden_connect/mobile/common/widgets/mobile_header.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:garden_ui/ui/enums/sensor_type.dart';
import 'package:intl/intl.dart';

class MobileActivityCalendarPage extends StatefulWidget {
  const MobileActivityCalendarPage({super.key});

  @override
  State<MobileActivityCalendarPage> createState() =>
      _MobileActivityCalendarPageState();
}

class _MobileActivityCalendarPageState
    extends State<MobileActivityCalendarPage> {
  final AlertRepository _alertRepository = AlertRepository();
  late final Future<List<AlertEvent>> _eventsFuture;
  late final DateTime _minDate;
  late final DateTime _maxDate;

  late DateTime _selectedDay;
  late DateTime _focusedMonth;

  static const List<String> _weekdayLabels = [
    'Lun',
    'Mar',
    'Mer',
    'Jeu',
    'Ven',
    'Sam',
    'Dim',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _maxDate = DateTime(now.year, now.month, now.day);
    _minDate = _maxDate.subtract(const Duration(days: 365));
    _selectedDay = _maxDate;
    _focusedMonth = DateTime(_selectedDay.year, _selectedDay.month, 1);
    _eventsFuture =
        _alertRepository.fetchAlertEventsByDateRange(_minDate, _maxDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MobileHeader(),
      body: FutureBuilder<List<AlertEvent>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          final events = snapshot.data ?? const <AlertEvent>[];
          final dayMarkers = _buildDayMarkers(events);
          final selectedEvents =
              List<AlertEvent>.from(_eventsForDay(events, _selectedDay))
                ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: GardenSpace.paddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: GardenSpace.gapMd),
                _buildMonthHeader(),
                SizedBox(height: GardenSpace.gapSm),
                _buildWeekdayRow(),
                SizedBox(height: GardenSpace.gapSm),
                _buildCalendarGrid(dayMarkers),
                SizedBox(height: GardenSpace.gapLg),
                Text(
                  DateFormat('d MMMM yyyy', 'fr_FR').format(_selectedDay),
                  style: GardenTypography.bodyLg.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: GardenSpace.gapSm),
                if (selectedEvents.isEmpty)
                  Text(
                    'Aucune alerte ce jour',
                    style: GardenTypography.caption,
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: selectedEvents.length,
                    separatorBuilder:
                        (_, __) => SizedBox(height: GardenSpace.gapSm),
                    itemBuilder:
                        (context, index) =>
                            _buildAlertEventCard(selectedEvents[index]),
                  ),
                SizedBox(height: GardenSpace.gapLg),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthHeader() {
    final monthLabel = DateFormat('MMMM yyyy', 'fr_FR').format(_focusedMonth);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _canGoToPreviousMonth() ? _goToPreviousMonth : null,
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          monthLabel[0].toUpperCase() + monthLabel.substring(1),
          style: GardenTypography.bodyLg.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: _canGoToNextMonth() ? _goToNextMonth : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  Widget _buildWeekdayRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          _weekdayLabels
              .map(
                (label) => Expanded(
                  child: Center(
                    child: Text(label, style: GardenTypography.caption),
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildCalendarGrid(
    Map<DateTime, List<_DaySeverity>> dayMarkers,
  ) {
    final days = _buildCalendarDays(_focusedMonth);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1.1,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        final inMonth = day.month == _focusedMonth.month;
        final inRange =
            !day.isBefore(_minDate) && !day.isAfter(_maxDate);
        final isSelected = _isSameDay(day, _selectedDay);
        final markers = dayMarkers[_dateOnly(day)];

        return _buildDayCell(
          day,
          inMonth: inMonth,
          inRange: inRange,
          isSelected: isSelected,
          markers: markers,
        );
      },
    );
  }

  Widget _buildDayCell(
    DateTime day, {
    required bool inMonth,
    required bool inRange,
    required bool isSelected,
    required List<_DaySeverity>? markers,
  }) {
    final baseColor = GardenColors.typography.shade500;
    final mutedColor = GardenColors.primary.shade200;
    final textColor =
        inRange ? (inMonth ? baseColor : mutedColor) : mutedColor;
    final dotSeverities =
        (markers ?? const <_DaySeverity>[])
            .where((severity) => severity != _DaySeverity.ok)
            .toList();
    dotSeverities.sort((a, b) => b.index.compareTo(a.index));
    const maxDots = 6;
    final visibleDots =
        dotSeverities.length > maxDots
            ? dotSeverities.sublist(0, maxDots)
            : dotSeverities;
    final hasMore = dotSeverities.length > maxDots;

    return GestureDetector(
      onTap:
          inRange
              ? () {
                setState(() {
                  _selectedDay = day;
                  if (day.month != _focusedMonth.month ||
                      day.year != _focusedMonth.year) {
                    _focusedMonth = DateTime(day.year, day.month, 1);
                  }
                });
              }
              : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: GardenRadius.radiusSm,
          border:
              isSelected
                  ? Border.all(
                    color: GardenColors.primary.shade500,
                    width: 1.5,
                  )
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: GardenTypography.caption.copyWith(color: textColor),
            ),
            SizedBox(height: GardenSpace.gapXs),
            if (visibleDots.isNotEmpty)
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 2,
                runSpacing: 2,
                children: [
                  for (final severity in visibleDots)
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: _severityColor(severity),
                        shape: BoxShape.circle,
                      ),
                    ),
                  if (hasMore)
                    Text(
                      '+',
                      style: GardenTypography.caption.copyWith(
                        color: mutedColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertEventCard(AlertEvent event) {
    final severity = _normalizeSeverity(event.severity);
    final timeLabel = DateFormat('HH:mm').format(event.timestamp);
    final triangleColor = _triangleColor(severity);

    return Container(
      decoration: BoxDecoration(
        color: GardenColors.primary.shade50,
        borderRadius: GardenRadius.radiusMd,
      ),
      padding: EdgeInsets.all(GardenSpace.paddingSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: triangleColor,
                      size: 20,
                    ),
                    SizedBox(width: GardenSpace.gapSm),
                    Expanded(
                      child: Text(
                        event.cellName,
                        style: GardenTypography.bodyLg.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Text(timeLabel, style: GardenTypography.caption),
            ],
          ),
          if (event.cellLocation.isNotEmpty)
            Text(event.cellLocation, style: GardenTypography.caption),
          SizedBox(height: GardenSpace.gapSm),
          SensorIconsRow(activeSensorTypes: [event.sensorType]),
        ],
      ),
    );
  }

  List<DateTime> _buildCalendarDays(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final leadingEmpty = (firstDayOfMonth.weekday - 1) % 7;
    final totalCells =
        ((leadingEmpty + daysInMonth + 6) / 7).floor() * 7;
    final start = firstDayOfMonth.subtract(Duration(days: leadingEmpty));

    return List.generate(
      totalCells,
      (index) => start.add(Duration(days: index)),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<AlertEvent> _eventsForDay(List<AlertEvent> events, DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return events
        .where(
          (event) =>
              !event.timestamp.isBefore(start) &&
              event.timestamp.isBefore(end),
        )
        .toList();
  }

  Map<DateTime, List<_DaySeverity>> _buildDayMarkers(
    List<AlertEvent> events,
  ) {
    final Map<DateTime, List<_DaySeverity>> markers = {};
    for (final event in events) {
      final key = _dateOnly(event.timestamp);
      final severity = _normalizeSeverity(event.severity);
      markers.putIfAbsent(key, () => <_DaySeverity>[]).add(severity);
    }
    return markers;
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

  Color _severityColor(_DaySeverity severity) {
    switch (severity) {
      case _DaySeverity.warning:
        return GardenColors.yellowWarning.shade400;
      case _DaySeverity.critical:
        return GardenColors.redAlert.shade600;
      case _DaySeverity.ok:
      default:
        return GardenColors.primary.shade400;
    }
  }

  bool _canGoToPreviousMonth() {
    final previous = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    final minMonth = DateTime(_minDate.year, _minDate.month, 1);
    return !previous.isBefore(minMonth);
  }

  bool _canGoToNextMonth() {
    final next = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    final maxMonth = DateTime(_maxDate.year, _maxDate.month, 1);
    return !next.isAfter(maxMonth);
  }

  void _goToPreviousMonth() {
    setState(() {
      final nextMonth =
          DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
      _focusedMonth = nextMonth;
      _selectedDay = _clampDayToRange(
        _adjustDayInMonth(nextMonth, _selectedDay.day),
      );
    });
  }

  void _goToNextMonth() {
    setState(() {
      final nextMonth =
          DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
      _focusedMonth = nextMonth;
      _selectedDay = _clampDayToRange(
        _adjustDayInMonth(nextMonth, _selectedDay.day),
      );
    });
  }

  DateTime _adjustDayInMonth(DateTime month, int day) {
    final lastDay = DateUtils.getDaysInMonth(month.year, month.month);
    final safeDay = day.clamp(1, lastDay);
    return DateTime(month.year, month.month, safeDay);
  }

  DateTime _clampDayToRange(DateTime day) {
    if (day.isBefore(_minDate)) {
      return _minDate;
    }
    if (day.isAfter(_maxDate)) {
      return _maxDate;
    }
    return day;
  }

  Color _triangleColor(_DaySeverity severity) {
    switch (severity) {
      case _DaySeverity.warning:
        return GardenColors.yellowWarning.shade500;
      case _DaySeverity.critical:
        return GardenColors.redAlert.shade600;
      case _DaySeverity.ok:
      default:
        return GardenColors.tertiary.shade500;
    }
  }
}

enum _DaySeverity { ok, warning, critical }
