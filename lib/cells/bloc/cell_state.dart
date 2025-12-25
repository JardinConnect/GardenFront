part of 'cell_bloc.dart';

@immutable
sealed class CellState {

  const CellState();
}

final class CellInitial extends CellState {
  const CellInitial() : super();
}

final class CellError extends CellState {
  final String message;

  const CellError({required this.message}) : super();
}

final class CellsShimmer extends CellState {
  const CellsShimmer() : super();
}

final class CellsLoaded extends CellState {
  final List<Cell> cells;
  final bool isList;
  final AnalyticMetric? filter;

  const CellsLoaded({
    required this.cells,
    this.isList = false,
    this.filter
  });

  CellsLoaded copyWith({
    List<Cell>? cells,
    bool? isList,
    AnalyticMetric? filter,
  }) {
    return CellsLoaded(
      cells: cells ?? this.cells,
      isList: isList ?? this.isList,
      filter: filter ?? this.filter
    );
  }
}