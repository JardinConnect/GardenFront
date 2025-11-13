import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/bloc/auth_bloc.dart';
import 'package:garden_connect/core/security/permission.dart';
import 'package:garden_connect/core/security/role_manager.dart';
import 'package:garden_connect/core/security/roles.dart';

class RoleGuard extends StatelessWidget {
  final Widget child;
  final UserRole? requiredRole;
  final List<Permission>? requiredPermissions;
  final Widget? fallback;

  const RoleGuard({
    super.key,
    required this.child,
    this.requiredRole,
    this.requiredPermissions,
    this.fallback,
  });

  /// Widget pour protéger les fonctionnalités admin uniquement
  factory RoleGuard.adminOnly({
    Key? key,
    required Widget child,
    Widget? fallback,
  }) {
    return RoleGuard(
      key: key,
      child: child,
      requiredRole: UserRole.admin,
      fallback: fallback,
    );
  }

  /// Widget pour protéger selon des permissions spécifiques
  factory RoleGuard.withPermissions({
    Key? key,
    required Widget child,
    required List<Permission> permissions,
    Widget? fallback,
  }) {
    return RoleGuard(
      key: key,
      child: child,
      requiredPermissions: permissions,
      fallback: fallback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return fallback ?? const SizedBox.shrink();
        }

        final user = state.user;
        final userRole = user.isAdmin ? UserRole.admin : UserRole.user;

        // Vérifier le rôle requis
        if (requiredRole != null && userRole != requiredRole) {
          return fallback ?? const SizedBox.shrink();
        }

        // Vérifier les permissions requises
        if (requiredPermissions != null) {
          final hasAllPermissions = requiredPermissions!.every(
            (permission) => RoleManager.hasPermission(userRole, permission),
          );

          if (!hasAllPermissions) {
            return fallback ?? const SizedBox.shrink();
          }
        }

        return child;
      },
    );
  }
}