

import 'dart:convert';

import 'package:garden_connect/farm-setup/models/network_info.dart';

import '../../auth/utils/http_client.dart';
import '../models/farm.dart';

class FarmRepository {
  final HttpClient _httpClient = HttpClient();


    Future<bool> addFarm(InitFarmDto farm) async {
      try {
        final response = await _httpClient.post(
          '/farm/setup',
          body: farm.toJson()
        );
        return response.statusCode == 201;
      } catch (e) {
        throw Exception('Failed to init Farm: $e');
      }
    }

    Future<bool> sendWifiConfiguration(String ssid, String password) async {
      try {
        final response = await _httpClient.post(
          '/network/connect',
          body: {'ssid': ssid,
            'password': password,
          },
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
        final response = await _httpClient.get(
            '/network/list'
        );
        late var responseData;
        if (response.statusCode == 200) {
          responseData = jsonDecode(response.body);
        }
        return responseData ?? [];
      } catch (e) {
        throw Exception('Failed to fetch Wi-Fi networks: $e');
      }
    }
}