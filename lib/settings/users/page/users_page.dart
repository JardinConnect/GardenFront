



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/settings/users/widgets/log_card_widget.dart';
import 'package:garden_connect/settings/users/bloc/users_bloc.dart';
import 'package:garden_connect/settings/users/view/user_add_view.dart';
import 'package:garden_connect/settings/users/view/user_profile_view.dart';
import '../../../auth/models/user.dart';
import '../../../auth/utils/auth_extension.dart';
import '../../../common/widgets/global_stat_card_widget.dart';
import '../../../common/widgets/page_header.dart';
import '../widgets/users_list_card_widget.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;

    if (user == null) {
      return const Text('Utilisateur non connecté');
    }


    return Scaffold(
      body: BlocProvider(
        create: (context) => UsersBloc()..add(UsersLoad()),
        child: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            if (state is UsersLoading || state is UsersInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UsersLoaded) {
              final users = state.users;
              final logs = state.logs;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      PageHeader(
                            title: "Bonjour ${user.firstName} ${user.lastName}",
                            actions: [
                              if (user.role == Role.admin)
                                IconButton.filled(
                                  onPressed: ()=> context.read<UsersBloc>().add(UsersCreationEvent()),
                                  icon: Icon(Icons.add),
                                ),
                            ],
                          ),
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
                                  title: "Admins",
                                  data: users.where((u) => u.role == Role.admin).length.toString(),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GlobalStatCardWidget(
                                  title: "Salariés",
                                  data: users.where((u) => u.role == Role.employees).length.toString(),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GlobalStatCardWidget(
                                  title: "Saisonnier",
                                  data: users.where((u) => u.role == Role.trainee).length.toString(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Expanded(child: UserListCardWidget(users: users, isEditable: true,)),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: LogCardWidget(logs: logs),
                            ),
                          )
                        ]
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is UserSelected){
              return UserProfileView();
            } else if (state is UserCreation){
              return UserAddView();
            } else if (state is UsersError) {
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