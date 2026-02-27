import 'package:json_annotation/json_annotation.dart';
part 'farm.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Farm {
  final String name;
  final String address;
  final String postalCode;
  final String city;
  final String phoneNumber;

  Farm({
    required this.name,
    required this.address,
    required this.postalCode,
    required this.city,
    required this.phoneNumber,
  });

  factory Farm.fromJson(Map<String, dynamic> json) => _$FarmFromJson(json);

  Map<String, dynamic> toJson() => _$FarmToJson(this);
}