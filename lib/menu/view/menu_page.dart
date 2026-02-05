import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/auth.dart';
import 'package:garden_connect/core/app_assets.dart';
import 'package:garden_connect/menu/bloc/navigation_bloc.dart';
import 'package:garden_connect/menu/bloc/navigation_event.dart';
import 'package:garden_connect/menu/bloc/navigation_state.dart';
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
            child: BlocProvider(
              create: (context) => NavigationBloc(),
              child: BlocBuilder<NavigationBloc, NavigationState>(
                builder: (context, navState) {
                  return isInSettings
                      ? _buildSettingsMenu(context)
                      : _buildMainMenu(context);
                },
              ),
            ),
          ),
          Expanded(flex: 8, child: child),
        ],
      ),
    );
  }

  Widget _buildMainMenu(BuildContext context) {
    return Menu(
      items: [
        MenuItem(
          icon: Icons.home,
          label: 'Accueil',
          onTap: () {
            context.read<NavigationBloc>().add(const NavigateToMain());
            context.go('/dashboard');
          },
        ),
        MenuItem(
          icon: Icons.hexagon_outlined,
          label: 'Espaces',
          onTap: () {
            context.read<NavigationBloc>().add(const NavigateToMain());
            context.go('/areas');
          },
        ),
        MenuItem(
          icon: Icons.sensors,
          label: 'Cellules',
          onTap: () {
            context.read<NavigationBloc>().add(const NavigateToMain());
            context.go('/cells');
          },
        ),
        MenuItem(
          icon: Icons.thunderstorm_outlined,
          label: 'Alertes',
          onTap: () {
            context.read<NavigationBloc>().add(const NavigateToMain());
            context.go('/alerts');
          },
        ),
      ],
      bottomItems: [
        MenuItem(
          icon: Icons.settings,
          label: 'Paramètres',
          onTap: () {
            context.read<NavigationBloc>().add(const NavigateToSettings());
            context.go('/settings');
          },
        ),
        MenuItem(
          icon: Icons.logout,
          label: 'Déconnexion',
          onTap: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
          severity: MenuItemSeverity.danger,
        ),
      ],
      logo: AssetImage(AppAssets.logo),
    );
  }

  Widget _buildSettingsMenu(BuildContext context) {
    return Menu(
      items: [
        MenuItem(
          icon: Icons.settings,
          label: 'Vue d\'ensemble',
          onTap: () {
            context.read<NavigationBloc>().add(const NavigateToSettings());
            context.go('/settings');
          },
        ),
        MenuItem(
          icon: Icons.person_2_outlined,
          label: 'Utilisateurs',
          onTap: () {
            context.read<NavigationBloc>().add(const NavigateToSettings());
            context.go('/settings/users');
          },
        ),
        MenuItem(
          icon: Icons.hexagon_outlined,
          label: 'Espaces',
          onTap: () {
            context.read<NavigationBloc>().add(const NavigateToSettings());
            context.go('/settings/areas');
          },
        ),
        MenuItem(
          icon: Icons.sensors,
          label: 'Cellules',
          onTap: () {
            context.read<NavigationBloc>().add(const NavigateToSettings());
            context.go('/settings/cells');
          },
        ),
        MenuItem(
          icon: Icons.shield_outlined,
          label: 'Administration',
          onTap: () {
            context.read<NavigationBloc>().add(const NavigateToSettings());
            // TODO: ajouter la page d'administration lorsque celle-ci sera prête
            context.go('/settings');
          },
        ),
      ],
      bottomItems: [
        MenuItem(
          icon: Icons.home_outlined,
          // TODO: remplacer par le nom de la ferme lorsque celui-ci sera disponible
          label: 'GAEC Plume de Courgette',
          onTap: () {
            context.read<NavigationBloc>().add(const ExitSettings());
            context.go('/dashboard');
          },
        ),
        MenuItem(
          icon: Icons.logout,
          label: 'Déconnexion',
          onTap: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
          severity: MenuItemSeverity.danger,
        ),
      ],
      logo: AssetImage(AppAssets.logo),
    );
  }
}
