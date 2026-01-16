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
          type: AnalyticType.airHumidity,
          alertStatus:
              analytics
                  .getLastAnalyticByType(AnalyticType.airHumidity)!
                  .alertStatus,
          value:
              analytics.getLastAnalyticByType(AnalyticType.airHumidity)!.value,
        ),
        AnalyticCardWidget(
          type: AnalyticType.light,
          alertStatus:
              analytics.getLastAnalyticByType(AnalyticType.light)!.alertStatus,
          value: analytics.getLastAnalyticByType(AnalyticType.light)!.value,
        ),
        AnalyticCardWidget(
          type: AnalyticType.airTemperature,
          alertStatus:
              analytics
                  .getLastAnalyticByType(AnalyticType.airTemperature)!
                  .alertStatus,
          value:
              analytics
                  .getLastAnalyticByType(AnalyticType.airTemperature)!
                  .value,
        ),
        AnalyticCardWidget(
          type: AnalyticType.soilTemperature,
          alertStatus:
              analytics
                  .getLastAnalyticByType(AnalyticType.soilTemperature)!
                  .alertStatus,
          value:
              analytics
                  .getLastAnalyticByType(AnalyticType.soilTemperature)!
                  .value,
        ),
        AnalyticCardWidget(
          type: AnalyticType.soilHumidity,
          alertStatus:
              analytics
                  .getLastAnalyticByType(AnalyticType.soilHumidity)!
                  .alertStatus,
          value:
              analytics.getLastAnalyticByType(AnalyticType.soilHumidity)!.value,
        ),
        AnalyticCardWidget(
          type: AnalyticType.deepSoilHumidity,
          alertStatus:
              analytics
                  .getLastAnalyticByType(AnalyticType.deepSoilHumidity)!
                  .alertStatus,
          value:
              analytics
                  .getLastAnalyticByType(AnalyticType.deepSoilHumidity)!
                  .value,
        ),
      ],
    );
  }
}
