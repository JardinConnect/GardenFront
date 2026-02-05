import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/utils/auth_extension.dart';
import 'package:garden_connect/settings/users/bloc/users_bloc.dart';
import 'package:garden_ui/ui/widgets/atoms/Card/card.dart';

import '../../../auth/models/user.dart';

class UserListCardWidget extends StatelessWidget {
  const UserListCardWidget({super.key, required this.users, this.isEditable });

  final List<User> users;
  final bool? isEditable;

  @override
  Widget build(BuildContext context) {
    return GardenCard(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.group_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                    Text(
                      "Utilisateurs",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsGeometry.directional(
                    top: 20,
                    start: 40,
                    end: 40,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Prenom/Nom",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text("Email"),
                          Text("Role"),
                          if (isEditable == true)
                            Text("Actions"),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsetsGeometry.directional(top: 8.0),
                        child: Column(
                          children:
                            users.map((user)=>
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${user.firstName}/${user.lastName}",
                                      style:
                                      Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Text(
                                      user.email,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Text(
                                      user.role,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    if (isEditable == true)
                                      Row(
                                        children: [
                                          if (context.currentUser == user || context.currentUser?.role=="admin")
                                              IconButton(onPressed:(){
                                                context.read<UsersBloc>().add(UserSelect(user: user));
                                              }, icon: Icon(Icons.edit, color: Theme.of(context).primaryColor,)),

                                          IconButton(onPressed:(){
                                            context.read<UsersBloc>().add(UserSelect(user: user));
                                          }, icon: Icon(Icons.remove_red_eye_outlined, color: Theme.of(context).primaryColor,)),
                                        ]
                                      )
                                  ],
                                ),
                              )).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
