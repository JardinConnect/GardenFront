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
      AnalyticType.airHumidity,
      AnalyticType.light,
      AnalyticType.airTemperature,
      AnalyticType.soilTemperature,
      AnalyticType.soilHumidity,
      AnalyticType.deepSoilHumidity,
    ];

    final availableAnalytics = types
        .map((type) => analytics.getLastAnalyticByType(type))
        .whereType<Analytic>()
        .toList();

    if (availableAnalytics.isEmpty) return const SizedBox.shrink();

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
          itemCount: availableAnalytics.length,
          itemBuilder: (context, index) {
            return AnalyticCardWidget(analytic: availableAnalytics[index]);
          },
        );
      },
    );
  }
}