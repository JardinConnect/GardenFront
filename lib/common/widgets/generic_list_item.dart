import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:garden_ui/ui/widgets/atoms/Card/card.dart';

class GenericListItem {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final Widget? extraWidget;
  final Widget? trailingWidget;

  GenericListItem({
    required this.label,
    this.icon,
    this.onTap,
    this.onEdit,
    this.extraWidget,
    this.trailingWidget,
  });
}

class GenericListWidget extends StatelessWidget {
  final List<GenericListItem> items;

  const GenericListWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(GardenSpace.paddingXs),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(height: GardenSpace.gapSm),
        itemBuilder: (_, index) => _GenericListItemRow(item: items[index]),
      ),
    );
  }
}

class _GenericListItemRow extends StatefulWidget {
  final GenericListItem item;

  const _GenericListItemRow({required this.item});

  @override
  State<_GenericListItemRow> createState() => _GenericListItemRowState();
}

class _GenericListItemRowState extends State<_GenericListItemRow> {
  bool _isIconHovered = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GardenCard(
        hasShadow: true,
        hasBorder: true,
        onTap: widget.item.onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 300,
                    child: Text(
                      widget.item.label,
                      style: GardenTypography.bodyLg,
                    ),
                  ),
                  if (widget.item.extraWidget != null) ...[
                    SizedBox(width: GardenSpace.gapSm),
                    widget.item.extraWidget!,
                  ],
                ],
              ),
            ),
            widget.item.trailingWidget ??
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => _isIconHovered = true),
                  onExit: (_) => setState(() => _isIconHovered = false),
                  child: GestureDetector(
                    onTap: widget.item.onEdit,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.all(GardenSpace.paddingSm),
                      decoration: BoxDecoration(
                        color: _isIconHovered
                            ? primaryColor.withValues(alpha: 0.1)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(widget.item.icon, color: primaryColor),
                    ),
                  ),
                ),
          ],
        ),
    );
  }
}
