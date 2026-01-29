import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/models/base_item.dart';

part 'cell.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Cell extends BaseItem {
  final int battery;
  final String location;
  final DateTime lastUpdateAt;
  final bool isTracked;

  Cell({
    required super.id,
    required super.name,
    required this.battery,
    required super.analytics,
    required this.location,
    required this.lastUpdateAt,
    required this.isTracked
  });

  factory Cell.fromJson(Map<String, dynamic> json) => _$CellFromJson(json);
}