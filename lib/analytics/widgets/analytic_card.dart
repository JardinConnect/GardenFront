import 'package:flutter/material.dart';
import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

class AnalyticCardWidget extends StatelessWidget {
  /// The max value of air temperature. If it's reached, icon will be full filled (same value as in GardenUI)
  static const int _airTemperatureMaxValue = 55;
  /// The max value of soil temperature. If it's reached, icon will be full filled (same value as in GardenUI)
  static const int _soilTemperatureMaxValue = 45;

  final AnalyticType type;
  final double value;
  final AnalyticAlertStatus alertStatus;

  const AnalyticCardWidget({
    super.key,
    required this.type,
    required this.value,
    required this.alertStatus,
  });

  double get _fillPercentage {
    switch (type) {
      case AnalyticType.airTemperature:
        return (100 * value / _airTemperatureMaxValue).clamp(0.0, 100.0);
      case AnalyticType.soilTemperature:
        return (100 * value / _soilTemperatureMaxValue).clamp(0.0, 100.0);
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
                  color: type.iconColor,
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
                      type.unit,
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
