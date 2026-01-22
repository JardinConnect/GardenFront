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

Logs _$LogsFromJson(Map<String, dynamic> json) => Logs(
  logs: (json['logs'] as List<dynamic>).map((e) => e as String).toList(),
);
