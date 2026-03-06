import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';

import '../../analytics/models/analytics.dart';
import '../../analytics/widgets/analytics_cards_grid.dart';
import '../../analytics/widgets/graphic_widget.dart';
import '../../common/widgets/custom_tab_selector.dart';
import '../../common/widgets/generic_dialog.dart';

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
    final tabs = ['Vue d\'ensemble', if (level != null) 'Historique'];

    return DefaultTabController(
      length: tabs.length,
      child: StyledDialog(
        title: title,
        widthFactor: 0.5,
        heightFactor: 0.5,
        contentPadding: const EdgeInsets.all(14),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (level != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Niveau $level', style: GardenTypography.bodyLg),
                  Text(
                    'Dernière mise à jour: il y a 2 minutes',
                    style: GardenTypography.caption,
                  ),
                ],
              ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: GardenSpace.paddingMd),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomTabSelector(tabs: tabs),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(14),
                    child: AnalyticsCardsGridWidget(analytics: analytics),
                  ),
                  if (level != null)
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(14),
                      child: GraphicWidget(analytics: analytics),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
