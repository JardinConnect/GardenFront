import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/areas/bloc/area_bloc.dart';
import 'package:garden_connect/areas/models/area.dart';
import 'package:garden_connect/cells/bloc/cell_bloc.dart';
import 'package:garden_connect/mobile/areas/pages/mobile_area_detail_page.dart';
import 'package:garden_connect/mobile/cells/pages/mobile_cell_detail_page.dart';
import 'package:garden_connect/mobile/common/widgets/mobile_header.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:go_router/go_router.dart';

class MobileSpacesPage extends StatelessWidget {
  const MobileSpacesPage({super.key});

  HierarchicalMenuItem _areaToMenuItem(Area area, BuildContext context) {
    final List<HierarchicalMenuItem> children = [];

    if (area.areas != null && area.areas!.isNotEmpty) {
      children.addAll(area.areas!.map((child) => _areaToMenuItem(child, context)));
    }

    if (area.cells != null && area.cells!.isNotEmpty) {
      children.addAll(
        area.cells!.map(
          (cell) => HierarchicalMenuItem(
            id: 'cell_${cell.name}',
            title: cell.name,
            level: area.level + 1,
            onTap: () {
              final router = GoRouter.maybeOf(context);
              if (router != null) {
                context.push('/m/cells/${cell.id}');
                return;
              }
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider(
                        create:
                            (_) => CellBloc()..add(LoadCellDetail(id: cell.id)),
                        child: MobileCellDetailPage(id: cell.id),
                      ),
                ),
              );
            },
          ),
        ),
      );
    }

    return HierarchicalMenuItem(
      id: area.id,
      title: area.name,
      level: area.level,
      isExpanded: true,
      onTap: () {
        context.read<AreaBloc>().add(SelectArea(area));
        final router = GoRouter.maybeOf(context);
        if (router != null) {
          context.push('/m/spaces/${area.id}', extra: area);
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (_) => MobileAreaDetailPage(areaId: area.id, initialArea: area),
          ),
        );
      },
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MobileHeader(),
      body: BlocBuilder<AreaBloc, AreaState>(
        builder: (context, state) {
          if (state is AreasShimmer || state is AreaInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AreaError) {
            return Center(child: Text('Erreur: ${state.message}'));
          }
          if (state is AreasLoaded) {
            final menuItems =
                state.areas.map((area) => _areaToMenuItem(area, context)).toList();
            final selectedId = state.selectedArea?.id;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: GardenSpace.paddingLg),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: GardenSpace.gapMd),
                    Text(
                      'Espaces',
                      style: GardenTypography.headingSm,
                    ),
                    SizedBox(height: GardenSpace.gapMd),
                    HierarchicalMenu(
                      items: menuItems,
                      selectedItemId: selectedId,
                    ),
                    SizedBox(height: GardenSpace.gapLg),
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text('Erreur de chargement des données'));
        },
      ),
    );
  }
}
