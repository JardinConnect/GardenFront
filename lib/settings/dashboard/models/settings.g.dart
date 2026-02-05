// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
  settings:
      (json['settings'] as List<dynamic>)
          .map((e) => Setting.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Setting _$SettingFromJson(Map<String, dynamic> json) => Setting(
  setting: $enumDecode(_$SettingTypeEnumMap, json['setting']),
  value: json['value'] as bool,
);

const _$SettingTypeEnumMap = {
  SettingType.showHelpBubbles: 'showHelpBubbles',
  SettingType.showDisconnectedCells: 'showDisconnectedCells',
  SettingType.showAlertThresholds: 'showAlertThresholds',
  SettingType.allowAlertsModification: 'allowAlertsModification',
  SettingType.silentNightMode: 'silentNightMode',
  SettingType.allowCellsRenaming: 'allowCellsRenaming',
  SettingType.allowCellsDeletion: 'allowCellsDeletion',
  SettingType.allowCellsMoving: 'allowCellsMoving',
  SettingType.showCellsBatteryLevel: 'showCellsBatteryLevel',
  SettingType.showEmptyAreas: 'showEmptyAreas',
  SettingType.allowAreaMoving: 'allowAreaMoving',
  SettingType.allowAreaRenaming: 'allowAreaRenaming',
  SettingType.allowAreaDeletion: 'allowAreaDeletion',
};

Log _$LogFromJson(Map<String, dynamic> json) =>
    Log(userId: json['user_id'] as String, value: json['value'] as String);

Logs _$LogsFromJson(Map<String, dynamic> json) => Logs(
  logs:
      (json['logs'] as List<dynamic>)
          .map((e) => Log.fromJson(e as Map<String, dynamic>))
          .toList(),
);
