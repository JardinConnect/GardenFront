import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../models/area.dart';
import '../../cells/models/cell.dart';
import '../repository/area_repository.dart';

part 'area_event.dart';

part 'area_state.dart';

class AreaBloc extends Bloc<AreaEvent, AreaState> {
  final AreaRepository _areaRepository;

  AreaBloc() : _areaRepository = AreaRepository(), super(const AreaInitial()) {
    on<LoadAreas>(_loadAreas);
    on<SelectArea>(_selectArea);
    on<SelectCell>(_selectCell);
    on<ClearSelection>(_clearSelection);
    on<AddArea>(_addArea);
    on<ShowAddAreaForm>(_showAddAreaForm);
    on<ShowEditAreaForm>(_showEditAreaForm);
    on<ToggleAnalyticsWidget>(_toggleAnalyticsWidget);
    on<ShowCellsListWidget>(_showCellsListWidget);
    on<ShowAreasListWidget>(_showAreasListWidget);

    add(LoadAreas());
  }

  _loadAreas(LoadAreas event, Emitter<AreaState> emit) async {
    emit(const AreasShimmer());
    try {
      final areas = await _areaRepository.fetchAreas();
      emit(
        AreasLoaded(
          areas: areas,
          showAreasListWidget: false,
          showCellsListWidget: false,
        ),
      );
    } catch (e) {
      emit(AreaError(message: e.toString()));
    }
  }

  _selectArea(SelectArea event, Emitter<AreaState> emit) {
    final currentState = state;
    if (currentState is AreasLoaded) {
      emit(
        currentState.copyWith(
          selectedArea: event.area,
          selectedCell: null,
          isAreaSelected: true,
          showAddForm: false,
          showEditForm: false,
          showAreasListWidget: false,
          showCellsListWidget: false,
          clearLevel: true,
        ),
      );
    }
  }

  _selectCell(SelectCell event, Emitter<AreaState> emit) {
    final currentState = state;
    if (currentState is AreasLoaded) {
      emit(
        currentState.copyWith(
          selectedArea: event.parentArea,
          selectedCell: event.cell,
          isAreaSelected: false,
          showAddForm: false,
          showEditForm: false,
          showAreasListWidget: false,
          showCellsListWidget: false,
          clearLevel: true,
        ),
      );
    }
  }

  _clearSelection(ClearSelection event, Emitter<AreaState> emit) {
    final currentState = state;
    if (currentState is AreasLoaded) {
      emit(
        currentState.copyWith(
          clearSelection: true,
          showAddForm: false,
          showEditForm: false,
          showAreasListWidget: false,
          showCellsListWidget: false,
          clearLevel: true,
        ),
      );
    }
  }

  _addArea(AddArea event, Emitter<AreaState> emit) async {
    final currentState = state;
    if (currentState is AreasLoaded) {
      try {
        final colorHex = event.color.value
            .toRadixString(16)
            .toUpperCase()
            .padLeft(8, '0');

        final newArea = await _areaRepository.createArea(
          name: event.name,
          color: colorHex,
          parentArea: event.parentArea,
        );

        add(LoadAreas());
      } catch (e) {
        emit(AreaError(message: e.toString()));
      }
    }
  }

  _showAddAreaForm(ShowAddAreaForm event, Emitter<AreaState> emit) {
    final currentState = state;
    if (currentState is AreasLoaded) {
      emit(currentState.copyWith(showAddForm: true));
    }
  }

  _showEditAreaForm(ShowEditAreaForm event, Emitter<AreaState> emit) {
    final currentState = state;
    if (currentState is AreasLoaded) {
      emit(currentState.copyWith(showEditForm: true));
    }
  }

  _toggleAnalyticsWidget(ToggleAnalyticsWidget event, Emitter<AreaState> emit) {
    final currentState = state;
    if (currentState is AreasLoaded) {
      emit(
        currentState.copyWith(
          toggleAnalyticsWidget: !currentState.toggleAnalyticsWidget,
        ),
      );
    }
  }

  _showCellsListWidget(ShowCellsListWidget event, Emitter<AreaState> emit) {
    final currentState = state;
    if (currentState is AreasLoaded) {
      emit(
        currentState.copyWith(
          showAreasListWidget: false,
          showCellsListWidget: true,
          clearLevel: true,
        ),
      );
    }
  }

  _showAreasListWidget(ShowAreasListWidget event, Emitter<AreaState> emit) {
    final currentState = state;
    if (currentState is AreasLoaded) {
      emit(
        currentState.copyWith(
          showCellsListWidget: false,
          showAreasListWidget: true,
          selectedLevel: event.level,
        ),
      );
    }
  }
}
