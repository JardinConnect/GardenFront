import 'package:flutter/material.dart';
import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:garden_connect/analytics/widgets/analytic_card.dart';
import 'package:garden_ui/ui/design_system.dart';

class AnalyticsCardsGrid extends StatelessWidget {
  final Analytics analytics;

  const AnalyticsCardsGrid({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: GardenSpace.gapMd,
      crossAxisSpacing: GardenSpace.gapXl,
      childAspectRatio: 2.5,
      shrinkWrap: true,
      children: <Widget>[
        AnalyticCard(
          type: AnalyticType.airHumidity,
          alertStatus:
              analytics
                  .getLastAnalyticByType(AnalyticType.airHumidity)!
                  .alertStatus,
          value:
              analytics.getLastAnalyticByType(AnalyticType.airHumidity)!.value,
        ),
        AnalyticCard(
          type: AnalyticType.light,
          alertStatus:
              analytics.getLastAnalyticByType(AnalyticType.light)!.alertStatus,
          value: analytics.getLastAnalyticByType(AnalyticType.light)!.value,
        ),
        AnalyticCard(
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
        AnalyticCard(
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
        AnalyticCard(
          type: AnalyticType.soilHumidity,
          alertStatus:
              analytics
                  .getLastAnalyticByType(AnalyticType.soilHumidity)!
                  .alertStatus,
          value:
              analytics.getLastAnalyticByType(AnalyticType.soilHumidity)!.value,
        ),
        AnalyticCard(
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
