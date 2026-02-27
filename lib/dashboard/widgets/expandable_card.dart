import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garden_ui/ui/components.dart';

class ExpandableCard extends StatelessWidget {
  final String? icon;
  final String title;
  final bool? hasBorder;
  final bool? hasShadow;
  final Widget child;

  const ExpandableCard({
    super.key,
    this.icon,
    required this.title,
    required this.child,
    this.hasBorder,
    this.hasShadow
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GardenCard(
        hasShadow: hasShadow ?? true,
        hasBorder: hasBorder ?? true,
        child: ExpansionTile(
          initiallyExpanded: true,
          collapsedIconColor: Theme.of(context).colorScheme.primary,
          shape: const Border(),
          title: Row(
            children: [
              if(icon != null)
                SvgPicture.asset(icon!, width: 24, height: 24),

              const SizedBox(width: 10),
              Text(title, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          children: [Padding(padding: const EdgeInsets.all(14), child: child)],
        ),
      ),
    );
  }
}
