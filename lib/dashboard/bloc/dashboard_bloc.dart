import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/dashboard/repository/dashboard_repository.dart';
import 'package:meta/meta.dart';

import '../models/analytics.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _dashboardRepository;

  DashboardBloc() : _dashboardRepository = DashboardRepository(), super(DashboardInitial()) {
    on<DashboardLoadAnalytics>(_loadAnalytics);

    add(DashboardLoadAnalytics());
  }

  _loadAnalytics(DashboardLoadAnalytics event, Emitter<DashboardState> emit) async {
    emit(DashboardAnalyticsShimmer());
    try {
      final analytics = await _dashboardRepository.fetchAnalytics();
      emit(DashboardAnalyticsLoaded(analytics: analytics));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }
}
