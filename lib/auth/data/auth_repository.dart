import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';

class AuthRepository {
  static const String baseUrl = 'http://127.0.0.1:8000';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<User?> login(String email, String password) async {
    try {
      // final response = await http.post(
      //   Uri.parse('$baseUrl/login'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({'email': email, 'password': password}),
      // );

      // if (response.statusCode == 200) {
      //   final responseData = jsonDecode(response.body);
      //   String token = responseData['access_token'];
        User user = User.fromJson({
          'id': '1',
          'email': 'sam@garden.com',
          'first_name': 'Sam',
          'last_name': 'Garden',
          'phone_number': '0201920192',
          'token': 'dummy_token_123456',
          'role':'employee'
        });

        // await _secureStorage.write(key: 'auth_token', value: token);
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
          token: 'dummy_token_123456',
          role: user.role,
        );
      // } else {
      //   return null;
      // }
    } catch (e) {
      print('Erreur lors de la connexion: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await _secureStorage.deleteAll();
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
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
