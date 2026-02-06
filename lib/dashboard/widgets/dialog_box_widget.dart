import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';

import '../../analytics/models/analytics.dart';
import '../../analytics/widgets/analytics_cards_grid.dart';
import '../../analytics/widgets/graphic_widget.dart';
import '../../common/widgets/custom_tab_selector.dart';

class DialogBoxWidget extends StatelessWidget {
  final String title;
  final int? level;
  final Analytics analytics;

  const DialogBoxWidget({
    super.key,
    required this.title,
    this.level,
    required this.analytics,
  });

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
                title,
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
                level != null
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Niveau $level', style: GardenTypography.bodyLg),
                        Text(
                          'Dernière mise à jour: il y a 2 minutes',
                          style: GardenTypography.caption,
                        ),
                      ],
                    )
                    : SizedBox.shrink(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: GardenSpace.paddingMd,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomTabSelector(
                      tabs: const ["Vues d'ensemble", "Historique"],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        padding: EdgeInsets.all(14),
                        child: AnalyticsCardsGridWidget(analytics: analytics),
                      ),
                      SingleChildScrollView(
                        padding: EdgeInsets.all(14),
                        child: GraphicWidget(analytics: analytics),
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
