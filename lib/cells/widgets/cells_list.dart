import 'package:flutter/material.dart';
import 'package:garden_connect/cells/models/analytic_metric.dart';
import 'package:garden_connect/cells/models/cell.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

class CellsList extends StatelessWidget {
  final List<Cell> cells;

  const CellsList({super.key, required this.cells});

  @override
  Widget build(BuildContext context) {
    var columns = [
      AnalyticMetric.LUMINOSITY.label,
      AnalyticMetric.AIR_TEMPERATURE.label,
      AnalyticMetric.SOIL_TEMPERATURE.label,
      AnalyticMetric.AIR_HUMIDITY.label,
      AnalyticMetric.SOIL_HUMIDITY.label,
      AnalyticMetric.DEEP_SOIL_HUMIDITY.label,
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
                "${cell.analytics.light.value} ${AnalyticMetric.LUMINOSITY.unit}",
                cell.analytics.airTemperature.value.toStringAsFixed(1) + AnalyticMetric.AIR_TEMPERATURE.unit,
                cell.analytics.soilTemperature.value.toStringAsFixed(1) + AnalyticMetric.SOIL_TEMPERATURE.unit,
                cell.analytics.airHumidity.value.toString() + AnalyticMetric.AIR_HUMIDITY.unit,
                cell.analytics.soilHumidity.value.toString() + AnalyticMetric.SOIL_HUMIDITY.unit,
                cell.analytics.deepSoilHumidity.value.toString() + AnalyticMetric.DEEP_SOIL_HUMIDITY.unit,
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
