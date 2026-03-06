import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';

/// Composant générique pour afficher une liste d'éléments avec une icône et une action au clic.
class GenericListItem {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final Widget? extraWidget;
  final Widget? trailingWidget;
  // Active le highlight au survol
  final bool hoverable;

  GenericListItem({
    required this.label,
    this.icon,
    this.onTap,
    this.onEdit,
    this.extraWidget,
    this.trailingWidget,
    this.hoverable = false,
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

class _GenericListItemRow extends StatelessWidget {
  final GenericListItem item;

  const _GenericListItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: GardenColors.base.shade50,
        borderRadius: GardenRadius.radiusMd,
        border: Border.all(color: GardenColors.base.shade300, width: 1),
        boxShadow: GardenShadow.shadowMd,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: GardenRadius.radiusMd,
        child: InkWell(
          onTap: item.onTap,
          borderRadius: GardenRadius.radiusMd,
          hoverColor: item.hoverable ? primaryColor.withValues(alpha: 0.05) : Colors.transparent,
          mouseCursor: item.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
          child: Padding(
            padding: EdgeInsets.all(GardenSpace.paddingMd),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 300,
                      child: Text(item.label, style: GardenTypography.bodyLg),
                    ),
                    if (item.extraWidget != null) ...[
                      SizedBox(width: GardenSpace.gapSm),
                      item.extraWidget!,
                    ],
                  ],
                ),
                item.trailingWidget ??
                    GestureDetector(
                      onTap: item.onEdit,
                      child: Padding(
                        padding: EdgeInsets.all(GardenSpace.paddingXs),
                        child: Icon(item.icon, color: primaryColor),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}