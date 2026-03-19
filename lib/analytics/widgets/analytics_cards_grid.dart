import 'package:flutter/material.dart';
import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:garden_connect/analytics/widgets/analytic_card.dart';
import 'package:garden_ui/ui/design_system.dart';

class AnalyticsCardsGridWidget extends StatelessWidget {
  final Analytics analytics;

  const AnalyticsCardsGridWidget({super.key, required this.analytics});

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
        final crossAxisCount = (constraints.maxWidth / 300).floor().clamp(1, 3);

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: GardenSpace.gapMd,
            crossAxisSpacing: GardenSpace.gapXl,
            childAspectRatio: 2.5,
            mainAxisExtent: 130,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: types.length,
          itemBuilder: (context, index) {
            return AnalyticCardWidget(
              type: types[index],
              analytic: availableAnalytics[index],
            );
          },
        );
      },
    );
  }
}