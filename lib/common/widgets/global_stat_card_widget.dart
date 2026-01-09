import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';

class GlobalStatCardWidget extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String data;
  final int? level;

  const GlobalStatCardWidget({
    super.key,
    required this.title,
    this.icon,
    required this.data,
    this.level,
  });

  @override
  Widget build(BuildContext context) {
    return GardenCard(
      hasShadow: true,
      hasBorder: true,
      child: IntrinsicHeight(
        child: Row(
          children: [
            if (level != null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: LevelIndicator(level: level!)
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.headlineSmall),
                      if (icon != null)
                        Icon(
                          icon,
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        )
                      else
                        SizedBox.shrink(),
                    ],
                  ),
                  Text(data, style: Theme.of(context).textTheme.headlineLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
