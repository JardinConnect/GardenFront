import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:garden_connect/core/app_assets.dart';
import 'package:garden_connect/auth/auth.dart';
import 'package:garden_ui/ui/components.dart';

class MenuPage extends StatelessWidget {
  final Widget child;

  const MenuPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Menu(
              items: [
                MenuItem(
                  icon: Icons.home,
                  label: 'Accueil',
                  onTap: () => context.go('/dashboard'),
                ),
                MenuItem(
                  icon: Icons.hexagon_outlined,
                  label: 'Espaces',
                  onTap: () => context.go('/areas'),
                ),
                MenuItem(
                  icon: Icons.sensors,
                  label: 'Cellules',
                  onTap: () => context.go('/cells'),
                ),
                MenuItem(
                  icon: Icons.thunderstorm_outlined,
                  label: 'Alertes',
                  onTap: () => context.go('/alerts'),
                ),
              ],
              bottomItems: [
                MenuItem(
                  icon: Icons.settings,
                  label: 'Paramètres',
                  onTap: () => context.go('/settings'),
                ),
                MenuItem(
                  icon: Icons.logout,
                  label: 'Déconnexion',
                  onTap:
                      () => context.read<AuthBloc>().add(AuthLogoutRequested()),
                  severity: MenuItemSeverity.danger,
                ),
              ],
              logo: AssetImage(AppAssets.logo),
            ),
          ),
          Expanded(flex: 8, child: child),
        ],
      ),
    );
  }
}
