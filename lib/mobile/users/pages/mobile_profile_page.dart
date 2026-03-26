import 'package:flutter/material.dart';
import 'package:garden_connect/settings/dashboard/widgets/user_profile_widget.dart';

class MobileProfilePage extends StatelessWidget {
  const MobileProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: UserProfileWidget(user: user)
          ),
        ),
      ),
    );
  }
}
