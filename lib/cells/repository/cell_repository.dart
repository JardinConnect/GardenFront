import 'package:garden_connect/cells/models/cell.dart';

class CellRepository {

  Future<List<Cell>> fetchCells() async {
    try {
      return _mockedCells();
    } catch(e) {
      throw Exception('Failed to load cells: $e');
    }
  }

  Future<void> refreshCells() async {
  }

  List<Cell> _mockedCells() {
    final mockedJson = List.empty(growable: true);

    for (int i = 0; i < 10; i++) {
      mockedJson.add({
        "name": "Tomate Serre Nord $i",
        "battery": 67,
        "analytics": {
          "air_temperature": {"value": 18, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "12"},
          "soil_temperature": {"value": 15, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "12"},
          "air_humidity": {"value": 65, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "12"},
          "soil_humidity": {"value": 45, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "12"},
          "light": {"value": 35, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "12"},
        },
      });
    }

    return mockedJson.map((cell) => Cell.fromJson(cell)).toList();
  }
}