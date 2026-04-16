import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:intl/intl.dart';

import '../filters/analytics_filter.dart';
import '../models/analytics.dart';

class GraphicWidget extends StatefulWidget {
  final Analytics analytics;

  const GraphicWidget({super.key, required this.analytics});

  @override
  State<GraphicWidget> createState() => _GraphicWidgetState();
}

class _GraphicWidgetState extends State<GraphicWidget> {
  AnalyticsFilterEnum _selectedFilter = AnalyticsFilterEnum.temperature;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  List<AnalyticsFilterEnum> _availableFilters(Analytics analytics) {
    return analytics.analyticsFilters.map((f) => f.filterType).toList();
  }

  DateTime _clampDate(DateTime value, DateTime min, DateTime max) {
    if (value.isBefore(min)) return min;
    if (value.isAfter(max)) return max;
    return value;
  }

  Analytics _filterAnalyticsByRangeInclusive(
    Analytics analytics,
    DateTime start,
    DateTime end,
  ) {
    bool inRange(DateTime date) {
      return !date.isBefore(start) && !date.isAfter(end);
    }

    return Analytics(
      airTemperature:
          analytics.airTemperature
              ?.where((a) => inRange(a.occurredAt))
              .toList(),
      soilTemperature:
          analytics.soilTemperature
              ?.where((a) => inRange(a.occurredAt))
              .toList(),
      airHumidity:
          analytics.airHumidity?.where((a) => inRange(a.occurredAt)).toList(),
      soilHumidity:
          analytics.soilHumidity?.where((a) => inRange(a.occurredAt)).toList(),
      deepSoilHumidity:
          analytics.deepSoilHumidity
              ?.where((a) => inRange(a.occurredAt))
              .toList(),
      light: analytics.light?.where((a) => inRange(a.occurredAt)).toList(),
      battery: analytics.battery?.where((a) => inRange(a.occurredAt)).toList(),
    );
  }

