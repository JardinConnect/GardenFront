import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';

class BackTextButton extends StatelessWidget {
  final VoidCallback backFunction;

  const BackTextButton({super.key, required this.backFunction});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: backFunction,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: GardenSpace.gapXs,
        children: [
          Icon(Icons.arrow_back_ios_new_outlined, size: 12, color: GardenColors.typography.shade400),
          Text('Retour', style: GardenTypography.bodyMd,),
        ],
      ),
    );
  }
}
