import 'package:flutter/material.dart';
import 'package:garden_connect/analytics/filters/analytics_filter.dart';
import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:garden_connect/cells/models/cell.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

class CellAnalyticListItem {
  final String value;
  final AnalyticAlertStatus alertStatus;

  CellAnalyticListItem({
    required this.value,
    required this.alertStatus
  });
}

class CellsListWidget extends StatelessWidget {
  final List<Cell> cells;
  final Function(BuildContext context, String id) onPressed;

  const CellsListWidget({
    super.key,
    required this.cells,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var columns = [
      AnalyticType.light.name,
      AnalyticType.airTemperature.name,
      AnalyticType.soilTemperature.name,
      AnalyticType.airHumidity.name,
      AnalyticType.soilHumidity.name,
      AnalyticType.deepSoilHumidity.name,
    ];

    return Padding(
      padding: EdgeInsets.all(GardenSpace.paddingXs),
      child: Column(
        children: [
          GardenCard(
            child: Row(
              children: [
                Expanded(flex: 1, child: Text("Nom")),
                ...columns.map((column) {
                  return Expanded(flex: 1, child: Center(child: Text(column)));
                }),
              ],
            ),
          ),

          SizedBox(height: GardenSpace.gapLg),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cells.length,

            separatorBuilder:
                (context, index) => SizedBox(height: GardenSpace.gapSm),

            itemBuilder: (context, index) {
              var cell = cells[index];
              var light = cell.analytics.getLastAnalyticByType(
                  AnalyticType.light);
              var airTemperature = cell.analytics.getLastAnalyticByType(
                  AnalyticType.airTemperature);
              var soilTemperature = cell.analytics.getLastAnalyticByType(
                  AnalyticType.soilTemperature);
              var airHumidity = cell.analytics.getLastAnalyticByType(
                  AnalyticType.airHumidity);
              var soilHumidity = cell.analytics.getLastAnalyticByType(
                  AnalyticType.soilHumidity);
              var deepSoilHumidity = cell.analytics.getLastAnalyticByType(
                  AnalyticType.deepSoilHumidity);

              var values = [
                CellAnalyticListItem(
                    value: "${light?.value} ${AnalyticsFilterEnum.light.unit}",
                    alertStatus:  AnalyticAlertStatus.ok),
                CellAnalyticListItem(value: "${airTemperature?.value
                    .toStringAsFixed(1)} ${AnalyticsFilterEnum.temperature
                    .unit}", alertStatus: AnalyticAlertStatus.ok),
                CellAnalyticListItem(
                    value: "${soilTemperature?.value
                        .toStringAsFixed(1)} ${AnalyticsFilterEnum.temperature
                        .unit}",
                    alertStatus:  AnalyticAlertStatus.ok),
                CellAnalyticListItem(
                    value: "${airHumidity?.value
                        .toString()} ${AnalyticsFilterEnum.humidity.unit}",
                    alertStatus:  AnalyticAlertStatus.ok),
                CellAnalyticListItem(
                    value: "${soilHumidity?.value
                        .toString()} ${AnalyticsFilterEnum.humidity.unit}",
                    alertStatus:  AnalyticAlertStatus.ok),
                CellAnalyticListItem(
                    value: "${deepSoilHumidity?.value
                        .toString()} ${AnalyticsFilterEnum.humidity.unit}",
                    alertStatus:  AnalyticAlertStatus.ok)
              ];

              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => onPressed(context, cell.id),
                  child: GardenCard(
                    hasBorder: true,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(cell.name, style: GardenTypography.bodyLg),
                        ),
                        ...values.map((CellAnalyticListItem item) {
                          return Expanded(
                            flex: 1,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: GardenSpace.gapSm,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: item.alertStatus.color
                                    ),
                                  ),
                                  Text(item.value, style: GardenTypography.bodyLg),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
