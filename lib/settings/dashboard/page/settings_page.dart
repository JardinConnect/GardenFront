import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/utils/auth_extension.dart';
import 'package:garden_connect/common/widgets/global_stat_card_widget.dart';
import 'package:garden_connect/settings/dashboard/widgets/user_profile_widget.dart';

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
            )..add(SettingsLoad()),
            child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is SettingsLoading || state is SettingsInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SettingsLoaded) {
                final settings = state.settings;
                final users = state.users;
                final logs = state.logs;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(padding:EdgeInsetsGeometry.directional(top: 16, start: 8),child:  Text("Bonjour ${user.firstName} ${user.lastName}", style: Theme.of(context).textTheme.headlineLarge,),),
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
      ),
    );
  }
}