import 'package:flutter/material.dart';
import 'package:garden_connect/analytics/models/analytic_alert_status.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:garden_ui/ui/foundation/color/color_design_system.dart';

import '../filters/analytics_filter.dart';

part 'analytics.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Analytics {
  final List<AirTemperatureAnalytic>? airTemperature;
  final List<SoilTemperatureAnalytic>? soilTemperature;
  final List<AirHumidityAnalytic>? airHumidity;
  final List<SoilHumidityAnalytic>? soilHumidity;
  final List<DeepSoilHumidityAnalytic>? deepSoilHumidity;
  final List<LightAnalytic>? light;

  Analytics({
    this.airTemperature,
    this.soilTemperature,
    this.airHumidity,
    this.soilHumidity,
    this.deepSoilHumidity,
    this.light,
  });

  factory Analytics.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsFromJson(json);

  List<Analytic> getAnalyticsByType(AnalyticType type) {
    switch (type) {
      case AnalyticType.airTemperature:
        return airTemperature ?? [];
      case AnalyticType.soilTemperature:
        return soilTemperature ?? [];
      case AnalyticType.airHumidity:
        return airHumidity ?? [];
      case AnalyticType.soilHumidity:
        return soilHumidity ?? [];
      case AnalyticType.deepSoilHumidity:
        return deepSoilHumidity ?? [];
      case AnalyticType.light:
        return light ?? [];
    }
  }

  Analytic? getLastAnalyticByType(AnalyticType type) {
    final analytics = getAnalyticsByType(type);
    if (analytics.isEmpty) return null;
    return analytics.fold<Analytic>(
      analytics.first,
      (prev, element) => element.occurredAt.isAfter(prev.occurredAt) ? element : prev,
    );
  }

  List<AnalyticsFilter> get analyticsFilters {
    final filters = <AnalyticsFilter>[];
    final filterTypes = <AnalyticsFilterEnum>{};

    for (var type in availableTypes) {
      AnalyticsFilterEnum filterType;
      switch (type) {
        case AnalyticType.airTemperature:
        case AnalyticType.soilTemperature:
          filterType = AnalyticsFilterEnum.temperature;
          break;
        case AnalyticType.airHumidity:
        case AnalyticType.soilHumidity:
        case AnalyticType.deepSoilHumidity:
          filterType = AnalyticsFilterEnum.humidity;
          break;
        case AnalyticType.light:
          filterType = AnalyticsFilterEnum.light;
          break;
      }

      if (!filterTypes.contains(filterType)) {
        filterTypes.add(filterType);
        filters.add(AnalyticsFilter(
          filterType: filterType,
          analytics: this,
        ));
      }
    }

    return filters;
  }

  bool hasData(AnalyticType type) {
    return getAnalyticsByType(type).isNotEmpty;
  }

  List<AnalyticType> get availableTypes {
    return AnalyticType.values.where((type) => hasData(type)).toList();
  }

  List<LineChartBarData> _buildLineChartBarData(AnalyticType type) {
    final analytics = getAnalyticsByType(type);
    if (analytics.isEmpty) return [];

    final sortedAnalytics = List<Analytic>.from(analytics)
      ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));

    final spots = List.generate(sortedAnalytics.length, (index) {
      return FlSpot(index.toDouble(), sortedAnalytics[index].value);
    });

    return [
      LineChartBarData(
        spots: spots,
        barWidth: 2,
        color: type.color,
        dotData: FlDotData(show: true),
      ),
    ];
  }

  List<LineChartBarData> buildLineBarsData() {
    List<LineChartBarData> lineBarsData = [];
    for (var type in availableTypes) {
      lineBarsData.addAll(_buildLineChartBarData(type));
    }
    return lineBarsData;
  }

  List<LineChartBarData> buildLineBarsDataForTypes(List<AnalyticType> types) {
    List<LineChartBarData> lineBarsData = [];
    for (var type in types) {
      final data = _buildLineChartBarData(type);
      if (data.isNotEmpty) {
        lineBarsData.addAll(data);
      }
    }
    return lineBarsData;
  }
}

