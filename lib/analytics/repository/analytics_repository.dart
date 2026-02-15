import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../analytics/models/analytics.dart';

class AnalyticsRepository {
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
      final storage = FlutterSecureStorage();

      String? token = await storage.read(key: 'auth_token');
      final DateTime now = DateTime.now();
      final DateTime oneYearAgo = now.subtract(const Duration(days: 365));

      String queryParams =
          '?start_date=${oneYearAgo.toIso8601String()}&end_date=${now.toIso8601String()}&skip=0&limit=100';

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/data/analytics/$queryParams'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
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
}
