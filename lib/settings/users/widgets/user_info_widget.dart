import 'package:flutter/material.dart';
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            child: Text("<07/10/2023>", style: Theme.of(context).textTheme.bodyLarge),
          ),
        ]
      )
    );
  }
}