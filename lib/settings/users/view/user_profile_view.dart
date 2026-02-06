
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/common/widgets/danger_zone.dart';
import 'package:garden_connect/settings/users/bloc/users_bloc.dart';
import 'package:garden_connect/settings/users/widgets/log_card_widget.dart';
import 'package:garden_connect/settings/users/widgets/user_form_widget.dart';
import 'package:garden_connect/settings/users/widgets/user_info_widget.dart';

import '../../../auth/models/user.dart';
import '../../../auth/utils/auth_extension.dart';


class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UsersBloc>().selectedUser;
    final logs = context.read<UsersBloc>().userLogs;
    final currentUser = context.currentUser;
    if (user == null) {
      return const Text('Utilisateur non connecté');
    }
    return
      Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsGeometry.directional(top: 16, start: 8),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyMedium?.color,size: 16,),
                    onPressed: () {
                      context.read<UsersBloc>().add(UsersUnselectEvent());
                    },
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
                              padding: const EdgeInsets.all(16.0),
                              child: UserFormWidget(user: user),
                            ),
                            if (logs != null)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
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
                            padding: const EdgeInsets.all(16.0),
                            child: UserInfoWidget(user: user),
                          ),
                          if (currentUser?.role == Role.admin || context.currentUser == user)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child:DangerZone(title: "Zone de danger", description: "La suppression d'un utilisateur est irréverssible", deleteButtonLabel: "Supprimer",
                                  onDelete: (){
                                context.read<UsersBloc>().add(UserDeleteEvent(user: user));
                                sleep(Duration(seconds: 1));
                                context.read<UsersBloc>().add(UsersUnselectEvent());
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