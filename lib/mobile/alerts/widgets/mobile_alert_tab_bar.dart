import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';

enum MobileAlertFormTab { critical, warning, cells, danger }

/// Barre d'onglets du formulaire d'alerte mobile.
///
/// Affiche les onglets disponibles selon le mode (création ou édition).
/// L'onglet "Supprimer" n'est visible qu'en mode édition.
class MobileAlertTabBar extends StatelessWidget {
  /// Onglet actuellement sélectionné.
  final MobileAlertFormTab currentTab;

  /// Callback déclenché lors du changement d'onglet.
  final ValueChanged<MobileAlertFormTab> onTabChanged;

  /// Indique si le formulaire est en mode édition.
  final bool isEditing;

  const MobileAlertTabBar({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: GardenSpace.paddingLg),
      child: Row(
        children: [
          AlertTabItem(
            label: 'Critiques',
            icon: Icons.warning_rounded,
            isSelected: currentTab == MobileAlertFormTab.critical,
            selectedColor: GardenColors.primary.shade500,
            onTap: () => onTabChanged(MobileAlertFormTab.critical),
          ),
          SizedBox(width: GardenSpace.gapSm),
          AlertTabItem(
            label: 'Avertissements',
            icon: Icons.notifications_rounded,
            isSelected: currentTab == MobileAlertFormTab.warning,
            selectedColor: GardenColors.primary.shade500,
            onTap: () => onTabChanged(MobileAlertFormTab.warning),
          ),
          SizedBox(width: GardenSpace.gapSm),
          AlertTabItem(
            label: 'Cellules',
            icon: Icons.grid_view_rounded,
            isSelected: currentTab == MobileAlertFormTab.cells,
            selectedColor: GardenColors.primary.shade500,
            onTap: () => onTabChanged(MobileAlertFormTab.cells),
          ),
          if (isEditing) ...[
            SizedBox(width: GardenSpace.gapSm),
            AlertTabItem(
              label: 'Supprimer',
              icon: Icons.delete_rounded,
              isSelected: currentTab == MobileAlertFormTab.danger,
              selectedColor: Colors.red.shade600,
              unselectedColor: Colors.red.shade300,
              selectedBgColor: Colors.red.shade100,
              onTap: () => onTabChanged(MobileAlertFormTab.danger),
            ),
          ],
        ],
      ),
    );
  }
}

/// Élément individuel de la barre d'onglets.
class AlertTabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedBgColor;

  const AlertTabItem({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.selectedColor,
    this.unselectedColor,
    this.selectedBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = selectedColor ?? GardenColors.primary.shade500;
    final inactiveColor = unselectedColor ?? GardenColors.typography.shade200;
    final bgColor = isSelected
        ? (selectedBgColor ?? GardenColors.base.shade200)
        : Colors.transparent;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: GardenRadius.radiusSm,
            color: bgColor,
          ),
          padding: EdgeInsets.symmetric(vertical: GardenSpace.paddingXs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: isSelected ? activeColor : inactiveColor),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? activeColor : inactiveColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
