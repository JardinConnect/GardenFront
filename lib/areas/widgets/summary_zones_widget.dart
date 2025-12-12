import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

import '../../analytics/models/analytics.dart';
import '../../analytics/widgets/graphic_widget.dart';
import '../models/area.dart';

class SummaryZonesWidget extends StatelessWidget {
  final String title;
  final int level;
  final List<Area> areas;
  final Analytics? analytics;

  const SummaryZonesWidget({
    super.key,
    required this.title,
    required this.level,
    required this.areas,
    required this.analytics,
  });

  // Compte toutes les zones de chaque niveau, récursivement
  Map<int, int> _countAreasByLevel() {
    Map<int, int> levelCounts = {};

    void countRecursive(List<Area>? areaList) {
      if (areaList == null) return;

      for (var area in areaList) {
        levelCounts[area.level] = (levelCounts[area.level] ?? 0) + 1;

        // Parcourir récursivement les sous-zones
        if (area.areas != null && area.areas!.isNotEmpty) {
          countRecursive(area.areas);
        }
      }
    }

    countRecursive(areas);
    return levelCounts;
  }

  List<int> _getSortedLevels() {
    final levelCounts = _countAreasByLevel();
    final levels = levelCounts.keys.toList()..sort();
    return levels;
  }

  // Compte toutes les cellules, récursivement
  int _countTotalCells() {
    int totalCells = 0;

    void countCellsRecursive(List<Area>? areaList) {
      if (areaList == null) return;

      for (var area in areaList) {
        if (area.cells != null) {
          totalCells += area.cells!.length;
        }
        if (area.areas != null) {
          countCellsRecursive(area.areas);
        }
      }
    }

    countCellsRecursive(areas);
    return totalCells;
  }

  @override
  Widget build(BuildContext context) {
    final levelCounts = _countAreasByLevel();
    final sortedLevels = _getSortedLevels();
    final totalCells = _countTotalCells();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: GardenTypography.headingLg),
            Switch(value: true, onChanged: (bool value) {}),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          level == 0 ? 'Vue d\'ensemble' : 'Niveau $level',
          style: GardenTypography.caption.copyWith(fontSize: 16.0),
        ),
        const SizedBox(height: 16),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...sortedLevels.map((lvl) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: GardenCard(
                      child: Row(
                        children: [
                          LevelIndicator(level: lvl),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Niveau $lvl',
                                  style: GardenTypography.bodyLg,
                                ),
                                Text(
                                  '${levelCounts[lvl]}',
                                  style: GardenTypography.headingMd,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              if (totalCells > 0)
                Expanded(
                  child: GardenCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            '$totalCells',
                            style: GardenTypography.displayLg,
                          ),
                          const SizedBox(width: 10),
                          Text('Cellules', style: GardenTypography.bodyLg),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (analytics != null) ...[
          const SizedBox(height: 50),
          Text(
            'Moyenne des données des noeuds',
            style: GardenTypography.caption.copyWith(fontSize: 16.0),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Evolution des données', style: GardenTypography.headingLg),
              GraphicWidget(analytics: analytics!),
            ],
          ),
        ],
      ],
    );
  }
}
