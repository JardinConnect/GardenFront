import 'package:flutter/material.dart';
import 'package:garden_connect/mobile/pages/mobile_alerts_page.dart';
import 'package:garden_connect/mobile/pages/mobile_cells_page.dart';
import 'package:garden_connect/mobile/pages/mobile_home_page.dart';
import 'package:garden_connect/mobile/pages/mobile_spaces_page.dart';
import 'package:garden_connect/mobile/pages/mobile_profile_page.dart';
import 'package:garden_ui/ui/design_system.dart';

class MobileHome extends StatefulWidget {
  const MobileHome({super.key});

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    MobileHomePage(),
    MobileSpacesPage(),
    MobileCellsPage(),
    MobileAlertsPage(),
    MobileProfilePage(),
  ];

  final List<_NavItem> _items = const [
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

    return Scaffold(
      body: _pages[_currentIndex],
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
                final isSelected = index == _currentIndex;
                final color = isSelected ? selectedColor : unselectedColor;
                final icon =
                    isSelected ? item.activeIcon ?? item.icon : item.icon;

                return Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _currentIndex = index),
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
