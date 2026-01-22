// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cell.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cell _$CellFromJson(Map<String, dynamic> json) => Cell(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  battery: (json['battery'] as num).toInt(),
  analytics: Analytics.fromJson(json['analytics'] as Map<String, dynamic>),
  location: json['location'] as String,
  lastUpdateAt: DateTime.parse(json['last_update_at'] as String),
  isTracked: json['is_tracked'] as bool,
);
