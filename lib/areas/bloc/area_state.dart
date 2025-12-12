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

  const AreasLoaded({
    required this.areas,
    super.selectedArea,
    super.selectedCell,
    super.isAreaSelected,
    this.showAddForm = false,
  });

  AreasLoaded copyWith({
    List<Area>? areas,
    Area? selectedArea,
    Cell? selectedCell,
    bool? isAreaSelected,
    bool? showAddForm,
    bool clearSelection = false,
  }) {
    return AreasLoaded(
      areas: areas ?? this.areas,
      selectedArea: clearSelection ? null : (selectedArea ?? this.selectedArea),
      selectedCell: clearSelection ? null : selectedCell,
      isAreaSelected: clearSelection ? false : (isAreaSelected ?? this.isAreaSelected),
      showAddForm: showAddForm ?? this.showAddForm,
    );
  }
}