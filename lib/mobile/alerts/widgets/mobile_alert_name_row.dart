import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';

/// Champ de saisie du nom de l'alerte avec indicateur de validité du formulaire.
///
/// Affiche un [TextField] pour saisir le nom, et une icône de validation
/// cliquable qui s'active uniquement lorsque le formulaire est prêt à être soumis.
class MobileAlertNameRow extends StatelessWidget {
  /// Contrôleur du champ de texte.
  final TextEditingController controller;

  /// Indique si le formulaire est dans un état valide et soumettable.
  final bool isReady;

  /// Callback déclenché lors de la soumission du formulaire.
  final VoidCallback onSubmit;

  const MobileAlertNameRow({
    super.key,
    required this.controller,
    required this.isReady,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: GardenTypography.bodyLg,
            decoration: InputDecoration(
              hintText: 'Nom de l\'alerte',
              hintStyle: GardenTypography.bodyLg.copyWith(
                color: GardenColors.typography.shade200,
              ),
              border: OutlineInputBorder(
                borderRadius: GardenRadius.radiusMd,
                borderSide: BorderSide(color: GardenColors.base.shade700),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: GardenRadius.radiusMd,
                borderSide: BorderSide(color: GardenColors.base.shade700),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: GardenRadius.radiusMd,
                borderSide: BorderSide(
                  color: GardenColors.primary.shade500,
                  width: 1.5,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: GardenSpace.paddingMd,
                vertical: GardenSpace.paddingSm,
              ),
            ),
          ),
        ),
        SizedBox(width: GardenSpace.gapMd),
        GestureDetector(
          onTap: isReady ? onSubmit : null,
          child: Icon(
            Icons.check_box_outlined,
            size: 36,
            color: isReady
                ? GardenColors.primary.shade500
                : GardenColors.typography.shade100,
          ),
        ),
      ],
    );
  }
}
