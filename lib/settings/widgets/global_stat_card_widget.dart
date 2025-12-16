import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';

class GlobalStatCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String data;

  const GlobalStatCard({
    super.key,
    required this.title,
    required this.icon,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return GardenCard(
      hasShadow: true,
      hasBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
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
    );
  }
}
