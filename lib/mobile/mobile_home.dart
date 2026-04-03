import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/alerts/bloc/alert_bloc.dart';
import 'package:garden_connect/analytics/bloc/analytics_bloc.dart';
import 'package:garden_connect/areas/bloc/area_bloc.dart';
import 'package:garden_connect/cells/bloc/cell_bloc.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:go_router/go_router.dart';

class MobileHome extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MobileHome({super.key, required this.navigationShell});

  static const List<_NavItem> _items = [
    _NavItem(
      label: 'Accueil',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    _NavItem(
      label: 'Espaces',
      icon: Icons.hexagon_outlined,
      activeIcon: Icons.hexagon,
    ),
    _NavItem(
      label: 'Cellules',
      icon: Icons.sensors_outlined,
      activeIcon: Icons.sensors,
    ),
    _NavItem(
      label: 'Alertes',
      icon: Icons.thunderstorm_outlined,
      activeIcon: Icons.thunderstorm,
    ),
    _NavItem(
      label: 'Profil',
      icon: Icons.person_2_outlined,
      activeIcon: Icons.person,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedColor = GardenColors.primary.shade500;
    final unselectedColor = GardenColors.primary.shade200;
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: GardenColors.primary.shade50,
          border: Border(
            top: BorderSide(
              color: GardenColors.primary.shade200,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 72,
            child: Row(
              children: List.generate(_items.length, (index) {
                final item = _items[index];
                final isSelected = index == currentIndex;
                final color = isSelected ? selectedColor : unselectedColor;
                final icon =
                    isSelected ? item.activeIcon ?? item.icon : item.icon;

                return Expanded(
                  child: InkWell(
                    onTap: () {
                      context.read<CellBloc>().add(LoadCells());
                      context.read<AreaBloc>().add(LoadAreas());
                      context.read<AnalyticsBloc>().add(LoadAnalytics());
                      // Recharge les alertes lorsqu'on navigue vers l'onglet Alertes
                      if (index == 3) {
                        context.read<AlertBloc>().add(const AlertLoadData());
                      }
                      navigationShell.goBranch(
                        index,
                        initialLocation: true,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: isSelected
                                ? selectedColor
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, color: color),
                          const SizedBox(height: 4),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: color,
                              fontSize: 12,
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;

  const _NavItem({
    required this.label,
    required this.icon,
    this.activeIcon,
  });
}
