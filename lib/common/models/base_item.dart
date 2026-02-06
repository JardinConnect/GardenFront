import '../../analytics/models/analytics.dart';

class BaseItem {
  final String id;
  final String name;
  final Analytics analytics;
  String? parentId;
  final bool isTracked;

  BaseItem({
    required this.id,
    required this.name,
    required this.analytics,
    this.parentId,
    this.isTracked = false,
  });
}
