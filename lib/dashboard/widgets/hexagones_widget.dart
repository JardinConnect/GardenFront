import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';

import '../../areas/models/area.dart';
import 'hexagon_dialog_box_widget.dart';

class HexagonesWidget extends StatefulWidget {
  final List<Area> areas;

  const HexagonesWidget({super.key, required this.areas});

  @override
  State<HexagonesWidget> createState() => _HexagonesWidgetState();
}

class _HexagonesWidgetState extends State<HexagonesWidget> {
  int _selectedLevel = 1;

  // Récupère tous les niveaux disponibles dans les areas
  // Récupère tous les niveaux disponibles de manière récursive
  List<int> _getAvailableLevels() {
    final levels = <int>{};

    void extractLevels(Area area) {
      levels.add(area.level);
      if (area.areas != null) {
        for (var subArea in area.areas!) {
          extractLevels(subArea);
        }
      }
    }

    for (var area in widget.areas) {
      extractLevels(area);
    }

    return levels.toList()..sort();
  }

  // Filtre les areas par niveau sélectionné de manière récursive
  List<Area> _getFilteredAreas() {
    final filteredAreas = <Area>[];

    void collectAreasByLevel(Area area) {
      if (area.level == _selectedLevel) {
        filteredAreas.add(area);
      }
      if (area.areas != null) {
        for (var subArea in area.areas!) {
          collectAreasByLevel(subArea);
        }
      }
    }

    for (var area in widget.areas) {
      collectAreasByLevel(area);
    }

    return filteredAreas;
  }

  // // Compte le nombre total de nœuds actifs
  // int _countActiveNodes() {
  //   int count = 0;
  //   for (var area in widget.areas) {
  //     count++; // L'area elle-même
  //     if (area.areas != null) {
  //       count += area.areas!.length; // Les sous-areas
  //       for (var subArea in area.areas!) {
  //         if (subArea.cells != null) {
  //           count += subArea.cells!.length; // Les cellules
  //         }
  //       }
  //     }
  //   }
  //   return count;
  // }

  List<Widget> _buildHexagons(BuildContext context, List<Area> filteredAreas) {
    return filteredAreas.map((area) {
      return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder:
                (BuildContext context) => HexagonDialogBoxWidget(area: area),
          );
        },
        child: HexagonWidget.flat(
          width: 125,
          color: Theme.of(context).colorScheme.primary,
          padding: 16.0,
          child: Center(
            child: SizedBox(
              width: 80,
              child: Text(
                area.name,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final availableLevels = _getAvailableLevels();
    final filteredAreas = _getFilteredAreas();
    // final activeNodesCount = _countActiveNodes();

    return Column(
      children: [
        Row(
          children: [
            Text(
              'Vos Espaces',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(width: 25),
            DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedLevel,
                autofocus: true,
                isDense: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                items:
                    availableLevels.map((int level) {
                      return DropdownMenuItem<int>(
                        value: level,
                        child: Text(
                          'Niveau $level',
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                onChanged: (int? newLevel) {
                  if (newLevel != null) {
                    setState(() {
                      _selectedLevel = newLevel;
                    });
                  }
                },
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                child: Text(
                  '18 nœuds actifs',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        filteredAreas.isEmpty
            ? const Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'Aucune zone disponible pour ce niveau',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
            : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildHexagons(context, filteredAreas),
            ),
      ],
    );
  }
}
