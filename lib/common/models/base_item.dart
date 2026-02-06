import '../../analytics/models/analytics.dart';

class BaseItem {
  final int id;
  final String name;
  final Analytics analytics;
  int? parentId;

  BaseItem({
    required this.id,
    required this.name,
    required this.analytics,
    this.parentId
  });
}