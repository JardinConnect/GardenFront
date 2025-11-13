import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/bloc/auth_bloc.dart';
import 'package:garden_connect/core/app_assets.dart';

/// Service pour gérer la sécurité et les autorisations dans l'application
class SecurityService {
  /// Vérifie si l'utilisateur actuel est authentifié
  static bool isAuthenticated(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return authBloc.state is AuthAuthenticated;
  }

  /// Récupère le rôle de l'utilisateur actuel
  static UserRole? getCurrentUserRole(BuildContext context) {
    return context.currentUserRole;
  }

  /// Vérifie si l'utilisateur peut accéder à une fonctionnalité
  static bool canAccess(BuildContext context, Permission permission) {
    return context.hasPermission(permission);
  }

  /// Vérifie si l'utilisateur est admin
  static bool isAdmin(BuildContext context) {
    return context.isAdmin;
  }

  /// Exécute une action seulement si l'utilisateur a les permissions
  static void executeWithPermission(
    BuildContext context,
    Permission permission,
    VoidCallback action, {
    VoidCallback? onUnauthorized,
  }) {
    if (canAccess(context, permission)) {
      action();
    } else {
      onUnauthorized?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous n\'avez pas les permissions pour cette action'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Exécute une action seulement si l'utilisateur est admin
  static void executeAsAdmin(
    BuildContext context,
    VoidCallback action, {
    VoidCallback? onUnauthorized,
  }) {
    if (isAdmin(context)) {
      action();
    } else {
      onUnauthorized?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cette action nécessite des droits d\'administrateur'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}