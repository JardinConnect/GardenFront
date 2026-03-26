import 'package:flutter/material.dart';
import 'package:garden_connect/auth/utils/auth_extension.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:go_router/go_router.dart';

class MobileHeader extends StatelessWidget implements PreferredSizeWidget {
  final List<IconButton>? actionsButtons;

  const MobileHeader({super.key, this.actionsButtons});

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;

    if (user == null) {
      return AppBar(title: const Text("Utilisateur non connecté"));
    }

    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: GardenTypography.bodyLg.color,
      elevation: 0,
      centerTitle: false,
      toolbarHeight: 80,
      titleSpacing: context.canPop() ? 0 : GardenSpace.gapLg,
      title: Column(
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
      actions: [
        ...?actionsButtons,
        IconButton(
          onPressed: () => {},
          icon: Icon(
            Icons.notifications_rounded,
            color: GardenColors.typography.shade500,
            size: 32,
          ),
        ),
        SizedBox(width: GardenSpace.gapLg),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
