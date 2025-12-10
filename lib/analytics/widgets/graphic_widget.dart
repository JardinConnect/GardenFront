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

  Widget _buildRadioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Données',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        RadioGroup<AnalyticsFilterEnum>(
          groupValue: _selectedFilter,
          onChanged: (value) {
            setState(() {
              _selectedFilter = value!;
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<AnalyticsFilterEnum>(
                title: Text('Humidité', style: GardenTypography.caption),
                value: AnalyticsFilterEnum.humidity,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
              RadioListTile<AnalyticsFilterEnum>(
                title: Text('Température', style: GardenTypography.caption),
                value: AnalyticsFilterEnum.temperature,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
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

  Widget _buildChart(
    double minValue,
    double maxValue,
    List<Analytic> sortedData,
    dynamic currentFilter,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                      padding: const EdgeInsets.only(top: 8.0),
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
            maxX: 6,
            minY: minValue - 5,
            maxY: maxValue + 5,
            lineBarsData: widget.analytics.buildLineBarsDataForTypes(
              currentFilter.analyticTypes,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentFilter = widget.analytics.analyticsFilters.firstWhere(
      (filter) => filter.filterType == _selectedFilter,
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

    final minValue = sortedData
        .map((e) => e.value)
        .reduce((a, b) => a < b ? a : b);
    final maxValue = sortedData
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);

    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [currentFilter.buildCaptions, _buildRadioSection()],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: _buildChart(minValue, maxValue, sortedData, currentFilter),
          ),
        ],
      ),
    );
  }
}
