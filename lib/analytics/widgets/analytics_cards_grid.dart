import 'package:flutter/material.dart';
import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:garden_connect/analytics/widgets/analytic_card.dart';
import 'package:garden_ui/ui/design_system.dart';

class AnalyticsCardsGridWidget extends StatelessWidget {
  final Analytics analytics;

  const AnalyticsCardsGridWidget({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: GardenSpace.gapMd,
      crossAxisSpacing: GardenSpace.gapXl,
      childAspectRatio: 2.5,
      shrinkWrap: true,
      children: <Widget>[
        AnalyticCardWidget(
          analytic: analytics.getLastAnalyticByType(AnalyticType.airHumidity)!,
        ),
        AnalyticCardWidget(
          analytic: analytics.getLastAnalyticByType(AnalyticType.light)!,
        ),
        AnalyticCardWidget(
          analytic: analytics.getLastAnalyticByType(AnalyticType.airTemperature)!,
        ),
        AnalyticCardWidget(
          analytic: analytics.getLastAnalyticByType(AnalyticType.soilTemperature)!,
        ),
        AnalyticCardWidget(
          analytic: analytics.getLastAnalyticByType(AnalyticType.soilHumidity)!,
        ),
        AnalyticCardWidget(
          analytic: analytics.getLastAnalyticByType(AnalyticType.deepSoilHumidity)!,
        ),
      ],
    );
  }
}
