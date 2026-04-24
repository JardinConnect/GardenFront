import 'dart:convert';
import 'package:garden_connect/auth/utils/http_client.dart';
import 'package:garden_connect/settings/administration/models/system_metrics.dart';

class AdminRepository {
  final HttpClient _httpClient = HttpClient();

  Future<SystemMetrics> fetchSystemMetrics() async {
    try {
      final response = await _httpClient.get('/system/metrics');
      final responseData = jsonDecode(response.body);
      return SystemMetrics.fromJson(responseData);
    } catch (e) {
      throw Exception('Erreur lors de la récupération des métriques systèmes');
    }
  }

  Future<String?> fetchVpnAuthURL() async {
    try {
      final response = await _httpClient.get('/network/tailscale');
      final responseData = jsonDecode(response.body);
      return responseData['auth_url'] as String?;
    } catch (e) {
      throw Exception("Erreur lors de l'url d'authentification au VPN");
    }
  }
}