import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:garden_connect/cells/models/cell.dart';
import 'package:http/http.dart' as http;

class CellRepository {
  Future<List<Cell>> fetchCells() async {
    try {
      final storage = FlutterSecureStorage();

      String? token = await storage.read(key: 'auth_token');
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/cell'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final cells =
            (responseData as List).map((cell) => Cell.fromJson(cell)).toList();
        return cells;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to load cells: $e');
    }
  }

  Future<Cell> fetchCellDetail(String id) async {
    try {
      final storage = FlutterSecureStorage();

      String? token = await storage.read(key: 'auth_token');
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/cell/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Cell.fromJson(responseData);
      } else {
        throw Exception(
          'Failed to load cell $id: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load cell $id: $e');
    }
  }

  Future<void> changeCellTracking(String id, bool newTrackingValue) async {}

  Future<void> refreshCells() async {}

  Future<void> refreshCell(String id) async {}

  Future<void> updateCell(String id, String name, String? parentId) async {}

  // PUT /cells/settings
  Future<void> updateCellsSettings(
    List<String> ids,
    int dailyUpdateCount,
    int measurementFrequency,
    List<String> updateTimes,
  ) async {}

  Future<void> deleteCell(String id) async {}


}
