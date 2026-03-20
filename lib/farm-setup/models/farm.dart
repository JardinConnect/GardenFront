import 'package:garden_connect/auth/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../areas/models/area.dart';

part 'farm.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Farm {
  String name;
  String address;
  String zipCode;
  String city;
  String phoneNumber;

  Farm({
    required this.name,
    required this.address,
    required this.zipCode,
    required this.city,
    required this.phoneNumber,
  });

  factory Farm.fromJson(Map<String, dynamic> json) => _$FarmFromJson(json);

  Map<String, dynamic> toJson() => _$FarmToJson(this);
}

class InitFarmDto {
  final Farm farm;
  final UserAddDto user;
  final List<Area> areas;

  InitFarmDto({
    required this.farm,
    required this.user,
    required this.areas,
  });

  Map<String, dynamic>  toJson() => {
    'farm': farm.toJson(),
    'user': user.toJson(),
    'areas': [
      for(var area in areas){
        'level':area.level,
        'name':area.name,
        'is_tracked':true,
        'parentId':area.parentId,
      }
    ],
  };
}