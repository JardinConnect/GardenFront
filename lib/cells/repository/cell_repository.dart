import 'dart:convert';

import 'package:garden_connect/auth/utils/http_client.dart';
import 'package:garden_connect/cells/models/cell.dart';

class CellRepository {
  final HttpClient _httpClient = HttpClient();

  Future<List<Cell>> fetchCells() async {
    try {
      final response = await _httpClient.get('/cell');
      final responseData = jsonDecode(response.body);
      final cells =
          (responseData as List).map((cell) => Cell.fromJson(cell)).toList();
      return cells;
    } catch (e) {
      throw Exception('Erreur lors du chargement des cellules');
    }
  }

  Future<Cell> fetchCellDetail(String id) async {
    try {
      final response = await _httpClient.get('/cell/$id');
      final responseData = jsonDecode(response.body);
      return Cell.fromJson(responseData);
    } catch (e) {
      throw Exception('Erreur lors du chargement de la cellule');
    }
  }

  Future<void> refreshCell(String id) async {}

  Future<void> updateCell(
    String id,
    String name,
    bool isTracked,
    String? parentId,
  ) async {
    try {
      await _httpClient.put(
        '/cell/$id',
        body: {'name': name, 'is_tracked': isTracked, 'area_id': parentId},
      );
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la cellule');
    }
  }

  // PUT /cells/settings
  Future<void> updateCellsSettings(
    List<String> ids,
    int dailyUpdateCount,
    int measurementFrequency,
    List<String> updateTimes,
  ) async {
    try {
      final response = await _httpClient.put(
        '/cell/settings',
        body: {
          'cell_ids': ids,
          'daily_update_count': dailyUpdateCount,
          'measurement_frequency': measurementFrequency,
          'update_times': updateTimes,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception();
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour des paramètres des cellules');
    }
  }

  Future<void> deleteCell(String id) async {
    try {
      await _httpClient.delete('/cell/$id');
    } catch (e) {
      throw Exception('Erreur lors de la suppression de la cellule');
    }
  }
}
