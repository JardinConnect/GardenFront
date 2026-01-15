import 'package:flutter/material.dart';
import 'package:garden_connect/analytics/filters/analytics_filter.dart';
import 'package:garden_connect/analytics/models/analytic_alert_status.dart';
import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

class AnalyticCard extends StatelessWidget {
  final AnalyticType type;
  final double value;
  final AnalyticAlertStatus alertStatus;

  const AnalyticCard({
    super.key,
    required this.type,
    required this.value,
    required this.alertStatus,
  });

  String get _unit {
    switch (type) {
      case AnalyticType.airTemperature:
      case AnalyticType.soilTemperature:
        return AnalyticsFilterEnum.temperature.unit;
      case AnalyticType.airHumidity:
      case AnalyticType.soilHumidity:
      case AnalyticType.deepSoilHumidity:
        return AnalyticsFilterEnum.humidity.unit;
      case AnalyticType.light:
        return AnalyticsFilterEnum.light.unit;
    }
  }

  double get _fillPercentage {
    switch (type) {
      case AnalyticType.airTemperature:
        return (100 * value / 55).clamp(0.0, 100.0);
      case AnalyticType.soilTemperature:
        return (100 * value / 40).clamp(0.0, 100.0);
      case AnalyticType.airHumidity:
      case AnalyticType.soilHumidity:
      case AnalyticType.deepSoilHumidity:
        return value;
      case AnalyticType.light:
        return 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GardenCard(
      hasBorder: true,
      hasShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: GardenSpace.gapSm,
            children: [
              Text(
                type.name,
                style: GardenTypography.bodyMd.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              if (alertStatus != AnalyticAlertStatus.ok)
                AlertIndicator(
                  alertType:
                      alertStatus == AnalyticAlertStatus.warning
                          ? MenuAlertType.warning
                          : MenuAlertType.error,
                ),
            ],
          ),
          Expanded(
            child: Row(
              spacing: GardenSpace.gapLg,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GardenIcon(
                  iconName: type.iconName,
                  fillPercentage: _fillPercentage,
                  color: type.color,
                  size: GardenIconSize.lg,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      value.toString(),
                      style: GardenTypography.headingXl.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _unit,
                      style: GardenTypography.headingMd.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
