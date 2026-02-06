import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/areas/widgets/summary_zones_widget.dart';
import 'package:garden_ui/ui/components.dart';
import '../../cells/bloc/cell_bloc.dart';
import '../../cells/models/cell.dart';
import '../../cells/pages/cell_detail_page.dart';
import '../models/area.dart';
import '../bloc/area_bloc.dart';

class TabZonesWidget extends StatelessWidget {
  final String title;
  final List<Area> areas;
  final Area? selectedArea;
  final Cell? selectedCell;
  final bool isAreaSelected;
  final bool isExpanded;
  final bool isOverview;
  final bool toggleAnalyticsWidget;
  final bool toggleAreaTracking;

  const TabZonesWidget({
    super.key,
    required this.title,
    required this.areas,
    this.selectedArea,
    this.selectedCell,
    this.isAreaSelected = false,
    this.isExpanded = true,
    this.isOverview = false,
    this.toggleAnalyticsWidget = false,
    this.toggleAreaTracking = false,
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
            onTap:
                () =>
                    !isOverview
                        ? context.read<AreaBloc>().add(SelectCell(cell, area))
                        : null,
          ),
        ),
      );
    }

    return HierarchicalMenuItem(
      id: area.name,
      title: area.name,
      level: area.level,
      isExpanded: isOverview ? false : true,
      onTap:
          () =>
              !isOverview
                  ? context.read<AreaBloc>().add(SelectArea(area))
                  : null,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuItems =
        areas.map((area) => _areaToMenuItem(area, context)).toList();

    // Déterminer l'ID de l'item sélectionné
    String? selectedId;
    if (selectedCell != null) {
      selectedId = 'cell_${selectedCell!.name}';
    } else if (selectedArea != null) {
      selectedId = selectedArea!.name;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: HierarchicalMenu(
              items: menuItems,
              selectedItemId: selectedId,
            ),
          ),
        ),
        const SizedBox(width: 25),
        Flexible(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: _buildDetailsPanel(context),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsPanel(BuildContext context) {
    if (selectedCell != null) {
      return BlocProvider(
        key: ValueKey(selectedCell!.id),
        create: (_) => CellBloc()..add(LoadCellDetail(id: selectedCell!.id)),
        child: CellDetailPage(id: selectedCell!.id, isFromAreaPage: true),
      );
    }

    if (isOverview) {
      return SummaryZonesWidget(
        id: '',
        title: title,
        level: 0,
        areas: areas,
        analytics: areas.first.analytics,
        toggleAnalyticsWidget: toggleAnalyticsWidget,
        currentLevel: 0,
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
      id: areaToDisplay.id,
      title: areaToDisplay.name,
      level: areaToDisplay.level,
      areas: [areaToDisplay],
      analytics: areaToDisplay.analytics,
      toggleAnalyticsWidget: toggleAnalyticsWidget,
      currentLevel: areaToDisplay.level,
    );
  }
}
