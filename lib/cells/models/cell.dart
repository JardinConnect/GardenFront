import 'package:garden_connect/cells/models/cell_analytics.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cell.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Cell {
  final String name;
  final int battery;
  final CellAnalytics analytics;

  Cell({
    required this.name,
    required this.battery,
    required this.analytics,
  });

  factory Cell.fromJson(Map<String, dynamic> json) => _$CellFromJson(json);
}