
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/design_system.dart';
import '../../../auth/utils/auth_extension.dart';
import '../bloc/users_bloc.dart';
import '../widgets/user_add_form_widget.dart';

class UserAddView extends StatelessWidget {
  const UserAddView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;

    if (user == null) {
      return const Text('Utilisateur non connecté');
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.directional(top: GardenSpace.paddingMd, start: GardenSpace.paddingSm),
          child: Column(
            children: [
          Row(
          children: [
          IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyMedium?.color,size: 16,),
          onPressed: () {
            context.read<UsersBloc>().add(UsersLoad(currentUser: user));
          },
        ),
        Text(
          'retour',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        ],
      ),
              Padding(
                padding: EdgeInsetsGeometry.all(60),
                  child: UserAddFormWidget())
            ],
          ),
        ),
      ),
    );
  }
}