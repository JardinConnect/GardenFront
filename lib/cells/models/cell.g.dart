// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cell.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cell _$CellFromJson(Map<String, dynamic> json) => Cell(
  name: json['name'] as String,
  analytics:
      (json['analytics'] as List<dynamic>?)
          ?.map((e) => Analytics.fromJson(e as Map<String, dynamic>))
          .toList(),
);
