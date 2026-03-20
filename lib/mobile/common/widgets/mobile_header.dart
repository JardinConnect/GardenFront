import 'package:flutter/material.dart';
import 'package:garden_connect/auth/utils/auth_extension.dart';
import 'package:garden_ui/ui/design_system.dart';

class MobileHeader extends StatelessWidget {
  final List<IconButton>? actionsButtons;

  const MobileHeader({super.key, this.actionsButtons});

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;

    if (user == null) {
      return const Text("Utilisateur non connecté");
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bonjour", style: GardenTypography.bodyLg),
            Text(
              "${user.firstName} ${user.lastName}",
              style: GardenTypography.headingSm.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          spacing: GardenSpace.gapXs,
          children: [
            ...?actionsButtons,
            IconButton(
              onPressed: () => {},
              icon: Icon(
                Icons.notifications_rounded,
                color: GardenColors.typography.shade500,
                size: 32,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
