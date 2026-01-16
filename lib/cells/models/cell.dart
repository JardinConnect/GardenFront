import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cell.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Cell {
  final int id;
  final String name;
  final int battery;
  final Analytics analytics;
  final String location;
  final DateTime lastUpdateAt;
  final bool isTracked;

  Cell({
    required this.id,
    required this.name,
    required this.battery,
    required this.analytics,
    required this.location,
    required this.lastUpdateAt,
    required this.isTracked
  });

  factory Cell.fromJson(Map<String, dynamic> json) => _$CellFromJson(json);
}