// area_event.dart
part of 'area_bloc.dart';

@immutable
sealed class AreaEvent {}

final class LoadAreas extends AreaEvent {}

final class SelectArea extends AreaEvent {
  final Area area;

  SelectArea(this.area);
}

final class SelectCell extends AreaEvent {
  final Cell cell;
  final Area parentArea;

  SelectCell(this.cell, this.parentArea);
}

final class ClearSelection extends AreaEvent {}

final class AddArea extends AreaEvent {
  final String name;
  final Color color;
  final Area? parentArea;

  AddArea({required this.name, required this.color, this.parentArea});
}

final class ShowAddAreaForm extends AreaEvent {}

final class SearchAreas extends AreaEvent {
  final String? search;

  SearchAreas({required this.search});
}

final class UpdateArea extends AreaEvent {
  final String? id;
  final String name;
  final Color color;
  final Area? parentArea;
  final bool isTracked;

  UpdateArea({
    required this.id,
    required this.name,
    required this.color,
    this.parentArea,
    this.isTracked = false,
  });
}

final class ShowEditAreaForm extends AreaEvent {}

final class ToggleAnalyticsWidget extends AreaEvent {}

final class ToggleAreaTracking extends AreaEvent {}

final class ShowCellsListWidget extends AreaEvent {}

class ShowAreasListWidget extends AreaEvent {
  final int? level;

  ShowAreasListWidget({this.level});
}
