import 'package:flutter/material.dart';

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
  final List<BatteryAnalytic>? battery;

  Analytics({
    this.airTemperature,
    this.soilTemperature,
    this.airHumidity,
    this.soilHumidity,
    this.deepSoilHumidity,
    this.light,
    this.battery
  });

  factory Analytics.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsFromJson(json);

  List<Analytic> getAllAnalytics() {
    return [
      ...?airTemperature,
      ...?soilTemperature,
      ...?airHumidity,
      ...?soilHumidity,
      ...?deepSoilHumidity,
      ...?light,
    ];
  }

  Analytics filterByDateRange(DateTime start, DateTime end) {
    return Analytics(
      airTemperature: airTemperature
          ?.where((a) => a.occurredAt.isAfter(start) && a.occurredAt.isBefore(end))
          .toList(),
      soilTemperature: soilTemperature
          ?.where((a) => a.occurredAt.isAfter(start) && a.occurredAt.isBefore(end))
          .toList(),
      airHumidity: airHumidity
          ?.where((a) => a.occurredAt.isAfter(start) && a.occurredAt.isBefore(end))
          .toList(),
      soilHumidity: soilHumidity
          ?.where((a) => a.occurredAt.isAfter(start) && a.occurredAt.isBefore(end))
          .toList(),
      deepSoilHumidity: deepSoilHumidity
          ?.where((a) => a.occurredAt.isAfter(start) && a.occurredAt.isBefore(end))
          .toList(),
      light: light
          ?.where((a) => a.occurredAt.isAfter(start) && a.occurredAt.isBefore(end))
          .toList(),
    );
  }

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
      case AnalyticType.battery:
        return battery ?? [];
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
        case AnalyticType.battery:
          continue;
      }

      if (!filterTypes.contains(filterType)) {
        filterTypes.add(filterType);
        filters.add(AnalyticsFilter(filterType: filterType, analytics: this));
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
  light,
  battery;

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
      case AnalyticType.battery:
        return 'Batterie';
    }
  }

  String get iconName {
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
      case AnalyticType.battery:
        return 'Batterie';
    }
  }

  Color get iconColor {
    switch (this) {
      case AnalyticType.airHumidity:
      case AnalyticType.soilHumidity:
      case AnalyticType.deepSoilHumidity:
        return GardenColors.blueInfo.shade400;
      case AnalyticType.airTemperature:
        return GardenColors.redAlert.shade500;
      case AnalyticType.soilTemperature:
        return Colors.brown;
      case AnalyticType.light:
        return GardenColors.yellowWarning.shade500;
      case AnalyticType.battery:
        return Colors.green;
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
      case AnalyticType.battery:
        return Colors.green;
    }
  }

  String get unit {
    switch (this) {
      case AnalyticType.airTemperature:
      case AnalyticType.soilTemperature:
        return AnalyticsFilterEnum.temperature.unit;
      case AnalyticType.airHumidity:
      case AnalyticType.soilHumidity:
      case AnalyticType.deepSoilHumidity:
      case AnalyticType.battery:
        return AnalyticsFilterEnum.humidity.unit;
      case AnalyticType.light:
        return AnalyticsFilterEnum.light.unit;
    }
  }
}

enum AnalyticAlertStatus {
  @JsonValue("OK") ok,
  @JsonValue("WARNING") warning,
  @JsonValue("ALERT") alert;

  Color get color {
    switch(this) {
      case AnalyticAlertStatus.ok:
        return GardenColors.tertiary.shade500;
      case AnalyticAlertStatus.warning:
        return GardenColors.yellowWarning.shade500;
      case AnalyticAlertStatus.alert:
        return GardenColors.redAlert.shade500;
    }
  }
}

abstract class Analytic {
  @JsonKey(fromJson: _valueFromJson)
  final double value;
  final DateTime occurredAt;
  @JsonKey(name: 'sensor_code', fromJson: _sensorCodeFromJson)
  final int? sensorCode;
  final AnalyticAlertStatus? alertStatus;

  Analytic({
    required this.value,
    required this.occurredAt,
    this.sensorCode,
    this.alertStatus,
  });

  AnalyticType getType();

  // TODO:Convertisseur temporaire - À SUPPRIMER quand le backend sera fixé
  static double _valueFromJson(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString()) ?? 0.0;
  }

  // TODO: Convertisseur temporaire - À SUPPRIMER quand le backend sera fixé
  static int? _sensorCodeFromJson(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class AirTemperatureAnalytic extends Analytic {
  AirTemperatureAnalytic({
    required super.value,
    required super.occurredAt,
    super.sensorCode,
    super.alertStatus,
  });

  factory AirTemperatureAnalytic.fromJson(Map<String, dynamic> json) =>
      _$AirTemperatureAnalyticFromJson(json);

  @override
  AnalyticType getType() {
    return AnalyticType.airTemperature;
  }
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class SoilTemperatureAnalytic extends Analytic {
  SoilTemperatureAnalytic({
    required super.value,
    required super.occurredAt,
    super.sensorCode,
    super.alertStatus,
  });

  factory SoilTemperatureAnalytic.fromJson(Map<String, dynamic> json) =>
      _$SoilTemperatureAnalyticFromJson(json);

  @override
  AnalyticType getType() {
    return AnalyticType.soilTemperature;
  }
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class AirHumidityAnalytic extends Analytic {
  AirHumidityAnalytic({
    required super.value,
    required super.occurredAt,
    super.sensorCode,
    super.alertStatus,
  });

  factory AirHumidityAnalytic.fromJson(Map<String, dynamic> json) =>
      _$AirHumidityAnalyticFromJson(json);

  @override
  AnalyticType getType() {
    return AnalyticType.airHumidity;
  }
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class SoilHumidityAnalytic extends Analytic {
  SoilHumidityAnalytic({
    required super.value,
    required super.occurredAt,
    super.sensorCode,
    super.alertStatus,
  });

  factory SoilHumidityAnalytic.fromJson(Map<String, dynamic> json) =>
      _$SoilHumidityAnalyticFromJson(json);

  @override
  AnalyticType getType() {
    return AnalyticType.soilHumidity;
  }
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class DeepSoilHumidityAnalytic extends Analytic {
  DeepSoilHumidityAnalytic({
    required super.value,
    required super.occurredAt,
    super.sensorCode,
    super.alertStatus,
  });

  factory DeepSoilHumidityAnalytic.fromJson(Map<String, dynamic> json) =>
      _$DeepSoilHumidityAnalyticFromJson(json);

  @override
  AnalyticType getType() {
    return AnalyticType.deepSoilHumidity;
  }
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class LightAnalytic extends Analytic {
  LightAnalytic({
    required super.value,
    required super.occurredAt,
    super.sensorCode,
    super.alertStatus,
  });

  factory LightAnalytic.fromJson(Map<String, dynamic> json) =>
      _$LightAnalyticFromJson(json);

  @override
  AnalyticType getType() {
    return AnalyticType.light;
  }
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class BatteryAnalytic extends Analytic {
  BatteryAnalytic({
    required super.value,
    required super.occurredAt,
    super.sensorCode,
    super.alertStatus,
  });

  factory BatteryAnalytic.fromJson(Map<String, dynamic> json) =>
      _$BatteryAnalyticFromJson(json);

  @override
  AnalyticType getType() {
    return AnalyticType.battery;
  }
}
