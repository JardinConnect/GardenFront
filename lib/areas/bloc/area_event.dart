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

  AddArea({
    required this.name,
    required this.color,
    this.parentArea,
  });
}

final class ShowAddAreaForm extends AreaEvent {}