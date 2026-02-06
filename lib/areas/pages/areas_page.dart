import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/utils/auth_extension.dart';
import 'package:garden_connect/common/widgets/custom_tab_selector.dart';
import '../../areas/bloc/area_bloc.dart';
import '../../analytics/bloc/analytics_bloc.dart';
import '../widgets/tab_zones_widget.dart';

class AreasPage extends StatelessWidget {
  const AreasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;
    if (user == null) {
      return const Text('Utilisateur non connecté');
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AnalyticsBloc()..add(LoadAnalytics()),
            ),
            BlocProvider(create: (context) => AreaBloc()..add(LoadAreas())),
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
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Gestion des espaces',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          areaState.selectedCell == null
                              ? IconButton.filled(
                                onPressed: () {
                                  context.read<AreaBloc>().add(
                                    ToggleAnalyticsWidget(),
                                  );
                                },
                                icon: Icon(
                                  areaState.toggleAnalyticsWidget
                                      ? Icons.grid_view
                                      : Icons.show_chart,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                ),
                              )
                              : SizedBox.shrink(),
                        ],
                      ),
                      const SizedBox(height: 50),
                      CustomTabSelector(
                        tabs: const ["Zones", "Vue d'\ensemble"],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(
                              padding: EdgeInsets.all(14),
                              child: TabZonesWidget(
                                title: areaState.selectedArea?.name ?? "",
                                areas: areaState.areas,
                                selectedArea: areaState.selectedArea,
                                selectedCell: areaState.selectedCell,
                                isAreaSelected: areaState.isAreaSelected,
                                toggleAnalyticsWidget:
                                    areaState.toggleAnalyticsWidget,
                              ),
                            ),
                            SingleChildScrollView(
                              padding: EdgeInsets.all(14),
                              child: TabZonesWidget(
                                title: "NomDeLaFerme",
                                areas: areaState.areas,
                                isExpanded: false,
                                isOverview: true,
                                toggleAnalyticsWidget:
                                    areaState.toggleAnalyticsWidget,
                              ),
                            ),
                          ],
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
        ),
      ),
    );
  }
}
