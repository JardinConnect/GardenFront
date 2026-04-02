import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';

/// Widget générique d'état vide affiché lorsqu'une liste ou une section
/// ne contient aucun élément à afficher.
class EmptyStateWidget extends StatelessWidget {
  /// Icône principale illustrant l'état vide.
  final IconData icon;

  /// Message principal affiché sous l'icône.
  final String message;

  /// Message secondaire optionnel (sous-titre).
  final String? subtitle;

  /// Couleur de l'icône et du texte. Par défaut : gris clair.
  final Color? color;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.message,
    this.subtitle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? GardenColors.typography.shade200;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(GardenSpace.paddingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: effectiveColor),
            SizedBox(height: GardenSpace.gapMd),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GardenTypography.bodyLg.copyWith(
                color: GardenColors.typography.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: GardenSpace.gapSm),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: GardenTypography.bodyMd.copyWith(
                  color: GardenColors.typography.shade300,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
