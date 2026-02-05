part of 'cells_update_frequency_form_bloc.dart';

@immutable
sealed class CellsUpdateFrequencyFormEvent {
  const CellsUpdateFrequencyFormEvent();
}

class CellSelectionChanged extends CellsUpdateFrequencyFormEvent {
  final Cell? cell;

  const CellSelectionChanged(this.cell);
}

class MeasurementFrequencyChanged extends CellsUpdateFrequencyFormEvent {
  final Duration frequency;

  const MeasurementFrequencyChanged(this.frequency);
}

class DailyUpdateCountChanged extends CellsUpdateFrequencyFormEvent {
  final int count;

  const DailyUpdateCountChanged(this.count);
}

class UpdateTimeChanged extends CellsUpdateFrequencyFormEvent {
  final int index;
  final TimeOfDay newTime;

  const UpdateTimeChanged({required this.index, required this.newTime});
}

class FormSubmitted extends CellsUpdateFrequencyFormEvent {
  final List<Cell> cells;
  const FormSubmitted({required this.cells});
}
