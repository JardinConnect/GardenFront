import 'package:flutter/material.dart';

import '../models/user.dart';
import 'auth_utils.dart';

extension AuthContext on BuildContext {
  User? get currentUser => AuthUtils.getCurrentUser(this);
  bool get isAuthenticated => AuthUtils.isAuthenticated(this);
  void logout() => AuthUtils.logout(this);
}