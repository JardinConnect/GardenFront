import '../../analytics/models/analytics.dart';

class AnalyticsRepository {
  Future<Analytics> fetchAnalytics() async {
    // TODO call API route to fetch analytics data
    try {
      var response = {
        "air_temperature": [
          {"value": 18, "occurred_at": "2025-11-05T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 20, "occurred_at": "2025-11-06T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 19, "occurred_at": "2025-11-07T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 21, "occurred_at": "2025-11-08T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 22, "occurred_at": "2025-11-09T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 20, "occurred_at": "2025-11-10T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 34, "occurred_at": "2025-11-11T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
        ],
        "soil_temperature": [
          {"value": 15, "occurred_at": "2025-11-05T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 16, "occurred_at": "2025-11-06T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 15, "occurred_at": "2025-11-07T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 17, "occurred_at": "2025-11-08T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 18, "occurred_at": "2025-11-09T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 16, "occurred_at": "2025-11-10T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 15, "occurred_at": "2025-11-11T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
        ],
        "air_humidity": [
          {"value": 65, "occurred_at": "2025-11-05T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 70, "occurred_at": "2025-11-06T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 68, "occurred_at": "2025-11-07T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 72, "occurred_at": "2025-11-08T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 75, "occurred_at": "2025-11-09T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 70, "occurred_at": "2025-11-10T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 68, "occurred_at": "2025-11-11T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
        ],
        "soil_humidity": [
          {"value": 45, "occurred_at": "2025-11-05T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 50, "occurred_at": "2025-11-06T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 48, "occurred_at": "2025-11-07T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 52, "occurred_at": "2025-11-08T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 55, "occurred_at": "2025-11-09T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 50, "occurred_at": "2025-11-10T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 48, "occurred_at": "2025-11-11T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
        ],
        "deep_soil_humidity": [
          {"value": 52, "occurred_at": "2025-11-05T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 34, "occurred_at": "2025-11-06T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 48, "occurred_at": "2025-11-07T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 52, "occurred_at": "2025-11-08T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 55, "occurred_at": "2025-11-09T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 65, "occurred_at": "2025-11-10T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 48, "occurred_at": "2025-11-11T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
        ],
        "light": [
          {"value": 35, "occurred_at": "2025-11-05T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 40, "occurred_at": "2025-11-06T08:00:00Z", "sensor_id": 12, "alert_status": "ALERT"},
          {"value": 32, "occurred_at": "2025-11-07T08:00:00Z", "sensor_id": 12, "alert_status": "WARNING"},
          {"value": 45, "occurred_at": "2025-11-08T08:00:00Z", "sensor_id": 12, "alert_status": "WARNING"},
          {"value": 38, "occurred_at": "2025-11-09T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
          {"value": 41, "occurred_at": "2025-11-10T08:00:00Z", "sensor_id": 12, "alert_status": "ALERT"},
          {"value": 34, "occurred_at": "2025-11-11T08:00:00Z", "sensor_id": 12, "alert_status": "OK"},
        ],
      };
      return Analytics.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load analytics: $e');
    }
  }
}
