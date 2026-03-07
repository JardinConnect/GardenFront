import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../../auth/utils/http_client.dart';
import '../models/area.dart';

class AreaRepository {
  final HttpClient _client = HttpClient();

  Future<List<Area>> fetchAreas() async {
    try {
      final response = await _client.get('/area');
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
    String? parentId,
    bool isTracked = false,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'name': name,
        'color': color,
        'is_tracked': isTracked,
      };
      if (parentId != null) body['parent_id'] = parentId;

      final response = await _client.post('/area/', body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Area.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Zone parente introuvable');
      } else {
        throw Exception(
          'Erreur lors de la création: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Failed to create area: $e');
    }
  }

  Future<Area?> fetchAreaById(String id) async {
    try {

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
      final Map<String, dynamic> body = {};
      if (name != null) body['name'] = name;
      if (color != null) body['color'] = color.toARGB32().toRadixString(16);
      if (parentId != null) body['parent_id'] = parentId;
      if (isTracked != null) body['is_tracked'] = isTracked;

      final response = await _client.put('/area/$id', body: body);

      if (response.statusCode == 200) {
        return Area.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'status Code not 200: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Failed to update area: $e');
    }
  }


  Future<void> deleteArea(String areaId) async {
    try {
      final response = await _client.delete('/area/$areaId');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Zone introuvable');
      } else {
        throw Exception(
          'Erreur lors de la suppression: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Impossible de supprimer la zone: $e');
    }
  }
}
