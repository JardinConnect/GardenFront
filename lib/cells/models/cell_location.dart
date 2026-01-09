import 'package:json_annotation/json_annotation.dart';

part 'cell_location.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class CellLocation {
  final int id;
  final String name;
  final CellLocation? location;

  CellLocation({required this.id, required this.name, required this.location});

  factory CellLocation.fromJson(Map<String, dynamic> json) => _$CellLocationFromJson(json);
}
