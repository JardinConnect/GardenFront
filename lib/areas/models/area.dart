import 'package:flutter/material.dart';

import 'package:json_annotation/json_annotation.dart';

import '../../analytics/models/analytics.dart';
import '../../cells/models/cell.dart';

part 'area.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Area {
  final String name;
  @JsonKey(fromJson: _colorFromJson)
  final Color color;
  final int level;
  final Analytics? analytics;
  final List<Area>? areas;
  final List<Cell>? cells;

  Area({
    required this.name,
    required this.color,
    required this.level,
    this.analytics,
    this.areas,
    this.cells,
  });

  factory Area.fromJson(Map<String, dynamic> json) => _$AreaFromJson(json);

  static Color _colorFromJson(String colorString) {
    return Color(int.parse(colorString, radix: 16));
  }
}