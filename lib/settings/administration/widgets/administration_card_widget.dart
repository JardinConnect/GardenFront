import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

class AdministrationCardWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final String? subtitle;
  final Color? iconColor;

  const AdministrationCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.subtitle,
    this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    return GardenCard(
      hasShadow: false,
      hasBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: GardenSpace.gapSm,
            children: [
              Icon(icon, color: iconColor ?? GardenColors.primary.shade500),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GardenTypography.bodyLg),
                  if (subtitle != null)
                    Text(subtitle!, style: GardenTypography.caption)
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: GardenSpace.paddingMd, vertical: GardenSpace.paddingLg),
            child: child,
          )
        ],
      ),
    );
  }

}