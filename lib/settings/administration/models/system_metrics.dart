import 'package:json_annotation/json_annotation.dart';

part 'system_metrics.g.dart';


@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class SystemMetrics {
  final int cpuTemp;
  final int cpuUsage;
  final int ramUsage;
  final int ramTotal;
  final int diskUsage;
  final int diskTotal;

  SystemMetrics({
    required this.cpuTemp,
    required this.cpuUsage,
    required this.ramTotal,
    required this.ramUsage,
    required this.diskTotal,
    required this.diskUsage,
  });

  factory SystemMetrics.fromJson(Map<String, dynamic> json) => _$SystemMetricsFromJson(json);
}