  Widget _buildRadioSection(
    List<AnalyticsFilterEnum> availableFilters,
    AnalyticsFilterEnum selectedFilter,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Données',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: GardenSpace.gapSm),
        RadioGroup<AnalyticsFilterEnum>(
          groupValue: selectedFilter,
          onChanged: (value) {
            setState(() {
              _selectedFilter = value!;
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (availableFilters.contains(AnalyticsFilterEnum.humidity))
                RadioListTile<AnalyticsFilterEnum>(
                  title: Text('Humidité', style: GardenTypography.caption),
                  value: AnalyticsFilterEnum.humidity,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              if (availableFilters.contains(AnalyticsFilterEnum.temperature))
                RadioListTile<AnalyticsFilterEnum>(
                  title: Text('Température', style: GardenTypography.caption),
                  value: AnalyticsFilterEnum.temperature,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              if (availableFilters.contains(AnalyticsFilterEnum.light))
                RadioListTile<AnalyticsFilterEnum>(
                  title: Text('Luminosité', style: GardenTypography.caption),
                  value: AnalyticsFilterEnum.light,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangeSection(
    DateTime minDate,
    DateTime maxDate,
    DateTime selectedStart,
    DateTime selectedEnd,
  ) {
    final displayFormat = DateFormat('dd/MM/yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Plage de temps',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: GardenSpace.gapSm),
        _buildDatePickerRow(
          label: 'Début',
          date: selectedStart,
          minDate: minDate,
          maxDate: selectedEnd,
          format: displayFormat,
          onPicked: (picked) {
            setState(() {
              _rangeStart = DateTime(picked.year, picked.month, picked.day);
              if (_rangeEnd != null && _rangeEnd!.isBefore(_rangeStart!)) {
                _rangeEnd = DateTime(
                  picked.year,
                  picked.month,
                  picked.day,
                  23,
                  59,
                  59,
                  999,
                );
              }
            });
          },
        ),
        SizedBox(height: GardenSpace.gapSm),
        _buildDatePickerRow(
          label: 'Fin',
          date: selectedEnd,
          minDate: selectedStart,
          maxDate: maxDate,
          format: displayFormat,
          onPicked: (picked) {
            setState(() {
              _rangeEnd = DateTime(
                picked.year,
                picked.month,
                picked.day,
                23,
                59,
                59,
                999,
              );
              if (_rangeStart != null && _rangeEnd!.isBefore(_rangeStart!)) {
                _rangeStart = DateTime(picked.year, picked.month, picked.day);
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildDatePickerRow({
    required String label,
    required DateTime date,
    required DateTime minDate,
    required DateTime maxDate,
    required DateFormat format,
    required ValueChanged<DateTime> onPicked,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GardenTypography.caption.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        OutlinedButton(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: minDate,
              lastDate: maxDate,
              builder: (context, child) {
                final theme = Theme.of(context);
                return Theme(
                  data: theme.copyWith(
                    colorScheme: theme.colorScheme.copyWith(
                      onSurface: Colors.black,
                      onSurfaceVariant: Colors.grey,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              onPicked(picked);
            }
          },
          child: Text(format.format(date), style: GardenTypography.caption),
        ),
      ],
    );
  }

  DateTime _asDateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  List<int> _buildDayStartIndexes(List<Analytic> data) {
    if (data.isEmpty) {
      return const [];
    }

    final indexes = <int>[0];
    var previousDay = _asDateOnly(data.first.occurredAt);

    for (var i = 1; i < data.length; i++) {
      final currentDay = _asDateOnly(data[i].occurredAt);
      if (currentDay != previousDay) {
        indexes.add(i);
        previousDay = currentDay;
      }
    }

    final lastIndex = data.length - 1;
    if (indexes.last != lastIndex) {
      indexes.add(lastIndex);
    }

    return indexes;
  }

  Set<int> _computeVisibleXAxisIndexes(List<Analytic> data, double chartWidth) {
    if (data.isEmpty) {
      return const <int>{};
    }

    final dayIndexes = _buildDayStartIndexes(data);
    if (dayIndexes.length <= 2) {
      return dayIndexes.toSet();
    }

    const minLabelSpacing = 56.0;
    final safeWidth =
        chartWidth.isFinite && chartWidth > 0 ? chartWidth : 300.0;
    final maxLabels =
        (safeWidth / minLabelSpacing)
            .floor()
            .clamp(2, dayIndexes.length)
            .toInt();
    final step = (dayIndexes.length / maxLabels).ceil();

    final visibleIndexes = <int>{};
    for (var i = 0; i < dayIndexes.length; i += step) {
      visibleIndexes.add(dayIndexes[i]);
    }
    visibleIndexes
      ..add(dayIndexes.first)
      ..add(dayIndexes.last);

    return visibleIndexes;
  }

  List<TouchedSpotIndicatorData?> _safeTouchedSpotIndicators(
    LineChartBarData barData,
    List<int> spotIndexes,
  ) {
    final indicatorColor =
        barData.gradient?.colors.first ??
        barData.color ??
        Theme.of(context).colorScheme.primary;

    return spotIndexes.map((index) {
      if (index < 0 || index >= barData.spots.length) {
        return null;
      }

      final dotData = FlDotData(
        getDotPainter:
            (spot, percent, bar, dotIndex) => FlDotCirclePainter(
              radius: 4 * 1.8,
              color: indicatorColor,
              strokeColor: Colors.white,
            ),
      );
      return TouchedSpotIndicatorData(
        FlLine(color: indicatorColor, strokeWidth: 4),
        dotData,
      );
    }).toList();
  }

  Widget _buildChart(
    double minValue,
    double maxValue,
    List<Analytic> sortedData,
    Analytics filteredAnalytics,
    dynamic currentFilter,
  ) {
    final maxX = sortedData.isNotEmpty ? (sortedData.length - 1).toDouble() : 0;

    return Padding(
      padding: EdgeInsets.all(GardenSpace.paddingMd),
      child: SizedBox(
        height: 300,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final visibleXLabelIndexes = _computeVisibleXAxisIndexes(
              sortedData,
              constraints.maxWidth,
            );
            final dateFormat = DateFormat('dd/MM');

            return LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  horizontalInterval: 5,
                  verticalInterval: 1,
                  getDrawingHorizontalLine:
                      (value) =>
                          FlLine(color: Colors.grey.shade300, strokeWidth: 1),
                  getDrawingVerticalLine:
                      (value) =>
                          FlLine(color: Colors.grey.shade300, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      interval: 5,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (value != index.toDouble() ||
                            index < 0 ||
                            index >= sortedData.length ||
                            !visibleXLabelIndexes.contains(index)) {
                          return const SizedBox.shrink();
                        }

                        final date = sortedData[index].occurredAt;
                        return SideTitleWidget(
                          meta: meta,
                          space: GardenSpace.paddingSm,
                          child: Text(
                            dateFormat.format(date),
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                minX: 0,
                maxX: maxX.toDouble(),
                minY: minValue - 5,
                maxY: maxValue + 5,
                lineTouchData: LineTouchData(
                  getTouchedSpotIndicator: _safeTouchedSpotIndicators,
                ),
                lineBarsData: filteredAnalytics.buildLineBarsDataForTypes(
                  currentFilter.analyticTypes,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);

    final availableFilters = _availableFilters(widget.analytics);
    if (availableFilters.isEmpty) {
      return const Center(child: Text('Aucune donnée disponible'));
    }

    final effectiveSelected =
        availableFilters.contains(_selectedFilter)
            ? _selectedFilter
            : availableFilters.first;

    final currentFilter = widget.analytics.analyticsFilters.firstWhere(
      (filter) => filter.filterType == effectiveSelected,
    );

    final analyticsData =
        currentFilter.analyticTypes
            .expand((type) => widget.analytics.getAnalyticsByType(type))
            .toList();

    if (analyticsData.isEmpty) {
      return const Center(child: Text('Aucune donnée disponible'));
    }

    final sortedData = List<Analytic>.from(analyticsData)
      ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));

    final minDate = sortedData.first.occurredAt;
    final maxDate = sortedData.last.occurredAt;

    final now = DateTime.now();
    final defaultStart = now.subtract(const Duration(days: 7));
    final defaultEnd = now;

    final selectedStart = _clampDate(
      _rangeStart ?? defaultStart,
      minDate,
      maxDate,
    );
    final selectedEnd = _clampDate(_rangeEnd ?? defaultEnd, minDate, maxDate);

    final rangeStart = DateTime(
      selectedStart.year,
      selectedStart.month,
      selectedStart.day,
    );
    var rangeEnd = DateTime(
      selectedEnd.year,
      selectedEnd.month,
      selectedEnd.day,
      23,
      59,
      59,
      999,
    );
    if (rangeEnd.isBefore(rangeStart)) {
      rangeEnd = DateTime(
        rangeStart.year,
        rangeStart.month,
        rangeStart.day,
        23,
        59,
        59,
        999,
      );
    }

    final filteredAnalytics = _filterAnalyticsByRangeInclusive(
      widget.analytics,
      rangeStart,
      rangeEnd,
    );
    final filteredData =
        currentFilter.analyticTypes
            .expand((type) => filteredAnalytics.getAnalyticsByType(type))
            .toList();

    Widget chartContent;
    if (filteredData.isEmpty) {
      chartContent = const Center(
        child: Text('Aucune donnée disponible pour cette période'),
      );
    } else {
      final filteredSortedData = List<Analytic>.from(filteredData)
        ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));

      final minValue = filteredSortedData
          .map((e) => e.value)
          .reduce((a, b) => a < b ? a : b);
      final maxValue = filteredSortedData
          .map((e) => e.value)
          .reduce((a, b) => a > b ? a : b);

      chartContent = _buildChart(
        minValue,
        maxValue,
        filteredSortedData,
        filteredAnalytics,
        currentFilter,
      );
    }

    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile)
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    currentFilter.buildCaptions,
                    _buildRadioSection(availableFilters, effectiveSelected),
                    SizedBox(height: GardenSpace.gapMd),
                    _buildDateRangeSection(
                      minDate,
                      maxDate,
                      rangeStart,
                      rangeEnd,
                    ),
                  ],
                ),
              ),
            ),
          Expanded(flex: 3, child: chartContent),
        ],
      ),
    );
  }
}
