import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:garden_connect/auth/utils/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthRepository {
  final HttpClient _httpClient = HttpClient();

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<User?> login(String email, String password) async {
    try {
      final response = await _httpClient.post(
        "/auth/login",
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String token = responseData['access_token'];
        String refreshToken = responseData['refresh_token'];
        User user = User.fromJson(responseData['user']);

        final prefs = await _prefs;
        await prefs.setString('auth_token', token);
        await prefs.setString('refresh_token', refreshToken);
        await prefs.setString('user', jsonEncode(user.toJson()));

        return User(
          id: user.id,
          email: user.email,
          firstName: user.firstName,
          lastName: user.lastName,
          phoneNumber: user.phoneNumber,
          createdAt: user.createdAt,
          updatedAt: user.updatedAt,
          token: user.token,
          role: user.role,
        );
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la connexion: $e');
      }
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await _prefs;
    await prefs.clear();
  }

  Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString('auth_token');
  }

  Future<String?> getRefreshToken() async {
    final prefs = await _prefs;
    return prefs.getString('refresh_token');
  }

  Future<bool> refreshAccessToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return false;

      var response = await _httpClient.post(
        "/auth/refresh-token",
        body: {'refresh_token': refreshToken},
        includeAuth: false,
      );

      if (response.statusCode == 404 || response.statusCode == 405) {
        response = await _httpClient.post(
          "/auth/refresh-token/",
          body: {'refresh_token': refreshToken},
          includeAuth: false,
        );
      }

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final prefs = await _prefs;
        await prefs.setString('auth_token', responseData['access_token']);
        await prefs.setString('refresh_token', responseData['refresh_token']);
        if (responseData['user'] != null) {
          await prefs.setString('user', jsonEncode(responseData['user']));
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<User?> getUser() async {
    final prefs = await _prefs;
    String? userUnformatted = prefs.getString('user');
    if (userUnformatted != null) {
      Map<String, dynamic> userMap = jsonDecode(userUnformatted);
      return User.fromJson(userMap);
    }
    return null;
  }
}
