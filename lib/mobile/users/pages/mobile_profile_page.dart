import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/settings/users/widgets/user_form_widget.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/utils/auth_extension.dart';
import '../../../settings/users/widgets/user_info_widget.dart';
import '../../common/widgets/mobile_header.dart';

class MobileProfilePage extends StatefulWidget {
  const MobileProfilePage({super.key});

  @override
  State<MobileProfilePage> createState() => _MobileProfilePageState();
}

class _MobileProfilePageState extends State<MobileProfilePage>{

  bool inEdition = false;
  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;
    return Scaffold(
      appBar: MobileHeader(),
      body: SafeArea(
        child: Center(
          child:Padding(
            padding: EdgeInsets.all(GardenSpace.paddingMd),
            child: SingleChildScrollView(
              child: Column(
                spacing: 30,
                children: [
                  UserFormWidget(user:user),
                  UserInfoWidget(user: user!),
                  Button(
                    label: "Déconnexion",
                    onPressed:()=> context.read<AuthBloc>().add(AuthLogoutRequested()),
                    minWidth: 100,
                    severity:  ButtonSeverity.danger,
                  ),
                ],
              ),
            ),
          )
          ),
        ),
      );
  }
}
