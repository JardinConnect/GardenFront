import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:garden_ui/ui/widgets/atoms/Card/card.dart';

import '../../../auth/models/user.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return GardenCard(
      hasBorder: true,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: GardenSpace.paddingMd),
                child: Text(
                  "Informations du compte",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 4,left: 4.0),
            child: Text("Role", style: Theme.of(context).textTheme.bodySmall),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(user.role.displayName, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text("Membre depuis", style: Theme.of(context).textTheme.bodySmall),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text("${user.createdAt?.day}/${user.createdAt?.month}/${user.createdAt?.year}", style: Theme.of(context).textTheme.bodyLarge),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text("Edité le", style: Theme.of(context).textTheme.bodySmall),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text("${user.updatedAt?.day}/${user.updatedAt?.month}/${user.updatedAt?.year} à ${user.updatedAt?.hour}:${user.updatedAt?.minute}", style: Theme.of(context).textTheme.bodyLarge),
          ),
        ]
      )
    );
  }
}