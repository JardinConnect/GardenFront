import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/menu/menu.dart';
import 'menu/cubit/navigation_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MenuPage(),
      ),
    );
  }
}
