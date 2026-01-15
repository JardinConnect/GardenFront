import 'package:flutter/material.dart';
import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:garden_connect/cells/models/cell.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

class CellsCardsWidget extends StatelessWidget {
  final List<Cell> cells;
  final AnalyticType? filter;

  const CellsCardsWidget({
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
        childAspectRatio: 350 / 220,
        crossAxisSpacing: GardenSpace.gapLg,
        mainAxisSpacing: GardenSpace.gapLg,
      ),
      itemCount: cells.length,
      itemBuilder: (context, index) {
        final cell = cells[index];

        final card = () {
          switch (filter) {
            case AnalyticType.airTemperature:
              return AnalyticsSummaryCard(
                name: cell.name,
                batteryPercentage: cell.battery,
                onPressed: () => {},
                light: 0,
                rain: 0,
                humiditySurface: 0,
                humidityDepth: 0,
                temperatureSurface: cell.analytics.getLastAnalyticByType(AnalyticType.airTemperature)!.value,
                temperatureDepth: 0,
              );
            case AnalyticType.soilTemperature:
              return AnalyticsSummaryCard(
                name: cell.name,
                batteryPercentage: cell.battery,
                onPressed: () => {},
                light: 0,
                rain: 0,
                humiditySurface: 0,
                humidityDepth: 0,
                temperatureSurface: 0,
                temperatureDepth: cell.analytics.getLastAnalyticByType(AnalyticType.soilTemperature)!.value,
              );
            case AnalyticType.airHumidity:
              return AnalyticsSummaryCard(
                name: cell.name,
                batteryPercentage: cell.battery,
                onPressed: () => {},
                light: 0,
                rain: cell.analytics.getLastAnalyticByType(AnalyticType.airHumidity)!.value.toInt(),
                humiditySurface: 0,
                humidityDepth: 0,
                temperatureSurface: 0,
                temperatureDepth: 0,
              );
            case AnalyticType.soilHumidity:
              return AnalyticsSummaryCard(
                name: cell.name,
                batteryPercentage: cell.battery,
                onPressed: () => {},
                light: 0,
                rain: 0,
                humiditySurface: cell.analytics.getLastAnalyticByType(AnalyticType.soilHumidity)!.value.toInt(),
                humidityDepth: 0,
                temperatureSurface: 0,
                temperatureDepth: 0,
              );
            case AnalyticType.light:
              return AnalyticsSummaryCard(
                name: cell.name,
                batteryPercentage: cell.battery,
                onPressed: () => {},
                light: cell.analytics.getLastAnalyticByType(AnalyticType.light)!.value.toInt(),
                rain: 0,
                humiditySurface: 0,
                humidityDepth: 0,
                temperatureSurface: 0,
                temperatureDepth: 0,
              );
            case AnalyticType.deepSoilHumidity:
              return AnalyticsSummaryCard(
                name: cell.name,
                batteryPercentage: cell.battery,
                onPressed: () => {},
                light: 0,
                rain: 0,
                humiditySurface: 0,
                humidityDepth: cell.analytics.getLastAnalyticByType(AnalyticType.deepSoilHumidity)!.value.toInt(),
                temperatureSurface: 0,
                temperatureDepth: 0,
              );
            case null:
              return AnalyticsSummaryCard(
                name: cell.name,
                batteryPercentage: cell.battery,
                onPressed: () => {},
                light: cell.analytics.getLastAnalyticByType(AnalyticType.light)!.value.toInt(),
                rain: cell.analytics.getLastAnalyticByType(AnalyticType.airHumidity)!.value.toInt(),
                humiditySurface: cell.analytics.getLastAnalyticByType(AnalyticType.soilHumidity)!.value.toInt(),
                humidityDepth: cell.analytics.getLastAnalyticByType(AnalyticType.deepSoilHumidity)!.value.toInt(),
                temperatureSurface: cell.analytics.getLastAnalyticByType(AnalyticType.airTemperature)!.value,
                temperatureDepth: cell.analytics.getLastAnalyticByType(AnalyticType.soilTemperature)!.value,
              );
          }
        }();

        return FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: 350,
            height: 220,
            child: card,
          ),
        );
      },
    );
  }
}
