import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../models/analytics.dart';
import '../repository/analytics_repository.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepository _analyticsRepository;

  AnalyticsBloc() : _analyticsRepository = AnalyticsRepository(), super(AnalyticsInitial()) {
    on<LoadAnalytics>(_loadAnalytics);

    add(LoadAnalytics());
  }

  _loadAnalytics(LoadAnalytics event, Emitter<AnalyticsState> emit) async {
    emit(AnalyticsShimmer());
    try {
      final analytics = await _analyticsRepository.fetchAnalytics();
      emit(AnalyticsLoaded(analytics: analytics));
    } catch (e) {
      emit(AnalyticsError(message: e.toString()));
    }
  }
}
