import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';

class AuthRepository {
  static const String baseUrl = 'http://127.0.0.1:8000';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String token = responseData['access_token'];
        String refreshToken = responseData['refresh_token'];
        User user = User.fromJson(responseData['user']);

        await _secureStorage.write(key: 'auth_token', value: token);
        await _secureStorage.write(key: 'refresh_token', value: refreshToken);
        await _secureStorage.write(
          key: 'user',
          value: jsonEncode(user.toJson()),
        );

        return User(
          id: user.id,
          email: user.email,
          firstName: user.firstName,
          lastName: user.lastName,
          phoneNumber: user.phoneNumber,
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
    await _secureStorage.deleteAll();
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh_token');
  }

  Future<bool> refreshAccessToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/refresh-token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        await _secureStorage.write(key: 'auth_token', value: responseData['access_token']);
        await _secureStorage.write(key: 'refresh_token', value: responseData['refresh_token']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<User?> getUser() async {
    String? userUnformatted = await _secureStorage.read(key: 'user');
    if (userUnformatted != null) {
      Map<String, dynamic> userMap = jsonDecode(userUnformatted);
      return User.fromJson(userMap);
    }
    return null;
  }
}
