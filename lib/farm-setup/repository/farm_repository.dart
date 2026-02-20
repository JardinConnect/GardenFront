

import 'dart:convert';

import 'package:garden_connect/farm-setup/models/network_info.dart';

import '../models/farm.dart';
import 'package:http/http.dart' as http;

class FarmRepository {
  static const String baseUrl = 'http://127.0.0.1:8000';


    Future<void> addFarm(Farm farm) async {
      await Future.delayed(const Duration(seconds: 1));
    }

    Future<bool> sendWifiConfiguration(String ssid, String password) async {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/network/connect'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: jsonEncode({
            'ssid': ssid,
            'password': password,
          }),
        );
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          return responseData['success'] ?? false;
        } else {
          throw Exception('Failed to connect to Wi-Fi: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Failed to connect to Wi-Fi: $e');
      }
    }

    Future<List<NetworkInfo>> getWifiList() async {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/network/list'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
        );
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          return responseData ?? [];
        } else {
          throw Exception('Failed to fetch Wi-Fi networks: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Failed to fetch Wi-Fi networks: $e');
      }
    }
}