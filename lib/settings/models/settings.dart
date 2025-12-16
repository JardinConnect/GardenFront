
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