import 'package:flutter/material.dart';
import 'package:garden_connect/analytics/filters/analytics_filter.dart';
import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:garden_connect/cells/models/cell.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

class CellAnalyticListItem {
  final String value;
  final AnalyticAlertStatus alertStatus;

  CellAnalyticListItem({required this.value, required this.alertStatus});
}

class MobileCellsListWidget extends StatelessWidget {
  final List<Cell> cells;
  final Function(BuildContext context, String id) onPressed;

  const MobileCellsListWidget({
    super.key,
    required this.cells,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var columns = [
      AnalyticType.airTemperature,
      AnalyticType.soilTemperature,
      AnalyticType.deepSoilHumidity,
      AnalyticType.soilHumidity,
      AnalyticType.airHumidity,
    ];

    return Padding(
      padding: EdgeInsets.all(GardenSpace.paddingXs),
      child: Column(
        children: [
          GardenCard(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text("Nom de la cellule", style: GardenTypography.caption),
                ),
                ...columns.map((column) {
                  return Expanded(
                    flex: 1,
                    child: Center(
                      child: GardenIcon(
                        iconName: column.iconName,
                        size: GardenIconSize.sm,
                        fillPercentage: 100,
                        color: column.iconColor,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          SizedBox(height: GardenSpace.gapMd),

          Expanded(
            child: ListView.separated(
              itemCount: cells.length,
              separatorBuilder:
                  (context, index) => SizedBox(height: GardenSpace.gapSm),
              itemBuilder: (context, index) {
                var cell = cells[index];
                var defaultValue = "N/A";

                var airTemperature = cell.analytics.getLastAnalyticByType(
                  AnalyticType.airTemperature,
                );
                var soilTemperature = cell.analytics.getLastAnalyticByType(
                  AnalyticType.soilTemperature,
                );
                var airHumidity = cell.analytics.getLastAnalyticByType(
                  AnalyticType.airHumidity,
                );
                var soilHumidity = cell.analytics.getLastAnalyticByType(
                  AnalyticType.soilHumidity,
                );
                var deepSoilHumidity = cell.analytics.getLastAnalyticByType(
                  AnalyticType.deepSoilHumidity,
                );

                var values = [
                  CellAnalyticListItem(
                    value:
                        "${airTemperature != null ? airTemperature.value.toStringAsFixed(1) : defaultValue} ${AnalyticsFilterEnum.temperature.unit}",
                    alertStatus: AnalyticAlertStatus.ok,
                  ),
                  CellAnalyticListItem(
                    value:
                        "${soilTemperature != null ? soilTemperature.value.toStringAsFixed(1) : defaultValue} ${AnalyticsFilterEnum.temperature.unit}",
                    alertStatus: AnalyticAlertStatus.ok,
                  ),
                  CellAnalyticListItem(
                    value:
                    "${deepSoilHumidity != null ? deepSoilHumidity.value.toString() : defaultValue} ${AnalyticsFilterEnum.humidity.unit}",
                    alertStatus: AnalyticAlertStatus.ok,
                  ),
                  CellAnalyticListItem(
                    value:
                        "${soilHumidity != null ? soilHumidity.value.toString() : defaultValue} ${AnalyticsFilterEnum.humidity.unit}",
                    alertStatus: AnalyticAlertStatus.ok,
                  ),
                  CellAnalyticListItem(
                    value:
                    "${airHumidity != null ? airHumidity.value.toString() : defaultValue} ${AnalyticsFilterEnum.humidity.unit}",
                    alertStatus: AnalyticAlertStatus.ok,
                  ),
                ];

                return GardenCard(
                  hasBorder: true,
                  onTap: () => onPressed(context, cell.id),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(cell.name, style: GardenTypography.caption, overflow: TextOverflow.ellipsis,),
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
                                Text(item.value, style: GardenTypography.caption),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
