import 'dart:ui';
import 'package:json_annotation/json_annotation.dart';
import 'package:garden_ui/ui/design_system.dart';


enum AnalyticAlertStatus {
  @JsonValue("OK") ok,
  @JsonValue("WARNING") warning,
  @JsonValue("ALERT") alert;

  Color get color {
    switch(this) {
      case AnalyticAlertStatus.ok:
        return GardenColors.tertiary.shade500;
      case AnalyticAlertStatus.warning:
        return GardenColors.yellowWarning.shade500;
      case AnalyticAlertStatus.alert:
        return GardenColors.redAlert.shade500;
    }
  }
}