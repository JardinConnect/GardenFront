import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/areas/widgets/summary_zones_widget.dart';
import 'package:garden_ui/ui/components.dart';
import '../../cells/models/cell.dart';
import '../models/area.dart';
import '../bloc/area_bloc.dart';
import 'add_area_form_widget.dart';

class TabZonesWidget extends StatelessWidget {
  final String title;
  final List<Area> areas;
  final Area? selectedArea;
  final Cell? selectedCell;
  final bool isAreaSelected;
  final bool isExpanded;
  final bool isOverview;
  final bool showAddForm;

  const TabZonesWidget({
    super.key,
    required this.title,
    required this.areas,
    this.selectedArea,
    this.selectedCell,
    this.isAreaSelected = false,
    this.isExpanded = true,
    this.isOverview = false,
    this.showAddForm = false,
  });

  HierarchicalMenuItem _areaToMenuItem(Area area, BuildContext context) {
    final List<HierarchicalMenuItem> children = [];

    if (area.areas != null && area.areas!.isNotEmpty) {
      children.addAll(
        area.areas!.map((subArea) => _areaToMenuItem(subArea, context)),
      );
    }

    if (area.cells != null && area.cells!.isNotEmpty) {
      children.addAll(
        area.cells!.map(
          (cell) => HierarchicalMenuItem(
            id: 'cell_${cell.name}',
            title: cell.name,
            level: area.level + 1,
            isExpanded: isExpanded,
            onTap: () {
              print(
                'Cellule sélectionnée: ${cell.name} dans la zone ${area.name}',
              );
              context.read<AreaBloc>().add(SelectCell(cell, area));
            },
          ),
        ),
      );
    }

    return HierarchicalMenuItem(
      id: area.name,
      title: area.name,
      level: area.level,
      isExpanded: isExpanded,
      onTap: () {
        print('Zone sélectionnée: ${area.name}');
        context.read<AreaBloc>().add(SelectArea(area));
      },
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuItems =
        areas.map((area) => _areaToMenuItem(area, context)).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: HierarchicalMenu(items: menuItems),
          ),
        ),
        const SizedBox(width: 25),
        Flexible(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: _buildDetailsPanel(),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsPanel() {
    if (showAddForm) {
      return AddAreaFormWidget(availableAreas: areas);
    }

    if (isOverview) {
      return SummaryZonesWidget(
        title: title,
        level: 0,
        areas: areas,
        analytics: null,
      );
    }

    final areaToDisplay =
        selectedArea ?? (areas.isNotEmpty ? areas.first : null);

    if (areaToDisplay == null) {
      return Center(
        child: Text(
          'Aucune zone disponible',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return SummaryZonesWidget(
      title: areaToDisplay.name,
      level: areaToDisplay.level,
      areas: areaToDisplay.areas ?? [],
      analytics: areaToDisplay.analytics,
    );
  }
}
