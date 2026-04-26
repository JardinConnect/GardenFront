import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/auth.dart';
import 'package:garden_connect/core/app_assets.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:go_router/go_router.dart';

import '../../alerts/bloc/alert_bloc.dart';
import '../../alerts/widgets/common/snackbar.dart' as snackbar;

class MenuPage extends StatelessWidget {
  final Widget child;

  const MenuPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    final isInSettings = currentPath.startsWith('/settings');

    return BlocListener<AlertBloc, AlertState>(
      listenWhen: (previous, current) {
        if (current is! AlertLoaded) return false;
        if (previous is! AlertLoaded) return current.latestSSEAlertEvent != null;
        return current.latestSSEAlertEvent != null &&
            current.latestSSEAlertEvent != previous.latestSSEAlertEvent;
      },
      listener: (context, state) {
        if (state is! AlertLoaded) return;
        final event = state.latestSSEAlertEvent;
        if (event == null) return;

        snackbar.showAlertEventToast(context, event);

        context.read<AlertBloc>().add(const AlertSSEClearNotification());
      },
      child: Scaffold(
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
      ),
    );
  }

  Widget _buildMainMenu(BuildContext context, String path) {
    return Menu(
      onLogoTap: () => context.go('/dashboard'),
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
          onTap: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
          severity: MenuItemSeverity.danger,
        ),
      ],
      logo: AssetImage(AppAssets.logo),
    );
  }

  Widget _buildSettingsMenu(BuildContext context, String path) {
    return Menu(
      onLogoTap: () => context.go('/dashboard'),
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
          isActive: path.startsWith('/settings/admin'),
          onTap: () => context.go('/settings/admin'),
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
          onTap: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
          severity: MenuItemSeverity.danger,
        ),
      ],
      logo: AssetImage(AppAssets.logo),
    );
  }
}
