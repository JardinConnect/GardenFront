import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../analytics/models/analytics.dart';
import '../models/area.dart';
import '../../cells/models/cell.dart';
import '../repository/area_repository.dart';

part 'area_event.dart';

part 'area_state.dart';

class AreaBloc extends Bloc<AreaEvent, AreaState> {
  final AreaRepository _areaRepository;

  AreaBloc() : _areaRepository = AreaRepository(), super(const AreaInitial()) {
    on<LoadAreas>(_loadAreas);
    on<LoadAreaSetup>(_loadAreaSetup);
    on<SelectArea>(_selectArea);
    on<SelectCell>(_selectCell);
    on<ClearSelection>(_clearSelection);
    on<AddArea>(_addArea);
    on<ShowAddAreaForm>(_showAddAreaForm);
    on<ShowEditAreaForm>(_showEditAreaForm);
    on<ToggleAnalyticsWidget>(_toggleAnalyticsWidget);
    on<ShowCellsListWidget>(_showCellsListWidget);
    on<ShowAreasListWidget>(_showAreasListWidget);
    on<UpdateArea>(_onUpdateArea);
    on<DeleteArea>(_deleteArea);
    on<SearchAreas>(_searchAreas);
    on<ToggleAreaTracking>(_toggleAreaTracking);
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
          selectedArea: areas.isNotEmpty ? areas.first : null,
          isAreaSelected: areas.isNotEmpty,
        ),
      );
    } catch (e) {
      emit(
        const AreasLoaded(
          areas: [],
          showAreasListWidget: false,
          showCellsListWidget: false,
        ),
      );
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
        emit(const AreasShimmer());

        final colorHex = '#${event.color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

        await _areaRepository.createArea(
          name: event.name,
          color: colorHex,
          parentId: event.parentArea?.id,
        );

        final areas = await _areaRepository.fetchAreas();
        emit(
          AreasLoaded(
            areas: areas,
            showAreasListWidget: false,
            showCellsListWidget: false,
          ),
        );
      } catch (e) {
        // En cas d'erreur, revenir à l'état précédent
        final areas = await _areaRepository.fetchAreas();
        emit(
          AreasLoaded(
            areas: areas.isNotEmpty ? areas : currentState.areas,
            showAreasListWidget: false,
            showCellsListWidget: false,
          ),
        );
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

  _toggleAreaTracking(ToggleAreaTracking event, Emitter<AreaState> emit) async {
    final currentState = state;
    if (currentState is AreasLoaded) {
      final selectedArea = currentState.selectedArea;
      if (selectedArea == null) return;

      try {
        final area = await _areaRepository.updateArea(
          id: selectedArea.id,
          isTracked: !selectedArea.isTracked,
        );
        final areas = await _areaRepository.fetchAreas();
        emit(
          currentState.copyWith(
            selectedArea: area,
            areas: areas,
            toggleAreaTracking: area.isTracked,
          ),
        );
      } catch (e) {
        // En cas d'erreur, on reste sur l'état actuel
        if (kDebugMode) {
          print('Erreur toggle tracking: $e');
        }
      }
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

  _searchAreas(SearchAreas event, Emitter<AreaState> emit) {
    final currentState = state;
    if (currentState is AreasLoaded) {
      emit(currentState.copyWith(search: event.search));
    }
  }

  Future<void> _onUpdateArea(UpdateArea event, Emitter<AreaState> emit) async {
    final currentState = state;
    if (currentState is! AreasLoaded) return;

    if (event.id == null) return;

    try {
      emit(const AreasShimmer());

      await _areaRepository.updateArea(
        id: event.id!,
        name: event.name,
        color: event.color,
        parentId: event.parentId,
        isTracked: event.isTracked,
      );

      final areas = await _areaRepository.fetchAreas();
      emit(
        AreasLoaded(
          areas: areas,
          showAreasListWidget: false,
          showCellsListWidget: false,
        ),
      );
    } catch (e) {
      final areas = await _areaRepository.fetchAreas();
      emit(
        AreasLoaded(
          areas: areas.isNotEmpty ? areas : currentState.areas,
          showAreasListWidget: false,
          showCellsListWidget: false,
        ),
      );
    }
  }

  Future<void> _deleteArea(DeleteArea event, Emitter<AreaState> emit) async {
    final currentState = state;
    if (currentState is! AreasLoaded) return;

    try {
      emit(const AreasShimmer());
      await _areaRepository.deleteArea(event.id);
      final areas = await _areaRepository.fetchAreas();
      emit(
        AreasLoaded(
          areas: areas,
          showAreasListWidget: false,
          showCellsListWidget: false,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Erreur suppression area: $e');
      }
      final areas = await _areaRepository.fetchAreas();
      emit(
        AreasLoaded(
          areas: areas.isNotEmpty ? areas : currentState.areas,
          showAreasListWidget: false,
          showCellsListWidget: false,
        ),
      );
    }
  }

   _loadAreaSetup(LoadAreaSetup event, Emitter<AreaState> emit) {

       final areas = [
         Area(id: "1", name: "Serre 1 example", level: 1, color: Colors.blue, analytics: Analytics()),
         Area(id: "2", name: "Parcelle 1 example", level: 2, color: Colors.blue, analytics: Analytics()),
         Area(id: "3", name: "Jardin 1 example", level: 3, color: Colors.blue, analytics: Analytics()),
       ];
       emit(
         AreasLoaded(
           areas: areas,
           showAreasListWidget: false,
           showCellsListWidget: false,
           selectedArea: areas.first,
           isAreaSelected: true,
         ),
       );
  }
}
