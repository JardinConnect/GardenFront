import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garden_ui/ui/components.dart';

class ExpandableCard extends StatefulWidget {
  final String? icon;
  final String title;
  final Widget? titleWidget;
  final bool initiallyExpanded;
  final bool? hasBorder;
  final bool? hasShadow;
  final Widget child;

  const ExpandableCard({
    super.key,
    this.icon,
    required this.title,
    this.titleWidget,
    this.initiallyExpanded = true,
    required this.child,
    this.hasBorder,
    this.hasShadow
  });

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: GardenCard(
        hasShadow: widget.hasShadow ?? true,
        hasBorder: widget.hasBorder ?? true,
        child: ExpansionTile(
          initiallyExpanded: widget.initiallyExpanded,
          onExpansionChanged: (value) {
            setState(() {
              _expanded = value;
            });
          },
          collapsedIconColor: primaryColor,
          iconColor: primaryColor,
          trailing: Icon(
            _expanded ? Icons.chevron_right : Icons.expand_more,
            color: primaryColor,
          ),
          shape: const Border(),
          title:
              widget.titleWidget ??
              Row(
                children: [
                  if (widget.icon != null)
                    SvgPicture.asset(widget.icon!, width: 24, height: 24),
                  if (widget.icon != null) const SizedBox(width: 10),
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}
