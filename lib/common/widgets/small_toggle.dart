import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';

/// Version réduite (65%) du GardenToggle — usage mobile.
class SmallToggle extends StatelessWidget {
  final bool isEnabled;
  final ValueChanged<bool> onToggle;
  final IconData? enabledIcon;

  const SmallToggle({
    super.key,
    required this.isEnabled,
    required this.onToggle,
    this.enabledIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.75,
      alignment: Alignment.centerRight,
      child: GardenToggle(
        isEnabled: isEnabled,
        onToggle: onToggle,
        enabledIcon: enabledIcon,
      ),
    );
  }
}
