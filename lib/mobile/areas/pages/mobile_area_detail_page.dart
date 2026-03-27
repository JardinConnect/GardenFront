import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/areas/bloc/area_bloc.dart';
import 'package:garden_connect/areas/models/area.dart';
import 'package:garden_connect/areas/widgets/summary_zones_widget.dart';
import 'package:garden_connect/mobile/common/widgets/mobile_header.dart';
import 'package:garden_ui/ui/design_system.dart';

class MobileAreaDetailPage extends StatelessWidget {
  final String areaId;
  final Area? initialArea;

  const MobileAreaDetailPage({
    super.key,
    required this.areaId,
    this.initialArea,
  });

  Area? _findAreaById(List<Area> areas, String id) {
    for (final area in areas) {
      if (area.id == id) {
        return area;
      }
      final children = area.areas;
      if (children != null && children.isNotEmpty) {
        final found = _findAreaById(children, id);
        if (found != null) {
          return found;
        }
      }
    }
    return null;
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
            final area = initialArea ?? _findAreaById(state.areas, areaId);
            if (area == null) {
              return const Center(child: Text('Espace introuvable'));
            }

            if (state.selectedArea?.id != area.id) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<AreaBloc>().add(SelectArea(area));
              });
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: GardenSpace.paddingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: GardenSpace.gapMd),
                  SummaryZonesWidget(
                    id: area.id,
                    title: area.name,
                    level: area.level,
                    areas: [area],
                    analytics: area.analytics,
                    toggleAnalyticsWidget: false,
                    currentLevel: area.level,
                  ),
                  SizedBox(height: GardenSpace.gapLg),
                ],
              ),
            );
          }

          return const Center(child: Text('Erreur de chargement des données'));
        },
      ),
    );
  }
}
