import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const DashboardPage());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: Text('Welcome to Garden Connect', style: TextStyle(fontSize: 24)),
            ),
          ),
        ],
      ),
    );
  }
}
