import 'package:flutter/material.dart';
import 'package:garden_connect/analytics/filters/analytics_filter.dart';
import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:garden_connect/cells/models/cell.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

import '../../common/models/base_item.dart';

class AnalyticListItem {
  final String value;
  final AnalyticAlertStatus alertStatus;

  AnalyticListItem({
    required this.value,
    required this.alertStatus
  });
}

class AnalyticsListWidget extends StatelessWidget {
  final List<BaseItem> items;
  final Function(BuildContext context, int id) onPressed;

  const AnalyticsListWidget({
    super.key,
    required this.items,
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
            itemCount: items.length,

            separatorBuilder:
                (context, index) => SizedBox(height: GardenSpace.gapSm),

            itemBuilder: (context, index) {
              var item = items[index];
              var light = item.analytics.getLastAnalyticByType(
                  AnalyticType.light);
              var airTemperature = item.analytics.getLastAnalyticByType(
                  AnalyticType.airTemperature);
              var soilTemperature = item.analytics.getLastAnalyticByType(
                  AnalyticType.soilTemperature);
              var airHumidity = item.analytics.getLastAnalyticByType(
                  AnalyticType.airHumidity);
              var soilHumidity = item.analytics.getLastAnalyticByType(
                  AnalyticType.soilHumidity);
              var deepSoilHumidity = item.analytics.getLastAnalyticByType(
                  AnalyticType.deepSoilHumidity);

              var values = [
                AnalyticListItem(
                    value: "${light?.value} ${AnalyticsFilterEnum.light.unit}",
                    alertStatus: light!.alertStatus),
                AnalyticListItem(value: "${airTemperature?.value
                    .toStringAsFixed(1)} ${AnalyticsFilterEnum.temperature
                    .unit}", alertStatus: airTemperature!.alertStatus),
                AnalyticListItem(
                    value: "${soilTemperature?.value
                        .toStringAsFixed(1)} ${AnalyticsFilterEnum.temperature
                        .unit}",
                    alertStatus: soilTemperature!.alertStatus),
                AnalyticListItem(
                    value: "${airHumidity?.value
                        .toString()} ${AnalyticsFilterEnum.humidity.unit}",
                    alertStatus: airHumidity!.alertStatus),
                AnalyticListItem(
                    value: "${soilHumidity?.value
                        .toString()} ${AnalyticsFilterEnum.humidity.unit}",
                    alertStatus: soilHumidity!.alertStatus),
                AnalyticListItem(
                    value: "${deepSoilHumidity?.value
                        .toString()} ${AnalyticsFilterEnum.humidity.unit}",
                    alertStatus: deepSoilHumidity!.alertStatus)
              ];

              return GestureDetector(
                onTap: onPressed(context, item.id),
                child: GardenCard(
                  hasBorder: true,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(item.name, style: GardenTypography.bodyLg),
                      ),
                      ...values.map((AnalyticListItem item) {
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
              );
            },
          ),
        ],
      ),
    );
  }
}
