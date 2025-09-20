import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../models/user.dart';

class AuthUtils {
  static User? getCurrentUser(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return authBloc.currentUser;
  }

  static bool isAuthenticated(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return authBloc.isAuthenticated;
  }

  static void logout(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogoutRequested());
  }
}