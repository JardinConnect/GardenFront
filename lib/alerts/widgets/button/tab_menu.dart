import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';

/// Les différents onglets disponibles dans la page d'alertes
enum AlertTabType {
  alerts('Alertes'),
  history('Historique');

  const AlertTabType(this.label);
  final String label;
}

/// Widget pour le menu à onglets de la page d'alertes
class AlertTabMenu extends StatelessWidget {
  /// L'onglet actuellement sélectionné
  final AlertTabType selectedTab;

  /// Callback appelé lors de la sélection d'un onglet
  final ValueChanged<AlertTabType> onTabSelected;

  const AlertTabMenu({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: AlertTabType.values.map((tab) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TabItem(
              label: tab.label,
              isSelected: selectedTab == tab,
              onTap: () => onTabSelected(tab),
            ),
          );
        }).toList(),
      ),
    );
  }
}
