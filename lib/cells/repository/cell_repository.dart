import 'package:garden_connect/cells/models/cell.dart';

class CellRepository {

  Future<List<Cell>> fetchCells() async {
    try {
      return _mockedCells();
    } catch(e) {
      throw Exception('Failed to load cells: $e');
    }
  }

  Future<Cell> fetchCellDetail(String id) async {
    try {
      return _mockedCellDetail();
    } catch(e) {
      throw Exception('Failed to load cell $id: $e');
    }
  }

  Future<void> changeCellTracking(String id, bool newTrackingValue) async {
  }

  Future<void> refreshCells() async {
  }

  Future<void> refreshCell(String id) async {
  }

  Future<void> updateCell(String id, String name, String? parentId) async {

  }

  // PUT /cells/settings
  Future<void> updateCellsSettings(List<String> ids, int dailyUpdateCount, int measurementFrequency, List<String> updateTimes) async {
  }

  Future<void> deleteCell(String id) async {

  }

  List<Cell> _mockedCells() {
    final mockedJson = List.empty(growable: true);

    for (int i = 0; i < 10; i++) {
      mockedJson.add({
        "id": (i + 1).toString(),
        "name": "Tomate Serre Nord $i",
        "battery": 67,
        "is_tracked": true,
        "last_update_at": "2026-01-09 09:46:26",
        "location": "Champ #1 > Parcelle #3 > Planche A", // TODO: à supprimer
        "parent_id": "3",
        "analytics": {
          "air_temperature": [
            {"value": 18, "occurred_at": "2025-11-05T08:00:00Z", "sensor_id": 12, "alert_status":  "ALERT"}
          ],
          "soil_temperature": [
            {"value": 15, "occurred_at": "2025-11-05T08:00:00Z", "sensor_id": 13, "alert_status":  "WARNING"}
          ],
          "air_humidity": [
            {"value": 65, "occurred_at": "2025-11-05T08:00:00Z", "sensor_id": 12, "alert_status":  "OK"}
          ],
          "soil_humidity": [
            {"value": 45, "occurred_at": "2025-11-05T08:00:00Z", "sensor_id": 12, "alert_status":  "WARNING"}
          ],
          "deep_soil_humidity": [
            {"value": 52, "occurred_at": "2025-11-05T08:00:00Z", "sensor_id": 12, "alert_status":  "OK"}
          ],
          "light": [
            {"value": 35, "occurred_at": "2025-11-05T08:00:00Z", "sensor_id": 12, "alert_status":  "ALERT"}
          ]
        }
      });
    }

    return mockedJson.map((cell) => Cell.fromJson(cell)).toList();
  }

  Cell _mockedCellDetail() {
    final json = {
      "id": "14",
      "name": "Tomate Serre Nord",
      "battery": 67,
      "is_tracked": true,
      "last_update_at": "2026-01-09 09:46:26",
      "location": "Champ #1 > Parcelle #3 > Planche A", // TODO: à supprimer
      "parent_id": "3",
      "analytics": {
        "air_temperature": [
          {
            "value": 18,
            "occurred_at": "2025-11-05T08:00:00Z",
            "sensor_id": 12,
            "alert_status":  "OK"
          },
          {
            "value": 20,
            "occurred_at": "2025-11-06T08:00:00Z",
            "sensor_id": 12,
            "alert_status":  "ALERT"
          },
          {
            "value": 19,
            "occurred_at": "2025-11-07T08:00:00Z",
            "sensor_id": 12,
            "alert_status":  "WARNING"
          }
        ],
        "soil_temperature": [
          {
            "value": 15,
            "occurred_at": "2025-11-05T08:00:00Z",
            "sensor_id": 12,
            "alert_status":  "WARNING"
          },
          {
            "value": 16,
            "occurred_at": "2025-11-06T08:00:00Z",
            "sensor_id": 12,
            "alert_status":  "ALERT"
          }
        ],
        "air_humidity": [
          {
            "value": 75,
            "occurred_at": "2025-11-09T08:00:00Z",
            "sensor_id": 12,
            "alert_status":  "OK"
          },
          {
            "value": 70,
            "occurred_at": "2025-11-10T08:00:00Z",
            "sensor_id": 12,
            "alert_status":  "ALERT"
          },
          {
            "value": 68,
            "occurred_at": "2025-11-11T08:00:00Z",
            "sensor_id": 12,
            "alert_status":  "OK"
          }
        ],
        "soil_humidity": [
          {
            "value": 50,
            "occurred_at": "2025-11-10T08:00:00Z",
            "sensor_id": 12,
            "alert_status":  "WARNING"
          },
          {
            "value": 48,
            "occurred_at": "2025-11-11T08:00:00Z",
            "sensor_id": 12,
            "alert_status":  "ALERT"
          }
        ],
        "deep_soil_humidity": [
          {
            "value": 55,
            "occurred_at": "2025-11-09T08:00:00Z",
            "sensor_id": 12,
            "alert_status":  "OK"
          },
          {
            "value": 65,
            "occurred_at": "2025-11-10T08:00:00Z",
            "sensor_id": 12,
            "alert_status":  "WARNING"
          },
          {
            "value": 48,
            "occurred_at": "2025-11-11T08:00:00Z",
            "sensor_id": 12,
            "alert_status":  "ALERT"
          }
        ],
        "light": [
          {
            "value": 38,
            "occurred_at": "2025-11-09T08:00:00Z",
            "sensor_id": 12,
            "alert_status":  "OK"
          },
          {
            "value": 41,
            "occurred_at": "2025-11-10T08:00:00Z",
            "sensor_id": 12,
            "alert_status":  "WARNING"
          },
          {
            "value": 34,
            "occurred_at": "2025-11-11T08:00:00Z",
            "sensor_id": 12,
            "alert_status":  "ALERT"
          }
        ]
      }
    };

    return Cell.fromJson(json);
  }
}