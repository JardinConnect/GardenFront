import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:garden_connect/analytics/widgets/analytics_cards_grid.dart';
import 'package:garden_connect/cells/bloc/cell_bloc.dart';
import 'package:garden_connect/common/utils.dart';
import 'package:garden_connect/mobile/common/widgets/mobile_header.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

class MobileCellDetailPage extends StatelessWidget {
  final String id;

  const MobileCellDetailPage({super.key, required this.id});

  void _handleChangeCellTracking(
    BuildContext context,
    String name,
    bool newTrackingValue,
    String? parentId,
  ) {
    context.read<CellBloc>().add(
      CellTrackingChanged(
        id: id,
        name: name,
        newTrackingValue: newTrackingValue,
        parentId: parentId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CellBloc, CellState>(
      builder: (context, cellState) {
        if (cellState is CellInitial || cellState is CellDetailShimmer) {
          return Scaffold(
            body: SafeArea(
              child: const Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (cellState is CellError) {
          return Scaffold(
            body: SafeArea(
              child: Center(child: Text('Erreur: ${cellState.message}')),
            ),
          );
        } else if (cellState is CellDetailLoaded) {
          return Scaffold(
            appBar: MobileHeader(),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: GardenSpace.paddingLg,
                    vertical: GardenSpace.paddingMd,
                  ),
                  child: Column(
                    spacing: GardenSpace.gapMd,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            cellState.cell.name,
                            style: GardenTypography.headingSm.copyWith(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GardenToggle(
                            isEnabled: cellState.cell.isTracked,
                            onToggle:
                                (bool value) => _handleChangeCellTracking(
                                  context,
                                  cellState.cell.name,
                                  value,
                                  cellState.cell.parentId,
                                ),
                            enabledIcon: Icons.visibility_outlined,
                            disabledIcon: Icons.visibility_off_outlined,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            cellState.cell.location ?? "Pas de localisation",
                            style: GardenTypography.caption.copyWith(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (cellState.cell.analytics.getLastAnalyticByType(
                                AnalyticType.light,
                              ) !=
                              null)
                            Text(
                              Utils.getLastUpdateText(
                                cellState.cell.analytics
                                    .getLastAnalyticByType(
                                      AnalyticType.light,
                                    )!
                                    .occurredAt,
                              ),
                              style: GardenTypography.caption.copyWith(
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          BatteryIndicator(
                            batteryPercentage:
                                cellState.cell.analytics
                                    .getLastAnalyticByType(AnalyticType.battery)
                                    ?.value
                                    .toInt() ??
                                0,
                            size: BatteryIndicatorSize.sm,
                          ),
                        ],
                      ),
                      AnalyticsCardsGridWidget(
                        analytics: cellState.cell.analytics,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(child: Text('Erreur'));
        }
      },
    );
  }
}
