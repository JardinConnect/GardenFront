import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';

class TooltipWidget extends StatelessWidget {
  final String title;
  final String content;
  final bool isCentered;
  final bool isReversed;

  const TooltipWidget({
    super.key,
    required this.title,
    required this.content,
    this.isCentered = false,
    this.isReversed = false,
  });

  @override
  Widget build(BuildContext context) {
    final TextAlign textAlign = isCentered ? TextAlign.center : TextAlign.start;
    return Column(
      verticalDirection:
          isReversed ? VerticalDirection.up : VerticalDirection.down,
      crossAxisAlignment: isCentered ?
          CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          textAlign: textAlign,
        ),
        const SizedBox(height: 5),
        Text(
          content,
          style: GardenTypography.caption.copyWith(
            color: GardenColors.typography.shade200,
          ),
          textAlign: textAlign,
        ),
      ],
    );
  }
}
