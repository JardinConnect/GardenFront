part of 'cell_bloc.dart';

@immutable
sealed class CellEvent {}

final class LoadCells extends CellEvent {}

final class LoadCellDetail extends CellEvent {
  final String id;

  LoadCellDetail({required this.id});
}

final class RefreshCells extends CellEvent {}

final class ToggleCellsDisplayMode extends CellEvent {}

final class FilterCellsChanged extends CellEvent {
  final AnalyticType? filter;

  FilterCellsChanged({required this.filter});
}

final class SearchCells extends CellEvent {
  final String? search;

  SearchCells({required this.search});
}

final class CellTrackingChanged extends CellEvent {
  final String id;
  final bool newTrackingValue;
  final String name;
  final String? parentId;

  CellTrackingChanged({required this.id, required this.name, required this.newTrackingValue, this.parentId});
}

final class RefreshCellDetail extends CellEvent {
  final String id;

  RefreshCellDetail({required this.id});
}

final class UpdateCell extends CellEvent {
  final String id;
  final String name;
  final bool isTracked;
  final String? parentId;

  UpdateCell({required this.id, required this.name, required this.isTracked, this.parentId});
}

final class DeleteCell extends CellEvent {
  final String id;

  DeleteCell({required this.id});
}