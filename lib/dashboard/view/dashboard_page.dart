import 'package:flutter/material.dart';
import 'package:garden_connect/auth/utils/auth_extension.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;

    if (user == null) {
      return const Text('Utilisateur non connecté');
    }

    return Scaffold(
      body: Center(
        child: Text('Welcome ${user.username} to Garden Connect Dashboard'),
      ),
    );
  }
}
