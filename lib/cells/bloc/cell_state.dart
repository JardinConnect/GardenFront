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
  /// La liste des cellules complète
  final List<Cell> cells;

  /// La liste des cellules filtrée en fonction de la recherche
  final List<Cell> filteredCells;

  /// Est-ce qu'on affiche les cellules au format liste ? (false = cards)
  final bool isList;
  final AnalyticType? filter;
  final String? search;

  const CellsLoaded({
    required this.cells,
    required this.filteredCells,
    this.isList = false,
    this.filter,
    this.search,
  });

  CellsLoaded copyWith({
    List<Cell>? cells,
    List<Cell>? filteredCells,
    bool? isList,
    AnalyticType? filter,
    String? search,
  }) {
    return CellsLoaded(
      cells: cells ?? this.cells,
      filteredCells: filteredCells ?? this.filteredCells,
      isList: isList ?? this.isList,
      filter: filter ?? this.filter,
      search: search ?? this.search,
    );
  }
}

final class CellDetailShimmer extends CellState {
  const CellDetailShimmer() : super();
}

final class CellDetailLoaded extends CellState {
  final CellDetail cell;

  const CellDetailLoaded({required this.cell});
}
