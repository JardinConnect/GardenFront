import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/utils/auth_extension.dart';
import 'package:garden_ui/ui/components.dart';

import '../../areas/bloc/area_bloc.dart';
import '../../core/app_assets.dart';
import '../../analytics/bloc/analytics_bloc.dart';
import '../widgets/activity_sensors.dart';
import '../widgets/expandable_card.dart';
import '../../analytics/widgets/graphic_widget.dart';
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
      body: MultiBlocProvider(
        providers: [
          BlocProvider<AnalyticsBloc>(
            create: (context) => AnalyticsBloc()..add(LoadAnalytics()),
          ),
          BlocProvider<AreaBloc>(
            create: (context) => AreaBloc()..add(LoadAreas()),
          ),
        ],
        child: Builder(
          builder: (context) {
            final analyticsState = context.watch<AnalyticsBloc>().state;
            final areaState = context.watch<AreaBloc>().state;

            if (analyticsState is AnalyticsShimmer ||
                analyticsState is AnalyticsInitial ||
                areaState is AreasShimmer ||
                areaState is AreaInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (areaState is AreaError) {
              return Center(child: Text('Erreur: ${areaState.message}'));
            } else if (analyticsState is AnalyticsError) {
              return Center(child: Text('Erreur: ${analyticsState.message}'));
            } else if (areaState is AreasLoaded) {
              final areas = areaState.areas;

              final allAreas = <dynamic>[];
              for (var area in areas) {
                allAreas.add(area);
                final subareas = area.areas;
                if (subareas != null && subareas.isNotEmpty) {
                  allAreas.addAll(subareas);
                }
              }

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
                          activityData: List.generate(365, (index) {
                            if (index % 7 == 0 || index % 7 == 6) return 0;
                            if (index % 10 < 3) return 1;
                            if (index % 10 < 6) return 2;
                            return 3;
                          }),
                        ),
                      ),
                      ExpandableCard(
                        icon: AppAssets.hexagon,
                        title: 'Comparaison entre noeuds',
                        child: NodeComparison(),
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
                                  allAreas.map((area) {
                                    return SizedBox(
                                      width: (constraints.maxWidth - 32) / 3,
                                      child: AnalyticsSummaryCard(
                                        name: area.value,
                                        batteryPercentage: 89,
                                        onPressed: () {},
                                        light: 3,
                                        rain: 7,
                                        humiditySurface: 2,
                                        humidityDepth: 8,
                                        temperatureSurface: 15,
                                        temperatureDepth: 18,
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
                            return Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children:
                                  allAreas.map((area) {
                                    return SizedBox(
                                      width: (constraints.maxWidth - 32) / 3,
                                      child: AnalyticsSummaryCard(
                                        name: area.value,
                                        onPressed: () {},
                                        light: 3,
                                        rain: 7,
                                        humiditySurface: 2,
                                        humidityDepth: 8,
                                        temperatureSurface: 15,
                                        temperatureDepth: 18,
                                      ),
                                    );
                                  }).toList(),
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
      ),
    );
  }
}
