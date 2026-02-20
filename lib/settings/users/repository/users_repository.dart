
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:garden_connect/auth/models/user.dart';
import 'package:http/http.dart' as http;

import '../../dashboard/models/settings.dart';

class UsersRepository {
  static const String baseUrl = 'http://127.0.0.1:8000';

  Future<List<User>> fetchUsers() async {
    try {
      final storage = FlutterSecureStorage();

      String? token = await storage.read(key: 'auth_token');
      final response = await http.get(
        Uri.parse('$baseUrl/users/?skip=0&limit=10'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },

      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final users = (responseData as List)
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
      final storage = FlutterSecureStorage();

      String? token = await storage.read(key: 'auth_token');
      final response = await http.post(
        Uri.parse('$baseUrl/users/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body:  jsonEncode(user.toJson()),
      );
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
      final storage = FlutterSecureStorage();

      String? token = await storage.read(key: 'auth_token');
      final response = await http.put(
        Uri.parse('$baseUrl/users/${user.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(user.toJson()),
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
      final storage = FlutterSecureStorage();

      String? token = await storage.read(key: 'auth_token');
      final response = await http.delete(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return 'Utilisateur supprimé avec succès';
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  Future<List<Log>> fetchLogs() async {
    try {
      var response = {
        "logs": [

          {"user_id": "ca12b1cf-1bbe-43af-b2c1-23cc7f2375ad", "value": "Gaëtan se_connecte au_portail"},
          {"user_id": "ca12b1cf-1bbe-43af-b2c1-23cc7f2375ad", "value": "Gaëtan synchronise Capteurs"},
          {"user_id": "ca12b1cf-1bbe-43af-b2c1-23cc7f2375ad", "value": "Gaëtan modifie seuil_température"},
          {"user_id": "ca12b1cf-1bbe-43af-b2c1-23cc7f2375ad", "value": "Gaëtan consulte historique_alertes"},
          {"user_id": "e38b664d-7bef-4f1d-8a42-3e40171fb56f", "value": "Fanny pairing capteur#23"},
          {"user_id": "e38b664d-7bef-4f1d-8a42-3e40171fb56f", "value": "Fanny met_à_jour le_tableau_de_bord"},
          {"user_id": "e38b664d-7bef-4f1d-8a42-3e40171fb56f", "value": "Fanny supprime Zone_Sud"},
          {"user_id": "e38b664d-7bef-4f1d-8a42-3e40171fb56f", "value": "Fanny réactive capteur#02"},
          {"user_id": "e38b664d-7bef-4f1d-8a42-3e40171fb56f", "value": "Fanny exporte dashboard"},
          {"user_id": "92d2a877-a6d5-4feb-9cd6-78ca1465ce65", "value": "Marie modifie Alerte-12"},
          {"user_id": "92d2a877-a6d5-4feb-9cd6-78ca1465ce65", "value": "Marie associe le_capteur#03 à Zone_B"},
          {"user_id": "92d2a877-a6d5-4feb-9cd6-78ca1465ce65", "value": "Marie dissocie le_capteur#02 à Zone_A"},
          {"user_id": "a821dbfb-5d59-4f72-9664-b57ce7c6b26f", "value": "Guy consulte Espace_2"},
          {"user_id": "a821dbfb-5d59-4f72-9664-b57ce7c6b26f", "value": "Guy ajoute alerte_gel_nocturne"},
          {"user_id": "a821dbfb-5d59-4f72-9664-b57ce7c6b26f", "value": "Guy supprime alerte_humidité"},
        ],
      };
      return Logs.fromJson(response).logs;
    } catch (e) {
      throw Exception('Failed to load logs: $e');
    }
  }

  Future<List<Log>> fetchLogsByUser(userId) async {
    try {
      var response = {
        "logs": [
          {"user_id": "ca12b1cf-1bbe-43af-b2c1-23cc7f2375ad", "value": "Gaëtan se_connecte au_portail"},
          {"user_id": "ca12b1cf-1bbe-43af-b2c1-23cc7f2375ad", "value": "Gaëtan synchronise Capteurs"},
          {"user_id": "ca12b1cf-1bbe-43af-b2c1-23cc7f2375ad", "value": "Gaëtan modifie seuil_température"},
          {"user_id": "ca12b1cf-1bbe-43af-b2c1-23cc7f2375ad", "value": "Gaëtan consulte historique_alertes"},
          {"user_id": "e38b664d-7bef-4f1d-8a42-3e40171fb56f", "value": "Fanny pairing capteur#23"},
          {"user_id": "e38b664d-7bef-4f1d-8a42-3e40171fb56f", "value": "Fanny met_à_jour le_tableau_de_bord"},
          {"user_id": "e38b664d-7bef-4f1d-8a42-3e40171fb56f", "value": "Fanny supprime Zone_Sud"},
          {"user_id": "e38b664d-7bef-4f1d-8a42-3e40171fb56f", "value": "Fanny réactive capteur#02"},
          {"user_id": "e38b664d-7bef-4f1d-8a42-3e40171fb56f", "value": "Fanny exporte dashboard"},
          {"user_id": "92d2a877-a6d5-4feb-9cd6-78ca1465ce65", "value": "Marie modifie Alerte-12"},
          {"user_id": "92d2a877-a6d5-4feb-9cd6-78ca1465ce65", "value": "Marie associe le_capteur#03 à Zone_B"},
          {"user_id": "92d2a877-a6d5-4feb-9cd6-78ca1465ce65", "value": "Marie dissocie le_capteur#02 à Zone_A"},
          {"user_id": "a821dbfb-5d59-4f72-9664-b57ce7c6b26f", "value": "Guy consulte Espace_2"},
          {"user_id": "a821dbfb-5d59-4f72-9664-b57ce7c6b26f", "value": "Guy ajoute alerte_gel_nocturne"},
          {"user_id": "a821dbfb-5d59-4f72-9664-b57ce7c6b26f", "value": "Guy supprime alerte_humidité"},
        ],
      };
      final logs = Logs.fromJson(response).logs;

      return logs
          .where((log) => log.userId == userId)
          .toList();
    } catch (e) {
      throw Exception('Failed to load logs: $e');
    }
  }

}