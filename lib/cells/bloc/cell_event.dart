part of 'cell_bloc.dart';

@immutable
sealed class CellEvent {}

final class LoadCells extends CellEvent {}

final class LoadCellDetail extends CellEvent {
  final int id;

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
  final int id;
  final bool newTrackingValue;

  CellTrackingChanged({required this.id, required this.newTrackingValue});
}

final class RefreshCellDetail extends CellEvent {
  final int id;

  RefreshCellDetail({required this.id});
}

final class UpdateCell extends CellEvent {
  final int id;
  final String name;
  final int? parentId;

  UpdateCell({required this.id, required this.name, this.parentId});
}

final class DeleteCell extends CellEvent {
  final int id;

  DeleteCell({required this.id});
}