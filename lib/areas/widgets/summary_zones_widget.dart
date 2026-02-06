import 'package:flutter/material.dart';
import 'package:garden_connect/analytics/widgets/analytics_cards_grid.dart';
import 'package:garden_connect/analytics/widgets/analytics_list_widget.dart';
import 'package:garden_connect/cells/widgets/cells_list_widget.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../analytics/models/analytics.dart';
import '../../analytics/widgets/graphic_widget.dart';
import '../../cells/models/cell.dart';
import '../bloc/area_bloc.dart';
import '../models/area.dart';

class SummaryZonesWidget extends StatefulWidget {
  final String id;
  final String title;
  final int level;
  final List<Area> areas;
  final Analytics? analytics;
  final bool toggleAnalyticsWidget;
  final int currentLevel;

  const SummaryZonesWidget({
    super.key,
    required this.id,
    required this.title,
    required this.level,
    required this.areas,
    required this.analytics,
    required this.toggleAnalyticsWidget,
    required this.currentLevel,
  });

  @override
  State<SummaryZonesWidget> createState() => _SummaryZonesWidgetState();
}

class _SummaryZonesWidgetState extends State<SummaryZonesWidget> {
  Map<int, int> _countAreasByLevel() {
    Map<int, int> levelCounts = {};

    void countRecursive(List<Area>? areaList) {
      if (areaList == null) return;

      for (var area in areaList) {
        if (area.level != widget.currentLevel) {
          levelCounts[area.level] = (levelCounts[area.level] ?? 0) + 1;
        }

        if (area.areas != null && area.areas!.isNotEmpty) {
          countRecursive(area.areas);
        }
      }
    }

    countRecursive(widget.areas);
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

    countCellsRecursive(widget.areas);
    return totalCells;
  }

  List<Cell> _extractCells() {
    List<Cell> result = [];

    void extractRecursive(List<Area>? areaList) {
      if (areaList == null) return;

      for (var area in areaList) {
        if (area.cells != null) {
          result.addAll(area.cells!);
        }
        if (area.areas != null) {
          extractRecursive(area.areas);
        }
      }
    }

    extractRecursive(widget.areas);
    return result;
  }

  List<Area> _extractAreas(int level) {
    List<Area> result = [];

    void extractRecursive(List<Area>? areaList) {
      if (areaList == null) return;

      for (var area in areaList) {
        if (area.level == level) {
          result.add(area);
        }

        if (area.areas != null && area.areas!.isNotEmpty) {
          extractRecursive(area.areas);
        }
      }
    }

    extractRecursive(widget.areas);
    return result;
  }

  void _onBaseItemPressed(BuildContext context, String id) {
    print("BaseItem pressed: $id");
  }

  @override
  Widget build(BuildContext context) {
    final levelCounts = _countAreasByLevel();
    final sortedLevels = _getSortedLevels();
    final totalCells = _countTotalCells();
    final cells = _extractCells();

    final state = context.watch<AreaBloc>().state;
    final showingCellsList = state is AreasLoaded && state.showCellsListWidget;
    final showingAreasList = state is AreasLoaded && state.showAreasListWidget;
    final isTracked =
        state is AreasLoaded && (state.selectedArea?.isTracked ?? false);
    final selectedLevel = state is AreasLoaded ? state.selectedLevel : null;

    final areas =
        selectedLevel != null ? _extractAreas(selectedLevel) : <Area>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(widget.title, style: GardenTypography.headingLg),
            if (widget.level > 0)
              GardenToggle(
                isEnabled: isTracked,
                enabledIcon: Icons.visibility_outlined,
                disabledIcon: Icons.visibility_off_outlined,
                onToggle: (bool value) {
                  context.read<AreaBloc>().add(ToggleAreaTracking());
                },
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          widget.level == 0 ? 'Vue d\'ensemble' : 'Niveau ${widget.level}',
          style: GardenTypography.caption.copyWith(fontSize: 16.0),
        ),
        const SizedBox(height: 16),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...sortedLevels.map((lvl) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      print('Show Areas List Widget for level $lvl');
                      context.read<AreaBloc>().add(
                        ShowAreasListWidget(level: lvl),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GardenCard(
                        backgroundColor:
                            showingAreasList && selectedLevel == lvl
                                ? GardenColors.base.shade200
                                : null,
                        child: Row(
                          children: [
                            LevelIndicator(level: lvl),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                  ),
                );
              }),
              if (totalCells > 0)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      print('Show Cells List Widget');
                      context.read<AreaBloc>().add(ShowCellsListWidget());
                    },
                    child: GardenCard(
                      backgroundColor:
                          showingCellsList ? GardenColors.base.shade200 : null,
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
                ),
            ],
          ),
        ),
        if (widget.analytics != null) ...[
          const SizedBox(height: 50),
          Text(
            'Moyenne des données des noeuds',
            style: GardenTypography.caption.copyWith(fontSize: 16.0),
          ),
          const SizedBox(height: 16),
          if (showingCellsList)
            AnalyticsListWidget(items: cells, onPressed: _onBaseItemPressed)
          else if (showingAreasList)
            AnalyticsListWidget(items: areas, onPressed: _onBaseItemPressed)
          else ...[
            if (widget.toggleAnalyticsWidget)
              Text('Evolution des données', style: GardenTypography.headingLg),
            widget.toggleAnalyticsWidget
                ? GraphicWidget(analytics: widget.analytics!)
                : AnalyticsCardsGridWidget(analytics: widget.analytics!),
          ],
        ],
      ],
    );
  }
}
