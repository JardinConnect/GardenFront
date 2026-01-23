import 'package:garden_connect/settings/dashboard/models/settings.dart';

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
}
