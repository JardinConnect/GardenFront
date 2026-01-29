import '../../analytics/models/analytics.dart';

class BaseItem {
  final int id;
  final String name;
  final Analytics analytics;

  BaseItem({
    required this.id,
    required this.name,
    required this.analytics,
  });
}