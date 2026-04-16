import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/cells/widgets/cells_cards_widget.dart';
import 'package:garden_connect/mobile/areas/pages/mobile_area_detail_page.dart';
import 'package:garden_connect/mobile/cells/pages/mobile_cell_detail_page.dart';
import 'package:garden_connect/mobile/dashboard/pages/mobile_activity_calendar_page.dart';
import 'package:garden_connect/mobile/common/widgets/mobile_header.dart';
import 'package:garden_ui/ui/foundation/padding/space_design_system.dart';
import 'package:garden_ui/ui/widgets/molecules/AnalyticsSummaryCard/analytics_summary_card.dart';
import 'package:go_router/go_router.dart';

import '../../../analytics/bloc/analytics_bloc.dart';
import '../../../areas/bloc/area_bloc.dart';
import '../../../areas/models/area.dart';
import '../../../cells/bloc/cell_bloc.dart';
import '../../../core/app_assets.dart';
import '../../../dashboard/widgets/expandable_card.dart';

class MobileHomePage extends StatelessWidget {
  final VoidCallback? onOpenCalendar;

  const MobileHomePage({super.key, this.onOpenCalendar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MobileHeader(
        actionsButtons: [
          IconButton(
            onPressed: () {
              if (onOpenCalendar != null) {
                onOpenCalendar!();
                return;
              }
              final router = GoRouter.maybeOf(context);
              if (router != null) {
                context.push('/m/home/calendar');
                return;
              }
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const MobileActivityCalendarPage(),
                ),
              );
            },
            icon: Icon(
              Icons.calendar_today_outlined,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          final analyticsState = context.watch<AnalyticsBloc>().state;
          final areaState = context.watch<AreaBloc>().state;
          final cellState = context.watch<CellBloc>().state;

          if (analyticsState is AnalyticsShimmer ||
              analyticsState is AnalyticsInitial ||
              areaState is AreasShimmer ||
              areaState is AreaInitial ||
              cellState is CellsShimmer ||
              cellState is CellInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (areaState is AreaError) {
            return Center(child: Text('Erreur: ${areaState.message}'));
          } else if (analyticsState is AnalyticsError) {
            return Center(child: Text('Erreur: ${analyticsState.message}'));
          } else if (cellState is CellError) {
            return Center(child: Text('Erreur: ${cellState.message}'));
          } else if (areaState is AreasLoaded &&
              cellState is CellsLoaded &&
              analyticsState is AnalyticsLoaded) {
            final areas = areaState.areas;
            final trackedAreas =
                Area.getAllAreasFlattened(
                  areas,
                ).where((area) => area.isTracked).toList();
            final trackedCells =
                cellState.cells.where((cell) => cell.isTracked).toList();

            return SingleChildScrollView(
              child: Column(
                children: [
                  ExpandableCard(
                    icon: AppAssets.radio,
                    title: 'Cellules en surveillance',
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 350),
                        child: CellsCardsWidget(
                          cells: trackedCells,
                          filter: null,
                          onPressed: (context, id) {
                            final router = GoRouter.maybeOf(context);
                            if (router != null) {
                              context.go('/m/cells/$id');
                              return;
                            }
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (_) => BlocProvider(
                                      create:
                                          (context) =>
                                              CellBloc()
                                                ..add(LoadCellDetail(id: id)),
                                      child: MobileCellDetailPage(id: id),
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  ExpandableCard(
                    icon: AppAssets.comparison,
                    title: 'Espaces en surveillance',
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = (constraints.maxWidth / 300)
                            .floor()
                            .clamp(1, 3);
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: GardenSpace.gapMd,
                                crossAxisSpacing: GardenSpace.gapMd,
                                mainAxisExtent: 220,
                              ),
                          itemCount: trackedAreas.length,
                          itemBuilder: (context, index) {
                            final area = trackedAreas[index];
                            return AnalyticsSummaryCard(
                              name: area.name,
                              onPressed: () {
                                context.read<AreaBloc>().add(SelectArea(area));
                                final router = GoRouter.maybeOf(context);
                                if (router != null) {
                                  context.go(
                                    '/m/areas/${area.id}',
                                    extra: area,
                                  );
                                  return;
                                }
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (_) => MobileAreaDetailPage(
                                          areaId: area.id,
                                          initialArea: area,
                                        ),
                                  ),
                                );
                              },
                              light: area.analytics.light!.first.value.toInt(),
                              rain:
                                  area.analytics.airHumidity!.first.value
                                      .toInt(),
                              humiditySurface:
                                  area.analytics.soilHumidity!.first.value
                                      .toInt(),
                              humidityDepth:
                                  area.analytics.deepSoilHumidity!.first.value
                                      .toInt(),
                              temperatureSurface:
                                  area.analytics.airTemperature!.first.value,
                              temperatureDepth:
                                  area.analytics.soilTemperature!.first.value,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Erreur de chargement des données'),
            );
          }
        },
      ),
    );
  }
}
