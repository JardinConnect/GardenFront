import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ExpandableCard extends StatelessWidget {
  final String icon;
  final String title;
  final Widget child;

  ExpandableCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ExpansionTile(
        initiallyExpanded: true,
        shape: const Border(),
        title: Row(
          children: [
            SvgPicture.asset(icon, width: 24, height: 24),
            const SizedBox(width: 10),
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
        children: [Padding(padding: const EdgeInsets.all(14), child: child)],
      ),
    );
  }
}
