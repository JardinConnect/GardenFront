import 'dart:convert';
import 'dart:math';
import 'package:garden_connect/auth/utils/http_client.dart';

import '../../analytics/models/analytics.dart';
import '../../alerts/models/alert_models.dart';

class AnalyticsRepository {
  final HttpClient _httpClient = HttpClient();

  Future<Analytics> fetchMockedAnalytics() async {
    // TODO call API route to fetch analytics data
    try {
      final random = Random();
      final now = DateTime.now();

      // Générateur de statut d'alerte aléatoire avec probabilités
      String getRandomAlertStatus() {
        final value = random.nextInt(1000); // Sur 1000 au lieu de 100
        if (value < 950) return "OK"; // 95% OK
        if (value < 980) return "WARNING"; // 3% WARNING
        return "ALERT"; // 2% ALERT
      }

      // Générer les données pour 365 jours
      List<Map<String, dynamic>> generateAnalyticsForDays(
        double baseValue,
        double variation,
      ) {
        return List.generate(365, (index) {
          final date = now.subtract(Duration(days: 365 - index));
          // Ajouter plusieurs mesures par jour (par exemple 4 mesures espacées de 6h)
          return List.generate(4, (hourIndex) {
            final measureDate = date.add(Duration(hours: hourIndex * 6));
            return {
              "value":
                  (baseValue +
                          (random.nextDouble() * variation * 2 - variation))
                      .toDouble(),
              "occurred_at": measureDate.toIso8601String(),
              "sensor_id": 12,
              "alert_status": getRandomAlertStatus(),
            };
          });
        }).expand((element) => element).toList();
      }

      var response = {
        "air_temperature": generateAnalyticsForDays(20.0, 5.0),
        "soil_temperature": generateAnalyticsForDays(16.0, 3.0),
        "air_humidity": generateAnalyticsForDays(70.0, 10.0),
        "soil_humidity": generateAnalyticsForDays(50.0, 8.0),
        "deep_soil_humidity": generateAnalyticsForDays(52.0, 7.0),
        "light": generateAnalyticsForDays(38.0, 12.0),
      };

      return Analytics.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load analytics: $e');
    }
  }

  Future<Analytics> fetchAnalytics() async {
    try {
      final DateTime now = DateTime.now();
      final DateTime oneYearAgo = now.subtract(const Duration(days: 365));

      String queryParams =
          '?start_date=${oneYearAgo.toIso8601String()}&end_date=${now.toIso8601String()}';
      final response = await _httpClient.get(
        "/data/analytics/$queryParams",
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Analytics.fromJson(responseData['data']);
      } else {
        throw Exception(
          'Failed to load analytics: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load analytics: $e');
    }
  }

  Future<Analytics> fetchActivityAnalytics() async {
    try {
      final DateTime now = DateTime.now();
      final DateTime oneYearAgo = now.subtract(const Duration(days: 365));

      final alertEvents = await _fetchAlertEvents(oneYearAgo, now);
      if (alertEvents.isEmpty) {
        return Analytics();
      }

      final analyticsRequests = _buildAnalyticsRequests(alertEvents);
      final analyticsResults = <Analytics>[];

      for (final request in analyticsRequests) {
        final analytics = await _fetchAnalyticsForRequest(request);
        analyticsResults.add(analytics);
      }

      return _mergeAnalytics(analyticsResults);
    } catch (e) {
      throw Exception('Failed to load analytics: $e');
    }
  }

  Future<List<AlertEvent>> _fetchAlertEvents(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final query = Uri(queryParameters: {
      'start_date': _formatApiDateTime(startDate),
      'end_date': _formatApiDateTime(endDate),
    }).query;

    final response = await _httpClient.get("/alert/events/?$query");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return (jsonData as List)
          .map((json) => AlertEvent.fromJson(json))
          .toList();
    }

    throw Exception(
      'Failed to load alert events: ${response.statusCode} ${response.reasonPhrase}',
    );
  }

  List<_AnalyticsRequest> _buildAnalyticsRequests(List<AlertEvent> events) {
    final Map<String, AlertEvent> uniqueEvents = {};

    for (final event in events) {
      final dayKey =
          '${event.timestamp.year}-${event.timestamp.month}-${event.timestamp.day}';
      final key = '$dayKey|${event.sensorTypeRaw}|${event.cellId}';
      uniqueEvents.putIfAbsent(key, () => event);
    }

    return uniqueEvents.values.map((event) {
      final startDate = event.timestamp.subtract(const Duration(seconds: 1));
      final endDate = event.timestamp.add(const Duration(seconds: 1));

      return _AnalyticsRequest(
        startDate: startDate,
        endDate: endDate,
        analyticType: event.sensorTypeRaw,
        cellId: event.cellId,
      );
    }).toList();
  }

  Future<Analytics> _fetchAnalyticsForRequest(
    _AnalyticsRequest request,
  ) async {
    final query = Uri(queryParameters: {
      'start_date': _formatApiDateTime(request.startDate),
      'end_date': _formatApiDateTime(request.endDate),
      'analytic_type': request.analyticType,
      'cell_id': request.cellId,
      'skip': '0',
      'limit': '100',
    }).query;

    final response = await _httpClient.get("/data/analytics?$query");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return Analytics.fromJson(responseData['data']);
    }

    throw Exception(
      'Failed to load analytics: ${response.statusCode} ${response.reasonPhrase}',
    );
  }

  Analytics _mergeAnalytics(List<Analytics> analyticsList) {
    final airTemperature = <AirTemperatureAnalytic>[];
    final soilTemperature = <SoilTemperatureAnalytic>[];
    final airHumidity = <AirHumidityAnalytic>[];
    final soilHumidity = <SoilHumidityAnalytic>[];
    final deepSoilHumidity = <DeepSoilHumidityAnalytic>[];
    final light = <LightAnalytic>[];
    final battery = <BatteryAnalytic>[];

    for (final analytics in analyticsList) {
      airTemperature.addAll(analytics.airTemperature ?? []);
      soilTemperature.addAll(analytics.soilTemperature ?? []);
      airHumidity.addAll(analytics.airHumidity ?? []);
      soilHumidity.addAll(analytics.soilHumidity ?? []);
      deepSoilHumidity.addAll(analytics.deepSoilHumidity ?? []);
      light.addAll(analytics.light ?? []);
      battery.addAll(analytics.battery ?? []);
    }

    return Analytics(
      airTemperature: airTemperature,
      soilTemperature: soilTemperature,
      airHumidity: airHumidity,
      soilHumidity: soilHumidity,
      deepSoilHumidity: deepSoilHumidity,
      light: light,
      battery: battery,
    );
  }
}

class _AnalyticsRequest {
  final DateTime startDate;
  final DateTime endDate;
  final String analyticType;
  final String cellId;

  const _AnalyticsRequest({
    required this.startDate,
    required this.endDate,
    required this.analyticType,
    required this.cellId,
  });
}

String _formatApiDateTime(DateTime dateTime) {
  // L'API attend un ISO local avec microsecondes (ex: 2026-03-19T08:13:49.180248).
  return dateTime.toIso8601String();
}
