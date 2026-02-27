import 'package:flutter/material.dart';
import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:garden_connect/cells/models/cell.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

class CellsCardsWidget extends StatelessWidget {
  final List<Cell> cells;
  final Function(BuildContext context, String id) onPressed;
  final AnalyticType? filter;

  const CellsCardsWidget({
    super.key,
    required this.cells,
    required this.filter,
    required this.onPressed,
  });

  AnalyticsSummaryFilter? get _filter {
    switch (filter) {
      case AnalyticType.airTemperature:
        return AnalyticsSummaryFilter.airTemperature;
      case AnalyticType.soilTemperature:
        return AnalyticsSummaryFilter.soilTemperature;
      case AnalyticType.airHumidity:
        return AnalyticsSummaryFilter.airHumidity;
      case AnalyticType.soilHumidity:
        return AnalyticsSummaryFilter.soilHumidity;
      case AnalyticType.deepSoilHumidity:
        return AnalyticsSummaryFilter.deepSoilHumidity;
      case AnalyticType.light:
        return AnalyticsSummaryFilter.light;
      default:
        return null;
    }
  }

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
        final analytics = cell.analytics;

        return FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: 350,
            height: 220,
            child: AnalyticsSummaryCard(
              name: cell.name,
              batteryPercentage: cell.analytics.getLastAnalyticByType(AnalyticType.battery)?.value.toInt() ?? 0,
              filter: _filter,
              onPressed: () => onPressed(context, cell.id),
              //TODO : Enelver les "?? 0" une fois que sur GardenUI, les valeurs pourront être nulles
              light:
                  analytics
                      .getLastAnalyticByType(AnalyticType.light)
                      ?.value
                      .toInt() ??
                  0,
              rain:
                  analytics
                      .getLastAnalyticByType(AnalyticType.airHumidity)
                      ?.value
                      .toInt() ??
                  0,
              humiditySurface:
                  analytics
                      .getLastAnalyticByType(AnalyticType.soilHumidity)
                      ?.value
                      .toInt() ??
                  0,
              humidityDepth:
                  analytics
                      .getLastAnalyticByType(AnalyticType.deepSoilHumidity)
                      ?.value
                      .toInt() ??
                  0,
              temperatureSurface:
                  analytics
                      .getLastAnalyticByType(AnalyticType.airTemperature)
                      ?.value ??
                  0.0,
              temperatureDepth:
                  analytics
                      .getLastAnalyticByType(AnalyticType.soilTemperature)
                      ?.value ??
                  0.0,
            ),
          ),
        );
      },
    );
  }
}
