import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
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
        child: LineChart(
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
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index < 0 || index >= sortedData.length) {
                      return const SizedBox.shrink();
                    }

                    final date = sortedData[index].occurredAt;
                    return Padding(
                      padding: EdgeInsets.only(top: GardenSpace.paddingSm),
                      child: Text(
                        DateFormat('dd/MM').format(date),
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey.shade300),
            ),
            minX: 0,
            maxX: maxX.toDouble(),
            minY: minValue - 5,
            maxY: maxValue + 5,
            lineBarsData: filteredAnalytics.buildLineBarsDataForTypes(
              currentFilter.analyticTypes,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Platform.isIOS || Platform.isAndroid;

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
