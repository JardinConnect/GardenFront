import 'package:flutter/material.dart';
import 'package:garden_connect/cells/models/analytic_metric.dart';
import 'package:garden_connect/cells/models/cell.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

class CellsListWidget extends StatelessWidget {
  final List<Cell> cells;

  const CellsListWidget({super.key, required this.cells});

  @override
  Widget build(BuildContext context) {
    var columns = [
      AnalyticMetric.luminosity.label,
      AnalyticMetric.airTemperature.label,
      AnalyticMetric.soilTemperature.label,
      AnalyticMetric.airHumidity.label,
      AnalyticMetric.soilHumidity.label,
      AnalyticMetric.deepSoilHumidity.label,
    ];

    return Padding(
      padding: EdgeInsets.all(GardenSpace.paddingXs),
      child: Column(
        children: [
          GardenCard(
            child: Row(
              children: [
                Expanded(flex: 1, child: Text("Nom")),
                ...columns.map((column) {
                  return Expanded(flex: 1, child: Center(child: Text(column)));
                }),
              ],
            ),
          ),

          SizedBox(height: GardenSpace.gapLg),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cells.length,

            separatorBuilder:
                (context, index) => SizedBox(height: GardenSpace.gapSm),

            itemBuilder: (context, index) {
              var cell = cells[index];
              var values = [
                "${cell.analytics.light.value} ${AnalyticMetric.luminosity.unit}",
                cell.analytics.airTemperature.value.toStringAsFixed(1) + AnalyticMetric.airTemperature.unit,
                cell.analytics.soilTemperature.value.toStringAsFixed(1) + AnalyticMetric.soilTemperature.unit,
                cell.analytics.airHumidity.value.toString() + AnalyticMetric.airHumidity.unit,
                cell.analytics.soilHumidity.value.toString() + AnalyticMetric.soilHumidity.unit,
                cell.analytics.deepSoilHumidity.value.toString() + AnalyticMetric.deepSoilHumidity.unit,
              ];

              return GardenCard(
                hasBorder: true,
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text(cell.name, style: GardenTypography.bodyLg)),
                    ...values.map((value) {
                      return Expanded(flex: 1, child: Center(child: Text(value, style: GardenTypography.bodyLg,)));
                    })
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
