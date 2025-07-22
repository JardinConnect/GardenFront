import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState(0));

  void navigateTo(int index) => emit(NavigationState(index));
}
