part of 'cell_bloc.dart';


@immutable
sealed class CellEvent {}

final class LoadCells extends CellEvent {}

final class RefreshCells extends CellEvent {}

final class ToggleCellsDisplayMode extends CellEvent {}

final class FilterCellsChanged extends CellEvent {
  final AnalyticMetric? filter;

  FilterCellsChanged({
    required this.filter
  });
}