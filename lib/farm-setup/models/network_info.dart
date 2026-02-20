import 'package:json_annotation/json_annotation.dart';

part 'network_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NetworkInfo {
  final String ssid;
  final int signal;
  final String security;
  final int? frequency;
  final int? channel;
  final String? bssid;

  NetworkInfo({
    required this.ssid,
    required this.signal,
    required this.security,
    this.frequency,
    this.channel,
    this.bssid,
  });

  factory NetworkInfo.fromJson(Map<String, dynamic> json) => _$NetworkInfoFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkInfoToJson(this);
}