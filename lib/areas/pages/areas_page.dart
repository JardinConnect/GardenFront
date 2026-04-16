import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/utils/auth_extension.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:go_router/go_router.dart';
import '../../areas/bloc/area_bloc.dart';
import '../../analytics/bloc/analytics_bloc.dart';
import '../../common/widgets/page_header.dart';
import '../models/area.dart';
import '../widgets/tab_zones_widget.dart';

class AreasPage extends StatefulWidget {
  const AreasPage({super.key});

  @override
  State<AreasPage> createState() => _AreasPageState();
}

class _AreasPageState extends State<AreasPage> {
  String? _handledAreaIdFromQuery;

  void _selectAreaFromQueryIfNeeded(AreasLoaded areaState) {
    final areaIdFromQuery =
        GoRouterState.of(context).uri.queryParameters['areaId'];

    if (areaIdFromQuery == null ||
        areaIdFromQuery.isEmpty ||
        areaIdFromQuery == _handledAreaIdFromQuery) {
      return;
    }

    _handledAreaIdFromQuery = areaIdFromQuery;
    final areaToSelect = Area.findAreaById(areaState.areas, areaIdFromQuery);
    if (areaToSelect == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<AreaBloc>().add(SelectArea(areaToSelect));
    });
  }

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
            _selectAreaFromQueryIfNeeded(areaState);
            return Padding(
              padding: EdgeInsets.all(GardenSpace.paddingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeader(
                    title: 'Gestion des espaces',
                    actions: [
                      if (areaState.selectedCell == null)
                        IconButton.filled(
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
                        ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(GardenSpace.paddingMd),
                      child: TabZonesWidget(
                        title: areaState.selectedArea?.name ?? "",
                        areas: areaState.areas,
                        selectedArea: areaState.selectedArea,
                        selectedCell: areaState.selectedCell,
                        isAreaSelected: areaState.isAreaSelected,
                        toggleAnalyticsWidget: areaState.toggleAnalyticsWidget,
                      ),
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
