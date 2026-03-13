import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:garden_connect/auth/models/user.dart';
import 'package:garden_connect/auth/utils/http_client.dart';

import '../../dashboard/models/settings.dart';

class UsersRepository {
  final HttpClient _httpClient = HttpClient();

  Future<List<User>> fetchUsers() async {
    try {
      final response = await _httpClient.get('/user/?skip=0&limit=10');
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final users =
            (responseData as List)
                .map((userJson) => User.fromJson(userJson))
                .toList();
        return users;
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la connexion: $e');
      }
      return [];
    }
  }

  Future<User> addUser(UserAddDto user) async {
    try {
      final response = await _httpClient.post('/user', body: user.toJson());
      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return User.fromJson(responseData);
      } else {
        throw Exception('Failed to add user');
      }
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  Future<User> updateUser(User user) async {
    try {
      final response = await _httpClient.put(
        '/user/${user.id}',
        body: user.toJson(),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return User.fromJson(responseData);
      } else {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<String> deleteUser(String userId) async {
    try {
      final response = await _httpClient.delete('/user/$userId');
      if (response.statusCode == 200) {
        return 'Utilisateur supprimé avec succès';
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  Future<List<Log?>> fetchLogs() async {
    try {
      final response = await _httpClient.get('/action-logs');
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        return Logs.fromJson(responseData).data;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to load logs: $e');
    }
  }

  Future<List<Log?>> fetchLogsByUser(userId) async {
    try {
      final response = await _httpClient.get('/action-logs/?user_id=$userId');
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Logs.fromJson(responseData).data;
      }  else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to load logs: $e');
    }
  }
}
