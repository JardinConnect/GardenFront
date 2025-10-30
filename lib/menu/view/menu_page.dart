import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/dashboard/view/dashboard_page.dart';
import 'package:garden_connect/settings/view/settings_page.dart';
import 'package:garden_connect/menu/cubit/navigation_cubit.dart';
import 'package:garden_connect/menu/cubit/navigation_state.dart';
import 'package:garden_connect/auth/auth.dart';
import 'package:widgetbook_workspace/ui/components.dart';

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
              Flexible(
                flex: 3,
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
                ),
              ),
              Expanded(flex: 7, child: _pages[state.index]),
            ],
          ),
        );
      },
    );
  }
}
