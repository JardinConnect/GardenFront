import 'package:flutter/material.dart';
import 'package:garden_connect/common/widgets/wip_widget.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:garden_ui/ui/foundation/color/color_design_system.dart';

import '../../analytics/widgets/graphic_widget.dart';
import '../../areas/models/area.dart';
import '../../common/widgets/custom_tab_selector.dart';

class HexagonDialogBoxWidget extends StatelessWidget {
  final Area area;

  const HexagonDialogBoxWidget({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        title: Container(
          color: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                area.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close_rounded),
                color: Theme.of(context).colorScheme.onPrimary,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.all(14),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Niveau ${area.level}',
                      style: GardenTypography.bodyLg,
                    ),
                    Text(
                      'Dernière mise à jour: il y a 2 minutes',
                      style: GardenTypography.caption,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: GardenSpace.paddingMd,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomTabSelector(
                      tabs: const [
                        "Vues d'ensemble",
                        "Historique",
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        padding: EdgeInsets.all(14),
                        child: WorkInProgressWidget(),
                      ),
                      SingleChildScrollView(
                        padding: EdgeInsets.all(14),
                        child:
                            area.analytics != null
                                ? GraphicWidget(analytics: area.analytics!)
                                : Text("Aucune donnée disponible"),
                      ),
                    ],
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
