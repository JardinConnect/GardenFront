import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:garden_connect/cells/models/cell.dart';
import 'package:garden_connect/cells/repository/cell_sse_repository.dart';
import 'package:garden_connect/cells/repository/cell_repository.dart';
import 'package:meta/meta.dart';

part 'cell_event.dart';

part 'cell_state.dart';

class CellBloc extends Bloc<CellEvent, CellState> {
  final CellRepository _cellRepository;
  final CellSSERepository _cellSSERepository;

  CellBloc()
    : _cellRepository = CellRepository(),
        _cellSSERepository = CellSSERepository(),
      super(const CellInitial()) {
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
    emit(const CellsShimmer());
    final errorMsg = "Erreur lors du rafraîchissement des données des cellules";
    try {
      await for (final model in _cellSSERepository.subscribeToRefresh()) {
        final eventName = model.event?.trim() ?? '';
        if (eventName == 'error') {
          emit(CellError(message: errorMsg));
          return;
        }
        if (eventName.isNotEmpty &&
            eventName != 'status' &&
            eventName != 'waiting_ack') {
          add(LoadCells());
          return;
        }
      }
    } catch (e) {
      if (!emit.isDone) emit(CellError(message: e.toString()));
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
      await _cellRepository.updateCell(
        event.id,
        event.name,
        event.newTrackingValue,
        event.parentId,
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
      await _cellRepository.updateCell(
        event.id,
        event.name,
        event.isTracked,
        event.parentId,
      );
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
