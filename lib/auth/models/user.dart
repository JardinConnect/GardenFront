import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final Role role;
  final String? token;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.phoneNumber,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserAddDto{
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final Role role;
  final String password;

  UserAddDto({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.role,
    required this.password,
  });

  factory UserAddDto.fromJson(Map<String, dynamic> json) => _$UserAddDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserAddDtoToJson(this);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum Role {
  superadmin,
  admin,
  employees,
  trainee;

  String get displayName {
    switch (this) {
      case Role.superadmin:
        return 'Super Admin';
      case Role.admin:
        return 'Admin';
      case Role.employees:
        return 'Employé';
      case Role.trainee:
        return 'Saisonnié';
    }
  }
}