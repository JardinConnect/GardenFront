import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';

class GlobalStatCardWidget extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String data;
  final String? color;

  const GlobalStatCardWidget({
    super.key,
    required this.title,
    this.icon,
    required this.data,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GardenCard(
      hasShadow: true,
      hasBorder: true,
      child: Row(
        children: [
          if (color != null)
            Container(
              width: 5,
              height: 64,
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Color(int.parse(color!)),
                borderRadius: BorderRadius.circular(4),
              ),
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
                    ),
                  ],
                ),
                Text(data, style: Theme.of(context).textTheme.headlineLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
