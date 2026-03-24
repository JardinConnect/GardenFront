import 'dart:io';

import 'package:flutter/material.dart';
import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:garden_connect/analytics/widgets/analytic_card.dart';
import 'package:garden_ui/ui/design_system.dart';

class AnalyticsCardsGridWidget extends StatelessWidget {
  final Analytics analytics;
  final Map<AnalyticType, AnalyticAlertStatus>? alertStatusOverrides;

  const AnalyticsCardsGridWidget({
    super.key,
    required this.analytics,
    this.alertStatusOverrides,
  });

  @override
  Widget build(BuildContext context) {
    final types = [
      AnalyticType.airTemperature,
      AnalyticType.airHumidity,
      AnalyticType.light,
      AnalyticType.soilTemperature,
      AnalyticType.deepSoilHumidity,
      AnalyticType.soilHumidity,
    ];

    final availableAnalytics = types
        .map((type) => analytics.getLastAnalyticByType(type))
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = Platform.isIOS || Platform.isAndroid;
        final crossAxisCount = (constraints.maxWidth / (isMobile ? 150 : 300)).floor().clamp(1, 3);

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: GardenSpace.gapMd,
            crossAxisSpacing: isMobile ? GardenSpace.gapMd : GardenSpace.gapXl,
            childAspectRatio: 2.5,
            mainAxisExtent: isMobile ? 110 : 130,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: types.length,
          itemBuilder: (context, index) {
            final analytic = availableAnalytics[index];
            return AnalyticCardWidget(
              analytic: analytic,
              type: types[index],
              alertStatusOverride: alertStatusOverrides?[analytic?.getType()],
            );
          },
        );
      },
    );
  }
}
