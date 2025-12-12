// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Analytics _$AnalyticsFromJson(Map<String, dynamic> json) => Analytics(
  airTemperature:
      (json['air_temperature'] as List<dynamic>?)
          ?.map(
            (e) => AirTemperatureAnalytic.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
  soilTemperature:
      (json['soil_temperature'] as List<dynamic>?)
          ?.map(
            (e) => SoilTemperatureAnalytic.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
  airHumidity:
      (json['air_humidity'] as List<dynamic>?)
          ?.map((e) => AirHumidityAnalytic.fromJson(e as Map<String, dynamic>))
          .toList(),
  soilHumidity:
      (json['soil_humidity'] as List<dynamic>?)
          ?.map((e) => SoilHumidityAnalytic.fromJson(e as Map<String, dynamic>))
          .toList(),
  light:
      (json['light'] as List<dynamic>?)
          ?.map((e) => LightAnalytic.fromJson(e as Map<String, dynamic>))
          .toList(),
);

AirTemperatureAnalytic _$AirTemperatureAnalyticFromJson(
  Map<String, dynamic> json,
) => AirTemperatureAnalytic(
  value: (json['value'] as num).toDouble(),
  occurredAt: DateTime.parse(json['occurredAt'] as String),
  sensorId: json['sensorId'] as String,
);

SoilTemperatureAnalytic _$SoilTemperatureAnalyticFromJson(
  Map<String, dynamic> json,
) => SoilTemperatureAnalytic(
  value: (json['value'] as num).toDouble(),
  occurredAt: DateTime.parse(json['occurredAt'] as String),
  sensorId: json['sensorId'] as String,
);

AirHumidityAnalytic _$AirHumidityAnalyticFromJson(Map<String, dynamic> json) =>
    AirHumidityAnalytic(
      value: (json['value'] as num).toDouble(),
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      sensorId: json['sensorId'] as String,
    );

SoilHumidityAnalytic _$SoilHumidityAnalyticFromJson(
  Map<String, dynamic> json,
) => SoilHumidityAnalytic(
  value: (json['value'] as num).toDouble(),
  occurredAt: DateTime.parse(json['occurredAt'] as String),
  sensorId: json['sensorId'] as String,
);

LightAnalytic _$LightAnalyticFromJson(Map<String, dynamic> json) =>
    LightAnalytic(
      value: (json['value'] as num).toDouble(),
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      sensorId: json['sensorId'] as String,
    );
