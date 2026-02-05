import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/cells/models/cell.dart';
import 'package:garden_connect/cells/repository/cell_repository.dart';

part 'cells_update_frequency_form_event.dart';

part 'cells_update_frequency_form_state.dart';

class CellsUpdateFrequencyFormBloc
    extends Bloc<CellsUpdateFrequencyFormEvent, CellsUpdateFrequencyFormState> {
  final CellRepository _cellRepository;

  CellsUpdateFrequencyFormBloc()
    : _cellRepository = CellRepository(),
      super(const CellsUpdateFrequencyFormState()) {
    on<CellSelectionChanged>(_onCellSelectionChanged);
    on<MeasurementFrequencyChanged>(_onMeasurementFrequencyChanged);
    on<DailyUpdateCountChanged>(_onDailyUpdateCountChanged);
    on<UpdateTimeChanged>(_onUpdateTimeChanged);
    on<FormSubmitted>(_onFormSubmitted);
  }

  void _onCellSelectionChanged(
    CellSelectionChanged event,
    Emitter<CellsUpdateFrequencyFormState> emit,
  ) {
    emit(state.copyWith(selectedCell: () => event.cell));
  }

  void _onMeasurementFrequencyChanged(
    MeasurementFrequencyChanged event,
    Emitter<CellsUpdateFrequencyFormState> emit,
  ) {
    emit(state.copyWith(measurementFrequency: event.frequency));
  }

  void _onDailyUpdateCountChanged(
    DailyUpdateCountChanged event,
    Emitter<CellsUpdateFrequencyFormState> emit,
  ) {
    final currentTimes = List<TimeOfDay>.from(state.updateTimes);
    final newCount = event.count;

    if (newCount > currentTimes.length) {
      while (currentTimes.length < newCount) {
        currentTimes.add(const TimeOfDay(hour: 12, minute: 0));
      }
    } else if (newCount < currentTimes.length) {
      currentTimes.removeRange(newCount, currentTimes.length);
    }

    emit(state.copyWith(dailyUpdateCount: newCount, updateTimes: currentTimes));
  }

  void _onUpdateTimeChanged(
    UpdateTimeChanged event,
    Emitter<CellsUpdateFrequencyFormState> emit,
  ) {
    final currentTimes = List<TimeOfDay>.from(state.updateTimes);
    currentTimes[event.index] = event.newTime;
    emit(state.copyWith(updateTimes: currentTimes));
  }

  Future<void> _onFormSubmitted(
    FormSubmitted event,
    Emitter<CellsUpdateFrequencyFormState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));
    try {
      final selectedCells =
          state.selectedCell != null
              ? [state.selectedCell!.id]
              : event.cells.map((cell) => cell.id).toList();
      final measurementFrequencyInSeconds =
          state.measurementFrequency.inSeconds;
      final formattedUpdateTimes = state.updateTimes.map((updateTime) {
        final hours = updateTime.hour.toString().padLeft(2, '0');
        final minutes = updateTime.minute.toString().padLeft(2, '0');
        return "$hours:$minutes";
      }).toList();

      _cellRepository.updateCellsSettings(
        selectedCells,
        state.dailyUpdateCount,
        measurementFrequencyInSeconds,
        formattedUpdateTimes,
      );
      emit(state.copyWith(isSubmitting: false));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false));
    }
  }
}
