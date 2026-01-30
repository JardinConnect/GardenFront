part of 'cells_update_frequency_form_bloc.dart';

@immutable
class CellsUpdateFrequencyFormState {
  final Cell? selectedCell;
  final Duration measurementFrequency;
  final int dailyUpdateCount;
  final List<TimeOfDay> updateTimes;
  final bool isSubmitting;

  const CellsUpdateFrequencyFormState({
    this.selectedCell,
    this.measurementFrequency = const Duration(minutes: 15),
    this.dailyUpdateCount = 1,
    this.updateTimes = const [TimeOfDay(hour: 8, minute: 0)],
    this.isSubmitting = false,
  });

  CellsUpdateFrequencyFormState copyWith({
    Cell? Function()? selectedCell,
    Duration? measurementFrequency,
    int? dailyUpdateCount,
    List<TimeOfDay>? updateTimes,
    bool? isSubmitting,
  }) {
    return CellsUpdateFrequencyFormState(
      selectedCell: selectedCell != null ? selectedCell() : this.selectedCell,
      measurementFrequency: measurementFrequency ?? this.measurementFrequency,
      dailyUpdateCount: dailyUpdateCount ?? this.dailyUpdateCount,
      updateTimes: updateTimes ?? this.updateTimes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}