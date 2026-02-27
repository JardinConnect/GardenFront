import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/models/base_item.dart';

part 'cell.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Cell extends BaseItem {
  final String? location;
  final DateTime updatedAt;

  Cell({
    required super.id,
    required super.name,
    required super.analytics,
    this.location,
    required this.updatedAt,
    required super.isTracked,
  });

  factory Cell.fromJson(Map<String, dynamic> json) => _$CellFromJson(json);
}