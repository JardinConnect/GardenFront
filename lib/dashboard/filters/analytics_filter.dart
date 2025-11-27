import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';

import '../models/analytics.dart';

enum AnalyticsFilterEnum { humidity, temperature, light }

class AnalyticsFilter {
  final AnalyticsFilterEnum filterType;
  final Analytics analytics;

  AnalyticsFilter({required this.filterType, required this.analytics});

  String get displayName {
    switch (filterType) {
      case AnalyticsFilterEnum.humidity:
        return 'Humidité';
      case AnalyticsFilterEnum.temperature:
        return 'Température';
      case AnalyticsFilterEnum.light:
        return 'Luminosité';
    }
  }

  List<AnalyticType> get analyticTypes {
    switch (filterType) {
      case AnalyticsFilterEnum.humidity:
        return [
          AnalyticType.airHumidity,
          AnalyticType.soilHumidity,
        ].where((type) => analytics.hasData(type)).toList();
      case AnalyticsFilterEnum.temperature:
        return [
          AnalyticType.airTemperature,
          AnalyticType.soilTemperature,
        ].where((type) => analytics.hasData(type)).toList();
      case AnalyticsFilterEnum.light:
        return [
          AnalyticType.light,
        ].where((type) => analytics.hasData(type)).toList();
    }
  }

  Widget get buildCaptions {
    final types = analyticTypes;

    if (types.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children:
          types
              .map(
                (type) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 30,
                        height: 4,
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: type.color,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          type.name,
                          style: GardenTypography.bodyMd,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }
}
