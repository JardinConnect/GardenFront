import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/core/app_assets.dart';
import 'package:garden_connect/dashboard/view/dashboard_page.dart';
import 'package:garden_connect/settings/view/settings_page.dart';
import 'package:garden_connect/menu/cubit/navigation_cubit.dart';
import 'package:garden_connect/menu/cubit/navigation_state.dart';
import 'package:garden_connect/auth/auth.dart';
import 'package:garden_ui/ui/components.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  static final List<Widget> _pages = [
    const DashboardPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
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
                      onTap:
                          () => context.read<NavigationCubit>().navigateTo(0),
                    ),
                    MenuItem(
                      icon: Icons.hexagon_outlined,
                      label: 'Espaces',
                      onTap: () => {},
                    ),
                    MenuItem(
                      icon: Icons.sensors,
                      label: 'Cellules',
                      onTap: () => {},
                    ),
                    MenuItem(
                      icon: Icons.thunderstorm_outlined,
                      label: 'Alertes',
                      onTap: () => {},
                    ),
                  ],
                  bottomItems: [
                    MenuItem(
                      icon: Icons.settings,
                      label: 'Paramètres',
                      onTap:
                          () => context.read<NavigationCubit>().navigateTo(1),
                    ),
                    MenuItem(
                      icon: Icons.logout,
                      label: 'Déconnexion',
                      onTap:
                          () => context.read<AuthBloc>().add(
                            AuthLogoutRequested(),
                          ),
                      severity: MenuItemSeverity.danger,
                    ),
                  ],
                  logo: AssetImage(AppAssets.logo),
                ),
              ),
              Expanded(flex: 8, child: _pages[state.index]),
            ],
          ),
        );
      },
    );
  }
}
