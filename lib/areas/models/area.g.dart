// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Area _$AreaFromJson(Map<String, dynamic> json) => Area(
  name: json['name'] as String,
  color: Area._colorFromJson(json['color'] as String),
  level: (json['level'] as num).toInt(),
  analytics:
      json['analytics'] == null
          ? null
          : Analytics.fromJson(json['analytics'] as Map<String, dynamic>),
  areas:
      (json['areas'] as List<dynamic>?)
          ?.map((e) => Area.fromJson(e as Map<String, dynamic>))
          .toList(),
  cells:
      (json['cells'] as List<dynamic>?)
          ?.map((e) => Cell.fromJson(e as Map<String, dynamic>))
          .toList(),
);
