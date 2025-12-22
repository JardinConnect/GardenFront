import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/utils/auth_extension.dart';
import 'package:garden_connect/settings/widgets/global_stat_card_widget.dart';
import 'package:garden_connect/settings/widgets/user_profile_widget.dart';

import '../bloc/settings_bloc.dart';
import '../widgets/logs_widget.dart';
import '../widgets/settings_widget.dart';
import '../widgets/users_list_card_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;

    if (user == null) {
      return const Text('Utilisateur non connecté');
    }

    return Scaffold(
      body: BlocProvider(
        create: (context) => SettingsBloc(),
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoading || state is SettingsInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SettingsLoaded) {
              final settings = state.settings;
              final users = state.users;
              final logs = state.logs;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsGeometry.directional(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GlobalStatCardWidget(
                                  title: "Total utilisateurs",
                                  icon: Icons.group_outlined,
                                  data: users.length.toString(),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GlobalStatCardWidget(
                                  title: "Total Cellules",
                                  icon: Icons.sensors,
                                  data: "28",
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GlobalStatCardWidget(
                                  title: "Total Espaces",
                                  icon: Icons.hexagon_outlined,
                                  data: "38",
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GlobalStatCardWidget(
                                  title: "Activités (24h)",
                                  icon: Icons.bar_chart_outlined,
                                  data: "840",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GlobalSettingsWidget(settings: settings,),
                            ),
                          ),

                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: UserProfileWidget(user: user),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: UserListCardWidget(users: users,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: LogCardWidget(logs:logs),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is SettingsError) {
              return Center(child: Text('Erreur: ${state.message}'));
            } else {
              return const Center(child: Text('État inconnu'));
            }
          },
        ),
      ),
    );
  }
}