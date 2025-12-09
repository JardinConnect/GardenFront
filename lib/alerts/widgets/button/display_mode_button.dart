import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';

/// Bouton pour changer le mode d'affichage des alertes (liste/cartes)
class DisplayModeButton extends StatelessWidget {
  /// Le mode d'affichage actuel
  final bool isListMode;

  /// Callback appelé lors du changement de mode
  final VoidCallback onToggle;

  const DisplayModeButton({
    super.key,
    required this.isListMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: GardenColors.primary.shade500,
      ),
      child: IconButton(
        onPressed: onToggle,
        icon: Icon(
          isListMode 
              ? Icons.dashboard 
              : Icons.format_list_bulleted,
          color: GardenColors.primary.shade50,
        ),
        tooltip: isListMode 
            ? 'Affichage en cartes alex'
            : 'Affichage en liste alex',
      ),
    );
  }
}