enum AnalyticType {
  airTemperature,
  soilTemperature,
  airHumidity,
  soilHumidity,
  deepSoilHumidity,
  light;

  String get name {
    switch (this) {
      case AnalyticType.airHumidity:
        return 'Humidité de l\'air';
      case AnalyticType.soilHumidity:
        return 'Humidité de la surface du sol';
      case AnalyticType.deepSoilHumidity:
        return 'Humidité du sol profond';
      case AnalyticType.airTemperature:
        return 'Température de l\'air';
      case AnalyticType.soilTemperature:
        return 'Température du sol';
      case AnalyticType.light:
        return 'Luminosité';
    }
  }

  String get icon_name {
    switch (this) {
      case AnalyticType.airHumidity:
        return 'Pluie';
      case AnalyticType.soilHumidity:
        return 'Humidite_surface';
      case AnalyticType.deepSoilHumidity:
        return 'Humidite_profondeur';
      case AnalyticType.airTemperature:
      case AnalyticType.soilTemperature:
        return 'Thermometre';
      case AnalyticType.light:
        return 'Soleil';
    }
  }

  Color get color {
    switch (this) {
      case AnalyticType.airHumidity:
        return const Color(0xFFFF5892);
      case AnalyticType.soilHumidity:
        return const Color(0xFF4B5FFA);
      case AnalyticType.deepSoilHumidity:
        return const Color(0xFF4B5FFA);
      case AnalyticType.airTemperature:
        return GardenColors.redAlert.shade500;
      case AnalyticType.soilTemperature:
        return Colors.orange;
      case AnalyticType.light:
        return Colors.yellow;
    }
  }
}

abstract class Analytic {
  final double value;
  final DateTime occurredAt;
  final int sensorId;
  final AnalyticAlertStatus alertStatus;

  Analytic({
    required this.value,
    required this.occurredAt,
    required this.sensorId,
    required this.alertStatus,
  });
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class AirTemperatureAnalytic extends Analytic {
  AirTemperatureAnalytic({
    required super.value,
    required super.occurredAt,
    required super.sensorId,
    required super.alertStatus,
  });

  factory AirTemperatureAnalytic.fromJson(Map<String, dynamic> json) =>
      _$AirTemperatureAnalyticFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class SoilTemperatureAnalytic extends Analytic {
  SoilTemperatureAnalytic({
    required super.value,
    required super.occurredAt,
    required super.sensorId,
    required super.alertStatus,
  });

  factory SoilTemperatureAnalytic.fromJson(Map<String, dynamic> json) =>
      _$SoilTemperatureAnalyticFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class AirHumidityAnalytic extends Analytic {
  AirHumidityAnalytic({
    required super.value,
    required super.occurredAt,
    required super.sensorId,
    required super.alertStatus,
  });

  factory AirHumidityAnalytic.fromJson(Map<String, dynamic> json) =>
      _$AirHumidityAnalyticFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class SoilHumidityAnalytic extends Analytic {
  SoilHumidityAnalytic({
    required super.value,
    required super.occurredAt,
    required super.sensorId,
    required super.alertStatus,
  });

  factory SoilHumidityAnalytic.fromJson(Map<String, dynamic> json) =>
      _$SoilHumidityAnalyticFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class DeepSoilHumidityAnalytic extends Analytic {
  DeepSoilHumidityAnalytic({
    required super.value,
    required super.occurredAt,
    required super.sensorId,
    required super.alertStatus,
  });

  factory DeepSoilHumidityAnalytic.fromJson(Map<String, dynamic> json) =>
      _$DeepSoilHumidityAnalyticFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class LightAnalytic extends Analytic {
  LightAnalytic({
    required super.value,
    required super.occurredAt,
    required super.sensorId,
    required super.alertStatus,
  });

  factory LightAnalytic.fromJson(Map<String, dynamic> json) =>
      _$LightAnalyticFromJson(json);
}
