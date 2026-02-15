import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/analytics/widgets/analytics_cards_grid.dart';
import 'package:garden_connect/analytics/widgets/graphic_widget.dart';
import 'package:garden_connect/cells/bloc/cell_bloc.dart';
import 'package:garden_connect/common/widgets/back_text_button.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:go_router/go_router.dart';

class CellDetailPage extends StatelessWidget {
  final String id;
  final bool isFromAreaPage;

  const CellDetailPage({
    super.key,
    required this.id,
    this.isFromAreaPage = false,
  });

  void _handleChangeCellTracking(BuildContext context, bool newTrackingValue) {
    context.read<CellBloc>().add(
      CellTrackingChanged(id: id, newTrackingValue: newTrackingValue),
    );
  }

  void _handleRefreshCellDetail(BuildContext context) {
    context.read<CellBloc>().add(RefreshCellDetail(id: id));
  }

  String getLastUpdate(DateTime lastUpdateAt) {
    final result = StringBuffer();
    result.write("Mis à jour il y a");

    Duration difference = DateTime.now().difference(lastUpdateAt);

    if (difference.inSeconds < 60) {
      result.write(
        " ${difference.inSeconds} ${difference.inSeconds == 1 ? 'seconde' : 'secondes'}",
      );
    } else if (difference.inMinutes < 60) {
      result.write(
        " ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}",
      );
    } else if (difference.inHours < 24) {
      result.write(
        " ${difference.inHours} ${difference.inHours == 1 ? 'heure' : 'heures'}",
      );
    } else {
      result.write(
        " ${difference.inDays} ${difference.inDays == 1 ? 'jour' : 'jours'}",
      );
    }

    return result.toString();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = BlocBuilder<CellBloc, CellState>(
      builder: (context, cellState) {
        if (cellState is CellInitial || cellState is CellDetailShimmer) {
          return const Center(child: CircularProgressIndicator());
        } else if (cellState is CellError) {
          return Center(child: Text('Erreur: ${cellState.message}'));
        } else if (cellState is CellDetailLoaded) {
          return SingleChildScrollView(
            child: Padding(
              padding: !isFromAreaPage
                  ? EdgeInsets.symmetric(
                horizontal: GardenSpace.paddingLg,
                vertical: GardenSpace.paddingLg,
              )
                  : EdgeInsets.zero,
              child: Column(
                spacing: GardenSpace.gapLg,
                children: [
                  Column(
                    spacing: GardenSpace.gapSm,
                    children: [
                      if (!isFromAreaPage)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BackTextButton(backFunction: () => context.pop()),
                            IconButton.filled(
                              icon: Icon(Icons.refresh),
                              onPressed: () => _handleRefreshCellDetail(context),
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
                                // isEnabled: cellState.cell.isTracked,
                                isEnabled: false,
                                onToggle: (bool value) =>
                                    _handleChangeCellTracking(context, value),
                                enabledIcon: Icons.visibility_outlined,
                                disabledIcon: Icons.visibility_off_outlined,
                              ),
                            ],
                          ),
                          Text(
                            getLastUpdate(cellState.cell.updatedAt),
                            style: GardenTypography.caption,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            cellState.cell.location ?? "Pas de localisation",
                            style: GardenTypography.caption,
                          ),
                          BatteryIndicator(
                            batteryPercentage: cellState.cell.battery ?? 0,
                            size: BatteryIndicatorSize.sm,
                          ),
                        ],
                      ),
                    ],
                  ),
                  AnalyticsCardsGridWidget(analytics: cellState.cell.analytics),
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
          return const Center(child: Text('Erreur fojefijezfzenf'));
        }
      },
    );
    return isFromAreaPage ? body : Scaffold(body: body);
  }
}
