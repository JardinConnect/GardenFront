import 'package:flutter/material.dart';
import 'package:garden_ui/ui/widgets/atoms/Card/card.dart';

import '../../../auth/models/user.dart';

class UserListCardWidget extends StatelessWidget {
  const UserListCardWidget({super.key, required this.users});

  final List<User> users;

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
                    start: 60,
                    end: 60,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Nom",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text("Email"),
                          Text("Status"),
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
                                      user.lastName,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Text(
                                      user.email,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Text(
                                      user.phoneNumber,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
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
