import 'package:flutter/material.dart';
import 'package:garden_connect/settings/administration/models/system_metrics.dart';
import 'package:garden_connect/settings/administration/widgets/administration_card_widget.dart';
import 'package:garden_ui/ui/design_system.dart';

class RaspberryInfosWidget extends StatelessWidget {
  final SystemMetrics systemMetrics;

  const RaspberryInfosWidget({
    super.key,
    required this.systemMetrics
  });

  @override
  Widget build(BuildContext context) {
    return AdministrationCardWidget(
      title: "Informations du Raspberry",
      icon: Icons.info_outline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: GardenSpace.gapMd,
        children: [
          _RaspberryInfoItem(title: "Température CPU", value: "${systemMetrics.cpuTemp}°C"),
          _RaspberryInfoItem(title: "Charge CPU", value: "${systemMetrics.cpuUsage}%"),
          _RaspberryInfoItem(title: "Charge RAM", value: "${systemMetrics.ramUsage}% (${systemMetrics.ramTotal}GB)"),
          _RaspberryInfoItem(title: "Occuptation Disque", value: "${systemMetrics.diskUsage}% (${systemMetrics.diskTotal}GB)"),
        ],
      ),
    );
  }
}

class _RaspberryInfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _RaspberryInfoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: GardenSpace.gapSm,
      children: [
        Text(title, style: GardenTypography.caption),
        Text(value, style: GardenTypography.bodyLg),
      ],
    );
  }
}
