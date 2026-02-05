import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';

class TitleViewWidget extends StatelessWidget {
  final String title;
  final String content;

  const TitleViewWidget({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GardenTypography.headingXl),
        const SizedBox(height: 8),
        Text(content, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
