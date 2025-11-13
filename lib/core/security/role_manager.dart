// core/security/role_manager.dart
import 'package:garden_connect/core/security/permission.dart';
import 'package:garden_connect/core/security/roles.dart';


class RoleManager {
  static final Map<UserRole, List<Permission>> rolePermissions = {
    // Mapping pour chaque rôle vers ses permissions
    UserRole.admin: [
      Permission.manageUsers,
      Permission.manageRoles,
      Permission.viewAllData,
      Permission.editAllData
    ],

    UserRole.user: [
      Permission.viewAllData,
    ],
  };

  static bool hasPermission(UserRole role, Permission permission) {
    return rolePermissions[role]?.contains(permission) ?? false;
  }

  static List<Permission> getPermissionsForRole(UserRole role) {
    return rolePermissions[role] ?? [];
  }
}
