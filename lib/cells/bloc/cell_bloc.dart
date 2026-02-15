import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/analytics/models/analytics.dart';
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
    on<SearchCells>(_searchCells);
    on<LoadCellDetail>(_loadCellDetail);
    on<CellTrackingChanged>(_changeCellTracking);
    on<RefreshCellDetail>(_refreshCellDetail);
    on<UpdateCell>(_updateCell);
    on<DeleteCell>(_deleteCell);
  }

  _loadCells(LoadCells event, Emitter<CellState> emit) async {
    bool isList = false;
    AnalyticType? filter;
    if (state is CellsLoaded) {
      isList = (state as CellsLoaded).isList;
      filter = (state as CellsLoaded).filter;
    }

    emit(const CellsShimmer());
    try {
      final cells = await _cellRepository.fetchCells();
      emit(
        CellsLoaded(
          cells: cells,
          filteredCells: cells,
          isList: isList,
          filter: filter,
        ),
      );
    } catch (e) {
      emit(CellError(message: e.toString()));
    }
  }

  _refreshCells(RefreshCells event, Emitter<CellState> emit) async {
    try {
      await _cellRepository.refreshCells();
      add(LoadCells());
    } catch (e) {
      emit(CellError(message: e.toString()));
    }
  }

  _toggleCellsDisplayMode(
    ToggleCellsDisplayMode event,
    Emitter<CellState> emit,
  ) async {
    if (state is CellsLoaded) {
      final loadedState = state as CellsLoaded;
      emit(loadedState.copyWith(isList: !loadedState.isList));
    }
  }

  _applyFilter(FilterCellsChanged event, Emitter<CellState> emit) async {
    if (state is CellsLoaded) {
      final loadedState = state as CellsLoaded;
      emit(
        CellsLoaded(
          cells: loadedState.cells,
          filteredCells: loadedState.filteredCells,
          isList: loadedState.isList,
          filter: event.filter,
        ),
      );
    }
  }

  _searchCells(SearchCells event, Emitter<CellState> emit) async {
    if (state is CellsLoaded) {
      final loadedState = state as CellsLoaded;

      emit(
        loadedState.copyWith(
          filteredCells:
              event.search == null || event.search!.isEmpty
                  ? loadedState.cells
                  : loadedState.cells
                      .where(
                        (cell) => cell.name.toLowerCase().contains(
                          event.search!.toLowerCase(),
                        ),
                      )
                      .toList(),
          search: event.search,
        ),
      );
    }
  }

  _loadCellDetail(LoadCellDetail event, Emitter<CellState> emit) async {
    emit(const CellDetailShimmer());
    try {
      final cell = await _cellRepository.fetchCellDetail(event.id);
      emit(CellDetailLoaded(cell: cell));
    } catch (e) {
      emit(CellError(message: e.toString()));
    }
  }

  _changeCellTracking(
    CellTrackingChanged event,
    Emitter<CellState> emit,
  ) async {
    try {
      await _cellRepository.changeCellTracking(
        event.id,
        event.newTrackingValue,
      );
      add(LoadCellDetail(id: event.id));
    } catch (e) {
      emit(CellError(message: e.toString()));
    }
  }

  _refreshCellDetail(RefreshCellDetail event, Emitter<CellState> emit) async {
    try {
      await _cellRepository.refreshCell(event.id);
      add(LoadCellDetail(id: event.id));
    } catch (e) {
      emit(CellError(message: e.toString()));
    }
  }

  _updateCell(UpdateCell event, Emitter<CellState> emit) async {
    try {
      await _cellRepository.updateCell(event.id, event.name, event.parentId);
    } catch (e) {
      emit(CellError(message: e.toString()));
    }
  }

  _deleteCell(DeleteCell event, Emitter<CellState> emit) async {
    try {
      await _cellRepository.deleteCell(event.id);
      add(LoadCellDetail(id: event.id));
    } catch (e) {
      emit(CellError(message: e.toString()));
    }
  }
}
