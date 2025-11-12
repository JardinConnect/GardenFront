import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/utils/auth_extension.dart';

import '../../core/app_assets.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/activity_sensors.dart';
import '../widgets/expandable_card.dart';
import '../widgets/graphic_widget.dart';
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
      body: BlocProvider(
        create: (context) => DashboardBloc(),
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardAnalyticsShimmer ||
                state is DashboardInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DashboardAnalyticsLoaded) {
              final analytics = state.analytics;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bonjour ${user.username}',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 50),
                      HexagonesWidget(
                        areas: ['Espace 1', 'Espace 2', 'Espace 3'],
                      ),
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
                        child: Container(),
                      ),
                      ExpandableCard(
                        icon: AppAssets.comparison,
                        title: 'Espaces en surveillance',
                        child: Container(),
                      ),
                      const SizedBox(height: 20),
                      GraphicWidget(analytics: analytics),
                    ],
                  ),
                ),
              );
            } else if (state is DashboardError) {
              return Center(child: Text('Erreur: ${state.message}'));
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
