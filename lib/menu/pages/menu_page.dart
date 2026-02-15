import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/auth.dart';
import 'package:garden_connect/core/app_assets.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:go_router/go_router.dart';

class MenuPage extends StatelessWidget {
  final Widget child;

  const MenuPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    final isInSettings = currentPath.startsWith('/settings');

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: isInSettings
                ? _buildSettingsMenu(context, currentPath)
                : _buildMainMenu(context, currentPath),
          ),
          Expanded(flex: 8, child: child),
        ],
      ),
    );
  }

  Widget _buildMainMenu(BuildContext context, String path) {
    return Menu(
      items: [
        MenuItem(
          icon: Icons.home,
          label: 'Accueil',
          isActive: path == '/dashboard',
          onTap: () => context.go('/dashboard'),
        ),
        MenuItem(
          icon: Icons.hexagon_outlined,
          label: 'Espaces',
          isActive: path.startsWith('/areas'),
          onTap: () => context.go('/areas'),
        ),
        MenuItem(
          icon: Icons.sensors,
          label: 'Cellules',
          isActive: path.startsWith('/cells'),
          onTap: () => context.go('/cells'),
        ),
        MenuItem(
          icon: Icons.thunderstorm_outlined,
          label: 'Alertes',
          isActive: path.startsWith('/alerts'),
          onTap: () => context.go('/alerts'),
        ),
      ],
      bottomItems: [
        MenuItem(
          icon: Icons.settings,
          label: 'Paramètres',
          isActive: false,
          onTap: () => context.go('/settings'),
        ),
        MenuItem(
          icon: Icons.logout,
          label: 'Déconnexion',
          isActive: false,
          onTap: () =>
              context.read<AuthBloc>().add(AuthLogoutRequested()),
          severity: MenuItemSeverity.danger,
        ),
      ],
      logo: AssetImage(AppAssets.logo),
    );
  }

  Widget _buildSettingsMenu(BuildContext context, String path) {
    return Menu(
      items: [
        MenuItem(
          icon: Icons.settings,
          label: 'Vue d\'ensemble',
          isActive: path == '/settings',
          onTap: () => context.go('/settings'),
        ),
        MenuItem(
          icon: Icons.person_2_outlined,
          label: 'Utilisateurs',
          isActive: path.startsWith('/settings/users'),
          onTap: () => context.go('/settings/users'),
        ),
        MenuItem(
          icon: Icons.hexagon_outlined,
          label: 'Espaces',
          isActive: path.startsWith('/settings/areas'),
          onTap: () => context.go('/settings/areas'),
        ),
        MenuItem(
          icon: Icons.sensors,
          label: 'Cellules',
          isActive: path.startsWith('/settings/cells'),
          onTap: () => context.go('/settings/cells'),
        ),
        MenuItem(
          icon: Icons.shield_outlined,
          label: 'Administration',
          isActive: false,
          onTap: () => context.go('/settings'),
        ),
      ],
      bottomItems: [
        MenuItem(
          icon: Icons.home_outlined,
          label: 'GAEC Plume de Courgette',
          isActive: false,
          onTap: () => context.go('/dashboard'),
        ),
        MenuItem(
          icon: Icons.logout,
          label: 'Déconnexion',
          isActive: false,
          onTap: () =>
              context.read<AuthBloc>().add(AuthLogoutRequested()),
          severity: MenuItemSeverity.danger,
        ),
      ],
      logo: AssetImage(AppAssets.logo),
    );
  }
}
