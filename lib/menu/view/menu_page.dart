import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/dashboard/view/dashboard_page.dart';
import 'package:garden_connect/settings/view/settings_page.dart';
import 'package:garden_connect/menu/cubit/navigation_cubit.dart';
import 'package:garden_connect/menu/cubit/navigation_state.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  static final List<Widget> _pages = [
    const DashboardPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: _pages[state.index],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.index,
            onTap: (index) =>
                context.read<NavigationCubit>().navigateTo(index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}