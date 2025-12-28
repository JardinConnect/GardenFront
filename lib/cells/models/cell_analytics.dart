import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cell_analytics.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class CellAnalytics {
  final AirTemperatureAnalytic airTemperature;
  final SoilTemperatureAnalytic soilTemperature;
  final AirHumidityAnalytic airHumidity;
  final SoilHumidityAnalytic soilHumidity;
  final DeepSoilHumidityAnalytic deepSoilHumidity;
  final LightAnalytic light;

  CellAnalytics({
    required this.airTemperature,
    required this.soilTemperature,
    required this.airHumidity,
    required this.soilHumidity,
    required this.deepSoilHumidity,
    required this.light,
  });

  factory CellAnalytics.fromJson(Map<String, dynamic> json) => _$CellAnalyticsFromJson(json);
}