import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:garden_connect/auth/models/user.dart';
import 'package:garden_connect/settings/models/settings.dart';
import 'package:http/http.dart' as http;

class SettingsRepository {
  static const String baseUrl = 'http://127.0.0.1:8000';
  Future<Settings> fetchSettings() async {
    try {
      var response = {
        "settings": [
          {"setting": "showHelpBubbles", "value": true},
          {"setting": "showDisconnectedCells", "value": false},
          {"setting": "showAlertThresholds", "value": true},
          {"setting": "allowAlertsModification", "value": true},
          {"setting": "silentNightMode", "value": false},
          {"setting": "allowCellsRenaming", "value": true},
          {"setting": "allowCellsDeletion", "value": false},
          {"setting": "allowCellsMoving", "value": true},
          {"setting": "showCellsBatteryLevel", "value": true},
          {"setting": "showEmptyAreas", "value": false},
          {"setting": "allowAreaMoving", "value": true},
          {"setting": "allowAreaRenaming", "value": true},
          {"setting": "allowAreaDeletion", "value": false},
        ],
      };
      return Settings.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load settings: $e');
    }
  }

  Future<Logs> fetchLogs() async {
    try {
      var response = {
        "logs": [
          "Gaëtan se_connecte au_portail",
          "Fanny pairing capteur#23",
          "Marie modifie Alerte-12",
          "Guy consulte Espace_2",
          "Gaëtan synchronise Capteurs",
          'Fanny met_à_jour le_tableau_de_bord',
          'Fanny supprime Zone_Sud',
          'Fanny réactive capteur#02',
          'Gaëtan désactive capteur#01',
          'Marie associe le_capteur#03 à Zone_B',
          'Marie dissocie le_capteur#02 à Zone_A',
          'Fanny exporte dashboard',
          "Marie télécharge le_rapport_mensuel",
          'Fanny affiche le_statut_des_capteurs',
          'Marie duplique le_plan_standard',
          'Fanny ajoute_surveillance capteur#12',
          'Fanny synchronise Capteurs',
          'Guy ajoute alerte_gel_nocturne',
        ],
      };
      return Logs.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load logs: $e');
    }
  }

  Future<List<User>?> fetchUsers() async {
    try {

      final storage = FlutterSecureStorage();

  // Récupérer le token stocké
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
        return null;
      }
    } catch (e) {
      print('Erreur lors de la connexion: $e');
      return null;
    }
  }
}
