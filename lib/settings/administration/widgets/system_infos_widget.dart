import 'package:flutter/material.dart';
import 'package:garden_connect/settings/administration/widgets/administration_card_widget.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

class SystemInfosWidget extends StatelessWidget {
  const SystemInfosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AdministrationCardWidget(
      title: "Informations système",
      subtitle: "État et métriques de votre cellule mère",
      icon: Icons.info_outline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: GardenSpace.gapMd,
        children: [
          Column(
            children: [
              Row(
                spacing: GardenSpace.gapSm,
                children: [
                  Expanded(
                    child: _VersionCardWidget(
                      title: "Version Logiciel",
                      value: "1.0.21",
                      icon: Icons.info_outline,
                      isUpToDate: true,
                    ),
                  ),
                  Expanded(
                    child: _VersionCardWidget(
                      title: "Firmware Cellules",
                      value: "1.0.1",
                      icon: Icons.sensors_outlined,
                      isUpToDate: true,
                    ),
                  ),
                  Expanded(
                    child: _VersionCardWidget(
                      title: "OS",
                      value: "GardenConnectOS",
                      icon: Icons.square_outlined,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VersionCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool? isUpToDate;

  const _VersionCardWidget({
    required this.title,
    required this.value,
    required this.icon,
    this.isUpToDate = false,
  });

  @override
  Widget build(BuildContext context) {
    return GardenCard(
      hasBorder: true,
      hasShadow: false,
      child: Column(
        spacing: GardenSpace.gapMd,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: GardenTypography.bodyMd,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              Text(value, style: GardenTypography.headingSm.copyWith(
                overflow: TextOverflow.ellipsis
              )),
            ],
          ),
        ],
      ),
    );
  }
}
