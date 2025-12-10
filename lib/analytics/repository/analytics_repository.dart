import '../../analytics/models/analytics.dart';

class AnalyticsRepository {
  Future<Analytics> fetchAnalytics() async {
    // TODO call API route to fetch analytics data
    try {
      var response = {
        "air_temperature": [
          {"value": 18, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "12"},
          {"value": 20, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "12"},
          {"value": 19, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "12"},
          {"value": 21, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "12"},
          {"value": 22, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "12"},
          {"value": 20, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "12"},
          {"value": 34, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "12"},
        ],
        "soil_temperature": [
          {"value": 15, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "12"},
          {"value": 16, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "12"},
          {"value": 15, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "12"},
          {"value": 17, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "12"},
          {"value": 18, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "12"},
          {"value": 16, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "12"},
          {"value": 15, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "12"},
        ],
        "air_humidity": [
          {"value": 65, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "12"},
          {"value": 70, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "12"},
          {"value": 68, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "12"},
          {"value": 72, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "12"},
          {"value": 75, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "12"},
          {"value": 70, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "12"},
          {"value": 68, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "12"},
        ],
        "soil_humidity": [
          {"value": 45, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "12"},
          {"value": 50, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "12"},
          {"value": 48, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "12"},
          {"value": 52, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "12"},
          {"value": 55, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "12"},
          {"value": 50, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "12"},
          {"value": 48, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "12"},
        ],
        "light": [
          {"value": 35, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "12"},
          {"value": 40, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "12"},
          {"value": 32, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "12"},
          {"value": 45, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "12"},
          {"value": 38, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "12"},
          {"value": 41, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "12"},
          {"value": 34, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "12"},
        ],
      };
      return Analytics.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load analytics: $e');
    }
  }
}
