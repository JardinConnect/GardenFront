

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/common/widgets/danger_zone.dart';
import 'package:garden_connect/settings/users/bloc/users_bloc.dart';
import 'package:garden_connect/settings/users/widgets/log_card_widget.dart';
import 'package:garden_connect/settings/users/widgets/user_form_widget.dart';
import 'package:garden_connect/settings/users/widgets/user_info_widget.dart';
import 'package:garden_ui/ui/design_system.dart';

import '../../../auth/models/user.dart';
import '../../../auth/utils/auth_extension.dart';


class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UsersBloc>().selectedUser;
    final logs = context.read<UsersBloc>().userLogs;
    final currentUser = context.currentUser;
    if (currentUser == null) {
      return const Text('Utilisateur non connecté');
    }
    if (user == null) {
      return const Text('Utilisateur introuvable');
    }
    return
      Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.directional(top: GardenSpace.paddingMd, start: GardenSpace.paddingSm),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyMedium?.color,size: 16,),
                    onPressed: () =>context.read<UsersBloc>().add(UsersLoad(currentUser: currentUser)),
                  ),
                  Text(
                    'retour',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                    Expanded(
                        flex:6,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(GardenSpace.paddingMd),
                              child: UserFormWidget(user: user),
                            ),
                            Padding(
                              padding: EdgeInsets.all(GardenSpace.paddingMd),
                              child: LogCardWidget(logs: logs,),
                            ),
                          ],
                        )
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(GardenSpace.paddingMd),
                            child: UserInfoWidget(user: user),
                          ),
                          if (currentUser.role == Role.admin || context.currentUser == user)
                            Padding(
                              padding: EdgeInsets.all(GardenSpace.paddingMd),
                              child:DangerZone(title: "Zone de danger", description: "La suppression d'un utilisateur est irréverssible", deleteButtonLabel: "Supprimer",
                                  onDelete: (){
                                context.read<UsersBloc>().add(UserDeleteEvent(user: user));
                                context.read<UsersBloc>().add(UsersLoad(currentUser: currentUser));
                              }),
                            ),
                        ],
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}