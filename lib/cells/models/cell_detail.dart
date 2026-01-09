import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:garden_connect/cells/models/cell_location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cell_detail.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class CellDetail {
  final int id;
  final String name;
  final int battery;
  final Analytics analytics;
  final CellLocation location;
  final DateTime lastUpdateAt;
  final bool isTracked;

  CellDetail({
    required this.id,
    required this.name,
    required this.battery,
    required this.analytics,
    required this.location,
    required this.lastUpdateAt,
    required this.isTracked
  });

  factory CellDetail.fromJson(Map<String, dynamic> json) => _$CellDetailFromJson(json);
}