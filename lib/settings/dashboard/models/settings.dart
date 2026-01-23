
import 'package:json_annotation/json_annotation.dart';

part "settings.g.dart";

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Settings {
  final List<Setting> settings;

  Settings({
    required this.settings,
  });

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
}



@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Setting {
  final SettingType setting;
  bool value;
  Setting({
    required this.setting,
    required this.value,
  });
  factory Setting.fromJson(Map<String, dynamic> json) =>
      _$SettingFromJson(json);
}


enum SettingType {
  showHelpBubbles,
  showDisconnectedCells,
  showAlertThresholds,
  allowAlertsModification,
  silentNightMode,
  allowCellsRenaming,
  allowCellsDeletion,
  allowCellsMoving,
  showCellsBatteryLevel,
  showEmptyAreas,
  allowAreaMoving,
  allowAreaRenaming,
  allowAreaDeletion;


  String get categoryName{
    switch (this) {
      case SettingType.showHelpBubbles:
        return 'General';
      case SettingType.showAlertThresholds ||SettingType.allowAlertsModification || SettingType.silentNightMode || SettingType.allowCellsRenaming || SettingType.allowCellsDeletion:
        return 'Notifications et alertes';
      case SettingType.showDisconnectedCells || SettingType.allowCellsMoving || SettingType.showCellsBatteryLevel:
        return 'Gestion des cellules';
      case SettingType.showEmptyAreas || SettingType.allowAreaMoving || SettingType.allowAreaRenaming || SettingType.allowAreaDeletion:
        return 'Gestion des espaces';
    }
  }

  String get name {
    switch (this) {
      case SettingType.showHelpBubbles:
        return 'Afficher les bulles d’aide contextuelles';
      case SettingType.showDisconnectedCells:
        return 'Afficher les cellules déconnectées';
      case SettingType.showAlertThresholds:
        return 'Afficher les seuils d’alerte sur les graphiques';
      case SettingType.allowAlertsModification:
        return 'Autoriser la modification des alertes';
      case SettingType.silentNightMode:
        return 'Mode silencieux nocturne';
      case SettingType.allowCellsRenaming:
        return 'Autoriser le renommage des cellules';
      case SettingType.allowCellsDeletion:
        return 'Autoriser la suppression des cellules';
      case SettingType.allowCellsMoving:
        return 'Autoriser le déplacement des cellules entre les espaces';
      case SettingType.showCellsBatteryLevel:
        return 'Afficher le niveau de batterie des cellules';
      case SettingType.showEmptyAreas:
        return 'Afficher les espaces vides';
      case SettingType.allowAreaMoving:
        return 'Autoriser le déplacement des espaces';
      case SettingType.allowAreaRenaming:
        return 'Autoriser le renommage des espaces';
      case SettingType.allowAreaDeletion:
        return 'Autoriser la suppression des espaces';
    }
  }
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Log{
  final String userId;
  final String value;

  Log({
    required this.userId,
    required this.value,
  });

  factory Log.fromJson(Map<String, dynamic> json) =>
      _$LogFromJson(json);
}
@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Logs {
  final List<Log> logs;

  Logs({
    required this.logs,
  });

  factory Logs.fromJson(Map<String, dynamic> json) =>
      _$LogsFromJson(json);
}