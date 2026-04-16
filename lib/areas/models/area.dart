import 'package:flutter/material.dart';

import 'package:json_annotation/json_annotation.dart';

import '../../analytics/models/analytics.dart';
import '../../cells/models/cell.dart';
import '../../common/models/base_item.dart';

part 'area.g.dart';

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
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
  );

  String get fullName => '$firstName $lastName';
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Area extends BaseItem {
  @JsonKey(fromJson: _colorFromJson)
  final Color color;
  final int level;
  final List<Area>? areas;
  final List<Cell>? cells;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;
  @JsonKey(name: 'createdBy', fromJson: _userSummaryFromJson)
  final UserSummary? createdBy;
  @JsonKey(name: 'updatedBy', fromJson: _userSummaryFromJson)
  final UserSummary? updatedBy;

  Area({
    required super.id,
    required super.name,
    required this.color,
    required this.level,
    required super.analytics,
    this.areas,
    this.cells,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    super.parentId,
    super.isTracked,
  });

  factory Area.fromJson(Map<String, dynamic> json) => _$AreaFromJson(json);

  copyWith({
    String? id,
    String? name,
    Color? color,
    int? level,
    Analytics? analytics,
    List<Area>? areas,
    List<Cell>? cells,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserSummary? createdBy,
    UserSummary? updatedBy,
    bool? isTracked,
  }) {
    return Area(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      level: level ?? this.level,
      analytics: analytics ?? this.analytics,
      areas: areas ?? this.areas,
      cells: cells ?? this.cells,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      isTracked: isTracked ?? this.isTracked,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Area &&
        other.runtimeType == runtimeType &&
        other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  static Color _colorFromJson(String colorString) {
    final hexColor = colorString.replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }

  static UserSummary? _userSummaryFromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return UserSummary.fromJson(json);
  }

  /// Méthode statique pour compter le nombre d'areas par niveau dans la hiérarchie
  static Map<int, int> countAreasByLevel(List<Area> areas) {
    final Map<int, int> count = {};

    void countRecursive(List<Area>? areaList) {
      if (areaList == null) return;

      for (final area in areaList) {
        count[area.level] = (count[area.level] ?? 0) + 1;

        if (area.areas != null && area.areas!.isNotEmpty) {
          countRecursive(area.areas);
        }
      }
    }

    countRecursive(areas);
    return count;
  }

  /// Méthode statique pour aplatir la hiérarchie des areas en une liste unique
  /// pour les afficher dans la recherche
  static List<Area> getAllAreasFlattened(List<Area> areas) {
    final List<Area> flatList = [];

    void flattenRecursive(List<Area>? areaList) {
      if (areaList == null) return;

      for (final area in areaList) {
        flatList.add(area);

        if (area.areas != null && area.areas!.isNotEmpty) {
          flattenRecursive(area.areas);
        }
      }
    }

    flattenRecursive(areas);
    return flatList;
  }

  /// Méthode pour récupérer tous les descendants d'une area (enfants, petits-enfants, etc.)
  static List<Area> getDescendants(Area area) {
    final List<Area> descendants = [];

    void collectDescendants(List<Area>? areaList) {
      if (areaList == null) return;

      for (final child in areaList) {
        descendants.add(child);
        if (child.areas != null && child.areas!.isNotEmpty) {
          collectDescendants(child.areas);
        }
      }
    }

    collectDescendants(area.areas);
    return descendants;
  }

  static Area? findAreaById(List<Area> areas, String id) {
    for (final area in areas) {
      if (area.id == id) {
        return area;
      }
      if (area.areas != null && area.areas!.isNotEmpty) {
        final found = findAreaById(area.areas!, id);
        if (found != null) {
          return found;
        }
      }
    }
    return null;
  }

  /// Trouve le parent direct d'un area en parcourant l'arbre
  static Area? findParentOf(List<Area> areas, String childId) {
    for (final area in areas) {
      if (area.areas != null && area.areas!.any((a) => a.id == childId)) {
        return area;
      }
      final found = findParentOf(area.areas ?? [], childId);
      if (found != null) return found;
    }
    return null;
  }
}
