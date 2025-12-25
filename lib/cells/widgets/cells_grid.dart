import 'package:flutter/material.dart';
import 'package:garden_connect/cells/models/analytic_metric.dart';
import 'package:garden_connect/cells/models/cell.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

class CellsGrid extends StatelessWidget {
  final List<Cell> cells;
  final AnalyticMetric? filter;

  const CellsGrid({
    super.key,
    required this.cells,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 350,
        mainAxisExtent: 220,
        crossAxisSpacing: GardenSpace.gapLg,
        mainAxisSpacing: GardenSpace.gapLg,
      ),
      itemCount: cells.length,
      itemBuilder: (context, index) {
        final cell = cells[index];

        switch (filter) {
          case AnalyticMetric.AIR_TEMPERATURE:
            return AnalyticsSummaryCard(
              name: cell.name,
              batteryPercentage: cell.battery,
              onPressed: () => {},
              light: 0,
              rain: 0,
              humiditySurface: 0,
              humidityDepth: 0,
              temperatureSurface: cell.analytics.airTemperature.value,
              temperatureDepth: 0,
            );
          case AnalyticMetric.SOIL_TEMPERATURE:
            return AnalyticsSummaryCard(
              name: cell.name,
              batteryPercentage: cell.battery,
              onPressed: () => {},
              light: 0,
              rain: 0,
              humiditySurface: 0,
              humidityDepth: 0,
              temperatureSurface: 0,
              temperatureDepth: cell.analytics.soilTemperature.value,
            );
          case AnalyticMetric.AIR_HUMIDITY:
            return AnalyticsSummaryCard(
              name: cell.name,
              batteryPercentage: cell.battery,
              onPressed: () => {},
              light: 0,
              rain: 0,
              humiditySurface: cell.analytics.airHumidity.value.toInt(),
              humidityDepth: 0,
              temperatureSurface: 0,
              temperatureDepth: 0,
            );
          case AnalyticMetric.SOIL_HUMIDITY:
            return AnalyticsSummaryCard(
              name: cell.name,
              batteryPercentage: cell.battery,
              onPressed: () => {},
              light: 0,
              rain: 0,
              humiditySurface: 0,
              humidityDepth: cell.analytics.soilHumidity.value.toInt(),
              temperatureSurface: 0,
              temperatureDepth: 0,
            );
          case AnalyticMetric.LUMINOSITY:
            return AnalyticsSummaryCard(
              name: cell.name,
              batteryPercentage: cell.battery,
              onPressed: () => {},
              light: cell.analytics.light.value.toInt(),
              rain: 0,
              humiditySurface: 0,
              humidityDepth: 0,
              temperatureSurface: 0,
              temperatureDepth: 0,
            );
          case AnalyticMetric.RAIN:
            return AnalyticsSummaryCard(
              name: cell.name,
              batteryPercentage: cell.battery,
              onPressed: () => {},
              light: 0,
              rain: cell.analytics.airHumidity.value.toInt(),
              humiditySurface: 0,
              humidityDepth: 0,
              temperatureSurface: 0,
              temperatureDepth: 0,
            );
          case null:
            return AnalyticsSummaryCard(
              name: cell.name,
              batteryPercentage: cell.battery,
              onPressed: () => {},
              light: cell.analytics.light.value.toInt(),
              rain: cell.analytics.airHumidity.value.toInt(),
              humiditySurface: cell.analytics.airHumidity.value.toInt(),
              humidityDepth: cell.analytics.soilHumidity.value.toInt(),
              temperatureSurface: cell.analytics.airTemperature.value,
              temperatureDepth: cell.analytics.soilTemperature.value,
            );
        }
      },
    );
  }
}
