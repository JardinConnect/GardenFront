import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/models/base_item.dart';

part 'cell.g.dart';

class UserSummary {
  final String id;
  final String firstName;
  final String lastName;

  UserSummary({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory UserSummary.fromJson(Map<String, dynamic> json) => UserSummary(
    id: json['id'] as String,
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
  );

  String get fullName => '$firstName $lastName';
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Cell extends BaseItem {
  final String? location;
  final DateTime createdAt;
  final DateTime? updatedAt;
  @JsonKey(fromJson: _userSummaryFromJson)
  final UserSummary? createdBy;
  @JsonKey(fromJson: _userSummaryFromJson)
  final UserSummary? updatedBy;

  Cell({
    required super.id,
    required super.name,
    required super.analytics,
    this.location,
    required this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    required super.isTracked,
  });

  factory Cell.fromJson(Map<String, dynamic> json) => _$CellFromJson(json);

  static UserSummary? _userSummaryFromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return UserSummary.fromJson(json);
  }
}