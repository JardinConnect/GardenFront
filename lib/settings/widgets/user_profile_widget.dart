
import 'package:flutter/material.dart';
import 'package:garden_ui/ui/widgets/atoms/Card/card.dart';

import '../../auth/models/user.dart';

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({
    super.key,
    required this.user,
  });

  final User? user;
  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Text('Utilisateur non connecté');
    }
    return GardenCard(
      hasShadow: true,
      hasBorder: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color:
                  Theme.of(
                    context,
                  ).colorScheme.primary,
                  size: 32,
                ),
                Text(
                  "Mon Profil",
                  style:
                  Theme.of(
                    context,
                  ).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                "Prenom : ",
                style:
                Theme.of(
                  context,
                ).textTheme.bodyMedium,
              ),
              Text(
                user!.firstName,
                style:
                Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "Nom : ",
                style:
                Theme.of(
                  context,
                ).textTheme.bodyMedium,
              ),
              Text(
                user!.lastName,
                style:
                Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "Email : ",
                style:
                Theme.of(
                  context,
                ).textTheme.bodyMedium,
              ),
              Text(
                user!.email,
                style:
                Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "Telephone : ",
                style:
                Theme.of(
                  context,
                ).textTheme.bodyMedium,
              ),
              Text(
                user!.phoneNumber,
                style:
                Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}