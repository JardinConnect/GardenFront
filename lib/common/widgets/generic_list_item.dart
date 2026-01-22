import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

/**
 * Composant générique pour afficher une liste d'éléments avec une icône et une action au clic.
 */
class GenericListItem {
  final String label;
  final IconData icon;
  final VoidCallback? onTap; // Clic sur la ligne -> mode vue
  final VoidCallback? onEdit; // Clic sur l'icône -> mode édition

  GenericListItem({
    required this.label,
    required this.icon,
    this.onTap,
    this.onEdit,
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
        separatorBuilder:
            (context, index) => SizedBox(height: GardenSpace.gapSm),
        itemBuilder: (context, index) {
          final item = items[index];

          return GestureDetector(
            onTap: item.onTap,
            child: GardenCard(
              hasBorder: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(item.label, style: GardenTypography.bodyLg),
                  ),
                  GestureDetector(
                    onTap: item.onEdit,
                    child: Padding(
                      padding: EdgeInsets.all(GardenSpace.paddingXs),
                      child: Icon(
                        item.icon,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
