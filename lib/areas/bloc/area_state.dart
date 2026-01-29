part of 'area_bloc.dart';

@immutable
sealed class AreaState {
  final Area? selectedArea;
  final Cell? selectedCell;
  final bool isAreaSelected;

  const AreaState({
    this.selectedArea,
    this.selectedCell,
    this.isAreaSelected = false,
  });
}

final class AreaInitial extends AreaState {
  const AreaInitial() : super();
}

final class AreaError extends AreaState {
  final String message;

  const AreaError({required this.message}) : super();
}

final class AreasShimmer extends AreaState {
  const AreasShimmer() : super();
}

final class AreasLoaded extends AreaState {
  final List<Area> areas;
  final bool showAddForm;
  final bool showEditForm;
  final bool toggleAnalyticsWidget;
  final bool showCellsListWidget;
  final bool showAreasListWidget;
  final int? selectedLevel;
  final String? search;

  const AreasLoaded({
    required this.areas,
    super.selectedArea,
    super.selectedCell,
    super.isAreaSelected,
    this.showAddForm = false,
    this.showEditForm = false,
    this.toggleAnalyticsWidget = false,
    this.showCellsListWidget = false,
    this.showAreasListWidget = true,
    this.selectedLevel,
    this.search,
  });

  List<Area> get filteredAreas {
    final allAreas = Area.getAllAreasFlattened(areas);
    if (search == null || search!.isEmpty) {
      return allAreas;
    }
    return allAreas
        .where(
          (area) => area.name.toLowerCase().contains(search!.toLowerCase()),
        )
        .toList();
  }

  List<Area> getAvailableParents(Area? currentArea) {
    final allAreas = Area.getAllAreasFlattened(areas);

    if (currentArea == null) {
      // Mode ajout : tous les espaces sont disponibles
      return allAreas;
    }

    // Mode édition : exclure l'espace courant et ses descendants
    final descendants = Area.getDescendants(currentArea);
    return allAreas.where((area) {
      // Si un des ids est null, on ne peut pas comparer, donc on l'exclut par sécurité
      if (area.id == null || currentArea.id == null) return false;

      return area.id != currentArea.id &&
          !descendants.any((desc) => desc.id != null && desc.id == area.id);
    }).toList();
  }

  AreasLoaded copyWith({
    List<Area>? areas,
    Area? selectedArea,
    Cell? selectedCell,
    bool? isAreaSelected,
    bool? showAddForm,
    bool? showEditForm,
    bool? toggleAnalyticsWidget,
    bool? showCellsListWidget,
    bool? showAreasListWidget,
    int? selectedLevel,
    String? search,
    bool clearSelection = false,
    bool clearLevel = false,
  }) {
    return AreasLoaded(
      areas: areas ?? this.areas,
      selectedArea: clearSelection ? null : (selectedArea ?? this.selectedArea),
      selectedCell: clearSelection ? null : selectedCell,
      isAreaSelected: clearSelection ? false : (isAreaSelected ?? this.isAreaSelected),
      showAddForm: showAddForm ?? this.showAddForm,
      showEditForm: showEditForm ?? this.showEditForm,
      toggleAnalyticsWidget: toggleAnalyticsWidget ?? this.toggleAnalyticsWidget,
      showCellsListWidget: showCellsListWidget ?? this.showCellsListWidget,
      showAreasListWidget: showAreasListWidget ?? this.showAreasListWidget,
      selectedLevel: clearLevel ? null : (selectedLevel ?? this.selectedLevel),
      search: search ?? this.search,
    );
  }
}