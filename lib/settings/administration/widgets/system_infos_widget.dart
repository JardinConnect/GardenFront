import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/common/widgets/page_shimmers.dart';
import 'package:garden_connect/settings/administration/bloc/admin_bloc.dart';
import 'package:garden_connect/settings/administration/widgets/administration_card_widget.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:url_launcher/url_launcher.dart';

class SystemInfosWidget extends StatelessWidget {
  const SystemInfosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if (state is AdminInitial || state is AdminShimmer) {
          return const CellsPageShimmer();
        } else if (state is AdminError) {
          return Center(child: Text('Erreur: ${state.message}'));
        } else if (state is AdminLoaded) {
          return AdministrationCardWidget(
            title: "Informations système",
            subtitle: "État et métriques de votre cellule mère",
            icon: Icons.storage_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: GardenSpace.gapMd,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: GardenSpace.gapMd,
                  children: [
                    Row(
                      spacing: GardenSpace.gapSm,
                      children: [
                        Expanded(
                          child: _VersionCardWidget(
                            title: "Version Logiciel",
                            value: "1.0.21",
                            icon: Icons.storage_outlined,
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
                            icon: Icons.view_in_ar_outlined,
                            isUpToDate: false,
                          ),
                        ),
                      ],
                    ),
                    Text("État des services", style: GardenTypography.bodyLg),
                    Column(
                      spacing: GardenSpace.gapSm,
                      children: [
                        _buildServiceCard("Broker MQTT", () => {}),
                        _buildServiceCard("WIFI", () => {}),
                        _buildServiceCard("VPN", () async {
                          if (state.vpnAuthURL != null) {
                            final Uri url = Uri.parse(state.vpnAuthURL!);
                            await launchUrl(url, webOnlyWindowName: '_blank');
                          } else {
                            GardenDialog.show(
                              context,
                              title: "Connexion au VPN",
                              content: Padding(
                                padding: EdgeInsetsGeometry.symmetric(
                                  horizontal: GardenSpace.paddingMd,
                                  vertical: GardenSpace.paddingLg,
                                ),
                                child: Center(
                                  child: Text(
                                    "Vous êtes déjà connecté au VPN.",
                                    style: GardenTypography.headingSm,
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                        _buildServiceCard("Module LoRa", () => {}),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('Erreur'));
        }
      },
    );
  }

  Widget _buildServiceCard(String title, Function()? onTap) {
    return GardenCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: GardenSpace.gapSm,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: GardenColors.tertiary.shade500,
                  ),
                ),
                Text("En ligne"),
              ],
            ),
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
  final bool isUpToDate;

  const _VersionCardWidget({
    required this.title,
    required this.value,
    required this.icon,
    required this.isUpToDate,
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
            spacing: GardenSpace.gapSm,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: GardenTypography.bodyMd),
              if (isUpToDate)
                Container(
                  decoration: BoxDecoration(
                    color: GardenColors.primary.shade500,
                    borderRadius: GardenRadius.radiusSm,
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: GardenSpace.paddingSm,
                      vertical: 2.0,
                    ),
                    child: Row(
                      spacing: GardenSpace.gapXs,
                      children: [
                        Icon(
                          Icons.check,
                          color: GardenColors.base.shade50,
                          size: 20,
                        ),
                        Text(
                          "À jour",
                          style: GardenTypography.caption.copyWith(
                            color: GardenColors.base.shade50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Row(
            spacing: GardenSpace.gapSm,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: GardenColors.primary.shade500, size: 32),
              Text(
                value,
                style: GardenTypography.bodyLg.copyWith(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
