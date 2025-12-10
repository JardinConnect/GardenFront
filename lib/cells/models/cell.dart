import 'package:json_annotation/json_annotation.dart';

import '../../analytics/models/analytics.dart';

part 'cell.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Cell {
  final String name;
  final List<Analytics>? analytics;

  Cell({
    required this.name,
    required this.analytics,
  });

  factory Cell.fromJson(Map<String, dynamic> json) => _$CellFromJson(json);
}