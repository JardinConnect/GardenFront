import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/bloc/auth_bloc.dart';
import 'package:garden_connect/core/security/permission.dart';
import 'package:garden_connect/core/security/role_manager.dart';
import 'package:garden_connect/core/security/roles.dart';

extension SecurityContext on BuildContext {
  /// Retourne le rôle de l'utilisateur actuel
  UserRole? get currentUserRole {
    final authBloc = read<AuthBloc>();
    if (authBloc.state is AuthAuthenticated) {
      final user = (authBloc.state as AuthAuthenticated).user;
      return user.isAdmin ? UserRole.admin : UserRole.user;
    }
    return null;
  }

  /// Vérifie si l'utilisateur a un rôle spécifique
  bool hasRole(UserRole role) {
    return currentUserRole == role;
  }

  /// Vérifie si l'utilisateur est admin
  bool get isAdmin => hasRole(UserRole.admin);

  /// Vérifie si l'utilisateur a une permission spécifique
  bool hasPermission(Permission permission) {
    final role = currentUserRole;
    if (role == null) return false;
    return RoleManager.hasPermission(role, permission);
  }

  /// Vérifie si l'utilisateur a toutes les permissions spécifiées
  bool hasAllPermissions(List<Permission> permissions) {
    return permissions.every((permission) => hasPermission(permission));
  }

  /// Vérifie si l'utilisateur a au moins une des permissions spécifiées
  bool hasAnyPermission(List<Permission> permissions) {
    return permissions.any((permission) => hasPermission(permission));
  }
}