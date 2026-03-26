import 'dart:io';

import 'package:flutter/material.dart';
import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

class AnalyticCardWidget extends StatelessWidget {
  /// The max value of air temperature. If it's reached, icon will be full filled (same value as in GardenUI)
  static const int _airTemperatureMaxValue = 55;

  /// The max value of soil temperature. If it's reached, icon will be full filled (same value as in GardenUI)
  static const int _soilTemperatureMaxValue = 45;

  final Analytic? analytic;
  final AnalyticType type;
  final AnalyticAlertStatus? alertStatusOverride;

  const AnalyticCardWidget({
    super.key,
    required this.type,
    this.analytic,
    this.alertStatusOverride,
  });

  double get _fillPercentage {
    if (analytic == null) return 0.0;
    switch (type) {
      case AnalyticType.airTemperature:
        return (100 * analytic!.value / _airTemperatureMaxValue).clamp(
          0.0,
          100.0,
        );
      case AnalyticType.soilTemperature:
        return (100 * analytic!.value / _soilTemperatureMaxValue).clamp(
          0.0,
          100.0,
        );
      case AnalyticType.airHumidity:
      case AnalyticType.soilHumidity:
      case AnalyticType.deepSoilHumidity:
      case AnalyticType.battery:
        return analytic!.value;
      case AnalyticType.light:
        return 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = alertStatusOverride ?? analytic?.alertStatus;
    final isMobile = Platform.isIOS || Platform.isAndroid;

    return GardenCard(
      hasBorder: true,
      hasShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: GardenSpace.gapSm,
            children: [
              Flexible(
                child: Text(
                  type.name,
                  style:
                      isMobile
                          ? GardenTypography.caption.copyWith(
                            fontWeight: FontWeight.w700,
                          )
                          : GardenTypography.bodyMd.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (analytic != null &&
                  (status == AnalyticAlertStatus.warning ||
                      status == AnalyticAlertStatus.alert))
                AlertIndicator(
                  alertType:
                      status == AnalyticAlertStatus.warning
                          ? MenuAlertType.warning
                          : MenuAlertType.error,
                ),
            ],
          ),
          SizedBox(height: GardenSpace.gapMd),
          Flexible(
            fit: FlexFit.loose,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 130;

                final valueStyle = (isCompact
                        ? GardenTypography.headingLg
                        : GardenTypography.headingXl)
                    .copyWith(fontWeight: FontWeight.bold);

                final unitStyle = (isCompact
                        ? GardenTypography.bodyMd
                        : GardenTypography.headingMd)
                    .copyWith(fontStyle: FontStyle.italic);

                final iconSize =
                    isCompact ? GardenIconSize.md : GardenIconSize.lg;

                return Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: GardenSpace.paddingSm,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing:
                            isCompact ? GardenSpace.gapSm : GardenSpace.gapLg,
                        children: [
                          GardenIcon(
                            iconName: type.iconName,
                            fillPercentage: _fillPercentage,
                            color: type.iconColor,
                            size: iconSize,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                analytic != null
                                    ? analytic!.value.toStringAsFixed(1)
                                    : 'N/A',
                                style: valueStyle,
                              ),
                              Text(type.unit, style: unitStyle),
                            ],
                          ),
                        ],
                      ),
                    ),
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
