import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/utils/auth_extension.dart';
import 'package:garden_connect/common/widgets/page_header.dart';
import 'package:garden_connect/common/widgets/page_shimmers.dart';
import 'package:garden_connect/settings/administration/bloc/admin_bloc.dart';
import 'package:garden_connect/settings/administration/widgets/admin_danger_zone_widget.dart';
import 'package:garden_connect/settings/administration/widgets/cgu_widget.dart';
import 'package:garden_connect/settings/administration/widgets/raspberry_infos_widget.dart';
import 'package:garden_connect/settings/administration/widgets/saves_widget.dart';
import 'package:garden_connect/settings/administration/widgets/system_infos_widget.dart';
import 'package:garden_connect/settings/administration/widgets/system_tools_widget.dart';
import 'package:garden_ui/ui/design_system.dart';

class AdministrationPage extends StatelessWidget {
  const AdministrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;
    if (user == null) {
      return const Text("Utilisateur non connecté");
    }

    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if (state is AdminInitial || state is AdminShimmer) {
          return const CellsPageShimmer();
        } else if (state is AdminError) {
          return Center(child: Text('Erreur: ${state.message}'));
        } else if (state is AdminLoaded) {
          return Padding(
            padding: EdgeInsets.all(GardenSpace.paddingMd),
            child: SingleChildScrollView(
              child: Column(
                spacing: GardenSpace.gapMd,
                children: [
                  PageHeader(title: "Bonjour ${user.firstName}"),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: GardenSpace.gapMd,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          spacing: GardenSpace.gapSm,
                          children: [
                            SystemInfosWidget(),
                            SavesWidget(),
                            AdminDangerZoneWidget(),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          spacing: GardenSpace.gapSm,
                          children: [
                            RaspberryInfosWidget(systemMetrics: state.systemMetrics),
                            SystemToolsWidget(),
                            CGUWidget(),
                          ],
                        ),
                      ),
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
    );
  }
}
