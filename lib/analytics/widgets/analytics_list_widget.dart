import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:garden_connect/analytics/filters/analytics_filter.dart';
import 'package:garden_connect/analytics/models/analytics.dart';
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
  final Function(BuildContext context, String id) onPressed;

  const AnalyticsListWidget({
    super.key,
    required this.items,
    required this.onPressed,
  });

  String _formatValue(double? value, String unit, {int? decimals}) {
    if (value == null) {
      return '—';
    }
    if (decimals != null) {
      return '${value.toStringAsFixed(decimals)} $unit';
    }
    return '${value.toString()} $unit';
  }

  @override
  Widget build(BuildContext context) {
    final isMobile =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);

    return isMobile ? _buildMobileList(context) : _buildWebTable(context);
  }

  Widget _buildWebTable(BuildContext context) {
    final columns = [
      AnalyticType.light,
      AnalyticType.airTemperature,
      AnalyticType.soilTemperature,
      AnalyticType.airHumidity,
      AnalyticType.soilHumidity,
      AnalyticType.deepSoilHumidity,
    ];

    return Padding(
      padding: EdgeInsets.all(GardenSpace.paddingXs),
      child: Column(
        children: [
          GardenCard(
            child: Row(
              children: [
                Expanded(flex: 1, child: Text("Nom")),
                ...columns.map((type) {
                  return Expanded(
                    flex: 1,
                    child: Center(child: Text(type.name)),
                  );
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
                    value: _formatValue(
                      light?.value,
                      AnalyticsFilterEnum.light.unit,
                    ),
                    alertStatus:  AnalyticAlertStatus.ok),
                AnalyticListItem(
                    value: _formatValue(
                      airTemperature?.value,
                      AnalyticsFilterEnum.temperature.unit,
                      decimals: 1,
                    ),
                    alertStatus:  AnalyticAlertStatus.ok),
                AnalyticListItem(
                    value: _formatValue(
                      soilTemperature?.value,
                      AnalyticsFilterEnum.temperature.unit,
                      decimals: 1,
                    ),
                    alertStatus: AnalyticAlertStatus.ok),
                AnalyticListItem(
                    value: _formatValue(
                      airHumidity?.value,
                      AnalyticsFilterEnum.humidity.unit,
                    ),
                    alertStatus: AnalyticAlertStatus.ok),
                AnalyticListItem(
                    value: _formatValue(
                      soilHumidity?.value,
                      AnalyticsFilterEnum.humidity.unit,
                    ),
                    alertStatus: AnalyticAlertStatus.ok),
                AnalyticListItem(
                    value: _formatValue(
                      deepSoilHumidity?.value,
                      AnalyticsFilterEnum.humidity.unit,
                    ),
                    alertStatus: AnalyticAlertStatus.ok)
              ];

              return GestureDetector(
                onTap: () => onPressed(context, item.id),
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

  Widget _buildMobileList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(GardenSpace.paddingXs),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder:
            (context, index) => SizedBox(height: GardenSpace.gapSm),
        itemBuilder: (context, index) {
          final item = items[index];
          final light =
              item.analytics.getLastAnalyticByType(AnalyticType.light);
          final airTemperature = item.analytics.getLastAnalyticByType(
            AnalyticType.airTemperature,
          );
          final soilTemperature = item.analytics.getLastAnalyticByType(
            AnalyticType.soilTemperature,
          );
          final airHumidity = item.analytics.getLastAnalyticByType(
            AnalyticType.airHumidity,
          );
          final soilHumidity = item.analytics.getLastAnalyticByType(
            AnalyticType.soilHumidity,
          );
          final deepSoilHumidity = item.analytics.getLastAnalyticByType(
            AnalyticType.deepSoilHumidity,
          );

          final metrics = [
            _MobileMetric(
              type: AnalyticType.light,
              value: _formatValue(
                light?.value,
                AnalyticsFilterEnum.light.unit,
              ),
            ),
            _MobileMetric(
              type: AnalyticType.airTemperature,
              value: _formatValue(
                airTemperature?.value,
                AnalyticsFilterEnum.temperature.unit,
                decimals: 1,
              ),
            ),
            _MobileMetric(
              type: AnalyticType.soilTemperature,
              value: _formatValue(
                soilTemperature?.value,
                AnalyticsFilterEnum.temperature.unit,
                decimals: 1,
              ),
            ),
            _MobileMetric(
              type: AnalyticType.airHumidity,
              value: _formatValue(
                airHumidity?.value,
                AnalyticsFilterEnum.humidity.unit,
              ),
            ),
            _MobileMetric(
              type: AnalyticType.soilHumidity,
              value: _formatValue(
                soilHumidity?.value,
                AnalyticsFilterEnum.humidity.unit,
              ),
            ),
            _MobileMetric(
              type: AnalyticType.deepSoilHumidity,
              value: _formatValue(
                deepSoilHumidity?.value,
                AnalyticsFilterEnum.humidity.unit,
              ),
            ),
          ];

          return GestureDetector(
            onTap: () => onPressed(context, item.id),
            child: GardenCard(
              hasBorder: true,
              child: Padding(
                padding: EdgeInsets.all(GardenSpace.paddingSm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: GardenTypography.bodyLg.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: GardenSpace.gapSm),
                    Wrap(
                      spacing: GardenSpace.gapMd,
                      runSpacing: GardenSpace.gapSm,
                      children:
                          metrics
                              .map(
                                (metric) => SizedBox(
                                  width: 120,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GardenIcon(
                                        iconName: metric.type.iconName,
                                        fillPercentage: 100,
                                        color: metric.type.iconColor,
                                        size: GardenIconSize.sm,
                                      ),
                                      SizedBox(width: GardenSpace.gapSm),
                                      Expanded(
                                        child: Text(
                                          metric.value,
                                          style: GardenTypography.caption,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MobileMetric {
  final AnalyticType type;
  final String value;

  const _MobileMetric({
    required this.type,
    required this.value,
  });
}
