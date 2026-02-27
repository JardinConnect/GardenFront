import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/utils/auth_extension.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:go_router/go_router.dart';

import '../../analytics/bloc/analytics_bloc.dart';
import '../../areas/bloc/area_bloc.dart';
import '../../areas/models/area.dart';
import '../../cells/bloc/cell_bloc.dart';
import '../../core/app_assets.dart';
import '../widgets/activity_sensors.dart';
import '../widgets/expandable_card.dart';
import '../widgets/hexagones_widget.dart';
import '../widgets/node_comparison.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;

    if (user == null) {
      return const Text('Utilisateur non connecté');
    }

    return Scaffold(
      body: Builder(
        builder: (context) {
          final analyticsState = context.watch<AnalyticsBloc>().state;
          final areaState = context.watch<AreaBloc>().state;
          final cellState = context.watch<CellBloc>().state;

          if (analyticsState is AnalyticsShimmer ||
              analyticsState is AnalyticsInitial ||
              areaState is AreasShimmer ||
              areaState is AreaInitial || cellState is CellsShimmer ||
              cellState is CellInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (areaState is AreaError) {
            return Center(child: Text('Erreur: ${areaState.message}'));
          } else if (analyticsState is AnalyticsError) {
            return Center(child: Text('Erreur: ${analyticsState.message}'));
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

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour ${user.firstName}',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 50),
                    HexagonesWidget(areas: areas),
                    ExpandableCard(
                      icon: AppAssets.activity,
                      title: 'Activité des capteurs (365 derniers jours)',
                      child: ActivitySensors(
                        analytics: analyticsState.analytics,
                      ),
                    ),
                    ExpandableCard(
                      icon: AppAssets.hexagon,
                      title: 'Comparaison entre noeuds',
                      child: NodeComparison(areas: areas),
                    ),
                    ExpandableCard(
                      icon: AppAssets.radio,
                      title: 'Cellules en surveillance',
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children:
                                trackedCells.map((cell) {
                                  return SizedBox(
                                    width: (constraints.maxWidth - 32) / 3,
                                    child: AnalyticsSummaryCard(
                                      name: cell.name,
                                      batteryPercentage: 89,
                                      onPressed:
                                          () => context.go('/cells/${cell.id}'),
                                      light:
                                          cell.analytics.light?.first.value
                                              .toInt() ??
                                          0,
                                      rain:
                                          cell
                                              .analytics
                                              .airHumidity
                                              ?.first
                                              .value
                                              .toInt() ??
                                          0,
                                      humiditySurface:
                                          cell
                                              .analytics
                                              .soilHumidity
                                              ?.first
                                              .value
                                              .toInt() ??
                                          0,
                                      humidityDepth:
                                          cell
                                              .analytics
                                              .deepSoilHumidity
                                              ?.first
                                              .value
                                              .toInt() ??
                                          0,
                                      temperatureSurface:
                                          cell
                                              .analytics
                                              .airTemperature
                                              ?.first
                                              .value ??
                                          0,
                                      temperatureDepth:
                                          cell
                                              .analytics
                                              .soilTemperature
                                              ?.first
                                              .value ??
                                          0,
                                    ),
                                  );
                                }).toList(),
                          );
                        },
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
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  mainAxisExtent: 220,
                                ),
                            itemCount: trackedAreas.length,
                            itemBuilder: (context, index) {
                              final area = trackedAreas[index];
                              return AnalyticsSummaryCard(
                                name: area.name,
                                onPressed: () {},
                                light:
                                    area.analytics.light!.first.value.toInt(),
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
