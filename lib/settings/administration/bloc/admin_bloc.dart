import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/settings/administration/models/system_metrics.dart';
import 'package:garden_connect/settings/administration/repository/admin_repository.dart';
import 'package:meta/meta.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository _adminRepository;

  AdminBloc()
    : _adminRepository = AdminRepository(),
      super(const AdminInitial()) {
    on<LoadAdminData>(_loadAdminData);
  }

  _loadAdminData(LoadAdminData event, Emitter<AdminState> emit) async {
    emit(const AdminShimmer());
    try {
      final systemMetrics = await _adminRepository.fetchSystemMetrics();
      final vpnAuthURL = await _adminRepository.fetchVpnAuthURL();
      emit(AdminLoaded(systemMetrics: systemMetrics, vpnAuthURL: vpnAuthURL));
    } catch (e) {
      emit(AdminError(message: e.toString()));
    }
  }
}
