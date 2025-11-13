# Guide d'utilisation du système de sécurité

Ce guide explique comment utiliser le système de rôles et permissions que vous avez mis en place dans votre application Flutter.

## 🔧 Composants du système

### 1. **Rôles** (`lib/core/security/roles.dart`)
```dart
enum UserRole {
  user,    // Utilisateur standard
  admin    // Administrateur
}
```

### 2. **Permissions** (`lib/core/security/permission.dart`)
```dart
enum Permission {
  manageUsers,    // Gérer les utilisateurs
  manageRoles,    // Gérer les rôles
  viewAllData,    // Voir toutes les données
  editAllData     // Éditer toutes les données
}
```

### 3. **Gestionnaire de rôles** (`lib/core/security/role_manager.dart`)
Configure quelles permissions sont associées à chaque rôle.

## Extension du système

### Ajouter de nouveaux rôles

1. Ajouter le rôle dans `roles.dart`
2. Configurer ses permissions dans `role_manager.dart`
3. Mettre à jour la logique de mapping dans `role_guard.dart` et `security_extension.dart`

### Ajouter de nouvelles permissions

1. Ajouter la permission dans `permission.dart`
2. L'assigner aux rôles appropriés dans `role_manager.dart`

## Détermination du rôle actuel

Actuellement, le rôle est déterminé par le champ `isAdmin` du modèle `User` :
- `isAdmin = true` → `UserRole.admin`
- `isAdmin = false` → `UserRole.user`

Cette logique peut être étendue pour supporter plus de rôles si nécessaire.