import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:garden_connect/analytics/widgets/analytic_card.dart';
import 'package:garden_connect/analytics/widgets/graphic_widget.dart';
import 'package:garden_connect/cells/bloc/cell_bloc.dart';
import 'package:garden_connect/cells/models/cell_location.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

class CellDetailPage extends StatelessWidget {
  final int id;

  const CellDetailPage({super.key, required this.id});

  void _handleChangeCellTracking(BuildContext context, bool newTrackingValue) {
    context.read<CellBloc>().add(
      CellTrackingChanged(id: id, newTrackingValue: newTrackingValue),
    );
  }

  String getBreadcrumbLocation(CellLocation location) {
    List<String> breadcrumb = [];

    CellLocation? parent = location;
    while (parent != null) {
      breadcrumb.add(parent.name);
      parent = parent.location;
    }

    return breadcrumb.reversed.toList().join(" > ");
  }

  String getLastUpdate(DateTime lastUpdateAt) {
    final result = StringBuffer();
    result.write("Mis à jour il y a");

    Duration difference = DateTime.now().difference(lastUpdateAt);

    if (difference.inSeconds < 60) {
      result.write(" ${difference.inSeconds}s");
    } else if (difference.inMinutes < 60) {
      result.write(" ${difference.inMinutes}min");
    } else if (difference.inHours < 24) {
      result.write(" ${difference.inHours}h");
    } else {
      result.write(" ${difference.inDays}j");
    }

    return result.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CellBloc()..add(LoadCellDetail(id: id)),
          ),
        ],
        child: Builder(
          builder: (context) {
            final cellState = context.watch<CellBloc>().state;

            if (cellState is CellInitial || cellState is CellDetailShimmer) {
              return const Center(child: CircularProgressIndicator());
            } else if (cellState is CellError) {
              return Center(child: Text('Erreur: ${cellState.message}'));
            } else if (cellState is CellDetailLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: GardenSpace.paddingLg,
                    vertical: GardenSpace.paddingLg,
                  ),
                  child: Column(
                    spacing: GardenSpace.gapLg,
                    children: [
                      Column(
                        spacing: GardenSpace.gapSm,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("<- Retour", style: GardenTypography.bodyLg),
                              Row(
                                spacing: GardenSpace.gapSm,
                                children: [
                                  IconButton.filled(
                                    icon: Icon(Icons.edit_outlined),
                                    onPressed: () => {},
                                  ),
                                  IconButton.filled(
                                    icon: Icon(Icons.refresh),
                                    onPressed: () => {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                spacing: GardenSpace.gapSm,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    cellState.cell.name,
                                    style: GardenTypography.headingLg,
                                  ),
                                  GardenToggle(
                                    isEnabled: cellState.cell.isTracked,
                                    onToggle:
                                        (bool value) =>
                                            _handleChangeCellTracking(
                                              context,
                                              value,
                                            ),
                                    enabledIcon: Icons.visibility_outlined,
                                    disabledIcon: Icons.visibility_off_outlined,
                                  ),
                                ],
                              ),
                              Text(
                                getLastUpdate(cellState.cell.lastUpdateAt),
                                style: GardenTypography.caption,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                getBreadcrumbLocation(cellState.cell.location),
                                style: GardenTypography.caption,
                              ),
                              BatteryIndicator(
                                batteryPercentage: 63,
                                size: BatteryIndicatorSize.sm,
                              ),
                            ],
                          ),
                        ],
                      ),

                      GridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: GardenSpace.gapMd,
                        crossAxisSpacing: GardenSpace.gapXl,
                        childAspectRatio: 2.5,
                        shrinkWrap: true,
                        children: <Widget>[
                          AnalyticCard(
                            type: AnalyticType.airHumidity,
                            alertStatus:
                                cellState.cell.analytics
                                    .getLastAnalyticByType(
                                      AnalyticType.airHumidity,
                                    )!
                                    .alertStatus,
                            value:
                                cellState.cell.analytics
                                    .getLastAnalyticByType(
                                      AnalyticType.airHumidity,
                                    )!
                                    .value,
                          ),
                          AnalyticCard(
                            type: AnalyticType.light,
                            alertStatus:
                                cellState.cell.analytics
                                    .getLastAnalyticByType(AnalyticType.light)!
                                    .alertStatus,
                            value:
                                cellState.cell.analytics
                                    .getLastAnalyticByType(AnalyticType.light)!
                                    .value,
                          ),
                          AnalyticCard(
                            type: AnalyticType.airTemperature,
                            alertStatus:
                                cellState.cell.analytics
                                    .getLastAnalyticByType(
                                      AnalyticType.airTemperature,
                                    )!
                                    .alertStatus,
                            value:
                                cellState.cell.analytics
                                    .getLastAnalyticByType(
                                      AnalyticType.airTemperature,
                                    )!
                                    .value,
                          ),
                          AnalyticCard(
                            type: AnalyticType.soilTemperature,
                            alertStatus:
                                cellState.cell.analytics
                                    .getLastAnalyticByType(
                                      AnalyticType.soilTemperature,
                                    )!
                                    .alertStatus,
                            value:
                                cellState.cell.analytics
                                    .getLastAnalyticByType(
                                      AnalyticType.soilTemperature,
                                    )!
                                    .value,
                          ),
                          AnalyticCard(
                            type: AnalyticType.soilHumidity,
                            alertStatus:
                                cellState.cell.analytics
                                    .getLastAnalyticByType(
                                      AnalyticType.soilHumidity,
                                    )!
                                    .alertStatus,
                            value:
                                cellState.cell.analytics
                                    .getLastAnalyticByType(
                                      AnalyticType.soilHumidity,
                                    )!
                                    .value,
                          ),
                          AnalyticCard(
                            type: AnalyticType.deepSoilHumidity,
                            alertStatus:
                                cellState.cell.analytics
                                    .getLastAnalyticByType(
                                      AnalyticType.deepSoilHumidity,
                                    )!
                                    .alertStatus,
                            value:
                                cellState.cell.analytics
                                    .getLastAnalyticByType(
                                      AnalyticType.deepSoilHumidity,
                                    )!
                                    .value,
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: GardenSpace.gapSm,
                        children: [
                          Text(
                            "Évolution des données",
                            style: GardenTypography.headingLg,
                          ),
                          GraphicWidget(analytics: cellState.cell.analytics),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('Erreur'));
            }
          },
        ),
      ),
    );
  }
}
