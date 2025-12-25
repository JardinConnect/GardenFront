import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/cells/models/analytic_metric.dart';
import 'package:garden_connect/cells/models/cell.dart';
import 'package:garden_connect/cells/repository/cell_repository.dart';
import 'package:meta/meta.dart';

part 'cell_event.dart';

part 'cell_state.dart';

class CellBloc extends Bloc<CellEvent, CellState> {
  final CellRepository _cellRepository;

  CellBloc() : _cellRepository = CellRepository(), super(const CellInitial()) {
    on<LoadCells>(_loadCells);
    on<RefreshCells>(_refreshCells);
    on<ToggleCellsDisplayMode>(_toggleCellsDisplayMode);
    on<FilterCellsChanged>(_applyFilter);
  }

  _loadCells(LoadCells event, Emitter<CellState> emit) async {
    bool isList = false;
    if (state is CellsLoaded) {
      isList = (state as CellsLoaded).isList;
    }

    emit(const CellsShimmer());
    try {
      final cells = await _cellRepository.fetchCells();
      emit(CellsLoaded(cells: cells, isList: isList));
    } catch(e) {
      emit(CellError(message: e.toString()));
    }
  }

  _refreshCells(RefreshCells event, Emitter<CellState> emit) async {
    try {
      await _cellRepository.refreshCells();
      add(LoadCells());
    } catch(e) {
      emit(CellError(message: e.toString()));
    }
  }

  _toggleCellsDisplayMode(ToggleCellsDisplayMode event, Emitter<CellState> emit) async {
    if (state is CellsLoaded) {
      final loadedState = state as CellsLoaded;
      emit(loadedState.copyWith(isList: !loadedState.isList));
    }
  }

  _applyFilter(FilterCellsChanged event, Emitter<CellState> emit) async {
    if (state is CellsLoaded) {
      final loadedState = state as CellsLoaded;
      emit(CellsLoaded(
        cells: loadedState.cells,
        isList: loadedState.isList,
        filter: event.filter,
      ));
    }
  }
}