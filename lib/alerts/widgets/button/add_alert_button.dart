import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';

/// Bouton pour ajouter une nouvelle alerte
class AddAlertButton extends StatelessWidget {
  /// Callback appelé lors du clic sur le bouton
  final VoidCallback onPressed;

  const AddAlertButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: GardenColors.primary.shade500,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          Icons.add,
          color: GardenColors.primary.shade50,
        ),
        tooltip: 'Ajouter une alerte',
      ),
    );
  }
}