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
    final User currentUser = context.currentUser!;
    return GardenCard(
      child: Column(
        children: [
          SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Expanded(
            child: DataTable(
              headingRowHeight: 38,
              dataRowMinHeight: 52,
              dataRowMaxHeight: 64,
              columns: [
                const DataColumn(label: Text('Nom / Prénom')),
                const DataColumn(label: Text('Email')),
                const DataColumn(label: Text('Rôle')),
                if(isEditable != null && isEditable == true)
                  const DataColumn(label: Text('Actions')),
              ],
              rows: users.map((user) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text('${user.firstName} ${user.lastName}'),
                    ),
                    DataCell(
                      Text(user.email),
                    ),
                    DataCell(
                      Text(user.role.displayName)
                    ),
                    if(isEditable != null && isEditable == true)
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (currentUser == user ||
                                currentUser.role == Role.admin)
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: Theme.of(context).primaryColor),
                                onPressed: () {
                                  context
                                      .read<UsersBloc>()
                                      .add(UserSelect(user: user));
                                },
                              ),
                            IconButton(
                              icon: Icon(Icons.remove_red_eye_outlined,
                                  color: Theme.of(context).primaryColor),
                              onPressed: () {
                                context
                                    .read<UsersBloc>()
                                    .add(UserSelect(user: user));
                              },
                            ),
                          ],
                        ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
              ),
        ],
      ),
    );
  }
}


