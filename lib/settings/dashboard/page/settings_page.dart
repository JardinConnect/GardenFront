import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/utils/auth_extension.dart';
import 'package:garden_connect/common/widgets/global_stat_card_widget.dart';
import 'package:garden_connect/common/widgets/page_header.dart';
import 'package:garden_connect/settings/dashboard/widgets/user_profile_widget.dart';
import 'package:garden_ui/ui/design_system.dart';

import '../../users/repository/users_repository.dart';
import '../bloc/settings_bloc.dart';
import '../repository/settings_repository.dart';
import '../../users/widgets/log_card_widget.dart';
import '../widgets/settings_widget.dart';
import '../../users/widgets/users_list_card_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;

    if (user == null) {
      return const Text('Utilisateur non connecté');
    }

    return Scaffold(
        body: MultiRepositoryProvider(
          providers: [
            RepositoryProvider(create: (_) => UsersRepository()),
            RepositoryProvider(create: (_) => SettingsRepository()),
          ],
          child: BlocProvider(
            create: (context) => SettingsBloc(
              usersRepository: RepositoryProvider.of<UsersRepository>(context),
              settingsRepository: RepositoryProvider.of<SettingsRepository>(context),
            )..add(SettingsLoad(currentUser: user)),
            child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is SettingsLoading || state is SettingsInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SettingsLoaded) {
                final settings = state.settings;
                final users = state.users;
                final logs = state.logs;
                return Padding(
                  padding: EdgeInsets.all(GardenSpace.paddingMd),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        PageHeader(title: "Bonjour ${user.firstName} ${user.lastName}"),
                        Row(
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
                            ],
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
      ),
    );
  }
}