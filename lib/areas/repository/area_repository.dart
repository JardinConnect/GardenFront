import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/area.dart';

class AreaRepository {
  // Liste en mémoire pour simuler la persistance
  List<Map<String, dynamic>>? _cachedAreas;

  Future<List<Area>> fetchAreas() async {
    try {
      final storage = FlutterSecureStorage();

      String? token = await storage.read(key: 'auth_token');
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/area'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final areas =
            (responseData as List).map((area) => Area.fromJson(area)).toList();
        return areas;
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur de chargement des espaces: $e');
      }
      return [];
    }
  }

  Future<Area> createArea({
    required String name,
    required String color,
    Area? parentArea,
  }) async {
    // TODO: Remplacer par un vrai appel API
    try {
      // Simuler un délai réseau
      await Future.delayed(const Duration(milliseconds: 500));

      // Créer la nouvelle area
      final newAreaJson = {
        "id": "1",
        "name": name,
        "color": color,
        "level": parentArea != null ? parentArea.level + 1 : 1,
        "areas": <Map<String, dynamic>>[],
        "is_tracked": false,
      };

      if (parentArea == null) {
        _cachedAreas ??= [];
        _cachedAreas!.add(newAreaJson);
      } else {
        _addAreaToParent(_cachedAreas!, parentArea.name, newAreaJson);
      }

      return Area.fromJson(newAreaJson);
    } catch (e) {
      throw Exception('Failed to create area: $e');
    }
  }

// Ajoutez cette méthode après fetchAreas()
  Future<Area?> fetchAreaById(int id) async {
    try {
      // Utiliser le cache si disponible
      if (_cachedAreas != null) {
        final allAreas =
            _cachedAreas!.map((area) => Area.fromJson(area)).toList();
        final flattenedAreas = Area.getAllAreasFlattened(allAreas);
        return flattenedAreas.cast<Area?>().firstWhere(
          (area) => area?.id == id,
          orElse: () => null,
        );
      }

      // Si pas de cache, charger d'abord les areas
      await fetchAreas();
      return fetchAreaById(id);
    } catch (e) {
      throw Exception('Failed to load area with id $id: $e');
    }
  }

  Future<Area> updateArea({
    required String id,
    String? name,
    Color? color,
    String? parentId,
    bool? isTracked,
  }) async {
    try {
      final storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'auth_token');

      final Map<String, dynamic> body = {};
      if (name != null) body['name'] = name;
      if (color != null) body['color'] = color.value.toRadixString(16);
      if (parentId != null) body['parent_id'] = parentId;
      if (isTracked != null) body['is_tracked'] = isTracked;

      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/area/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final area = jsonDecode(response.body);
        return Area.fromJson(area);
      } else {
        throw Exception(
          'status Code not 200: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Failed to update area: $e');
    }
  }


  bool _addAreaToParent(
    List<Map<String, dynamic>> areas,
    String parentName,
    Map<String, dynamic> newArea,
  ) {
    for (var area in areas) {
      if (area['name'] == parentName) {
        // Parent trouvé, ajouter la nouvelle area
        if (area['areas'] == null) {
          area['areas'] = <Map<String, dynamic>>[];
        }
        (area['areas'] as List<Map<String, dynamic>>).add(newArea);
        return true;
      }

      // Chercher récursivement dans les sous-areas
      if (area['areas'] != null && area['areas'] is List) {
        if (_addAreaToParent(
          (area['areas'] as List).cast<Map<String, dynamic>>(),
          parentName,
          newArea,
        )) {
          return true;
        }
      }
    }
    return false;
  }
}
