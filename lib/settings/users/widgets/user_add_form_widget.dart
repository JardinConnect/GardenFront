import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/alerts/widgets/common/snackbar.dart';
import 'package:garden_ui/ui/components.dart';

import '../../../auth/models/user.dart';
import '../bloc/users_bloc.dart';

class UserAddFormWidget extends StatefulWidget {
  const UserAddFormWidget({super.key});

  @override
  State<UserAddFormWidget> createState() => _UserFormWidget();
}
class _UserFormWidget extends State<UserAddFormWidget> {

  late UserAddDto? user ;
  final userForm = GlobalKey<FormState>();
  late TextEditingController passwordController;
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    user = UserAddDto(
        firstName: '',
        lastName: '',
        email: '',
        phoneNumber: '',
        role: Role.trainee,
        password: '',
      );
    passwordController = TextEditingController();
    emailController = TextEditingController(text: user?.email);
    phoneController = TextEditingController(text: user?.phoneNumber);
    firstnameController = TextEditingController(text: user?.firstName);
    lastnameController = TextEditingController(text: user?.lastName);
  }

  @override
  void dispose() {
    passwordController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return GardenCard(
      hasBorder: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                    Text(
                      "Nouvel Utilisateur",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Form(
            key: userForm,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child:
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: firstnameController,
                          decoration: const InputDecoration(labelText: 'Prénom')

                        ),
                      )
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: lastnameController,
                          decoration: const InputDecoration(labelText: 'Nom')
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une adresse email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Veuillez entrer une adresse email valide';
                        }
                        return null;
                      },
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email')
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un numéro de téléphone';
                        }
                        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Veuillez entrer un numéro de téléphone valide (10 chiffres)';
                        }
                        return null;
                      },
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Téléphone', hintText: 'Ex: 0612345678')
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un mot de passe';
                      }
                      if (value.length < 8) {
                        return 'Le mot de passe doit contenir au moins 8 caractères';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Mot de passe'),
                    obscureText: true,
                  ),
                ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                    DropdownButtonFormField<Role>(
                      initialValue: user?.role ?? Role.trainee,
                      decoration: const InputDecoration(labelText: 'Rôle'),
                      items: <Role>[Role.admin, Role.employee,Role.trainee].map((Role value) {
                        return DropdownMenuItem<Role>(
                          value: value,
                          child: Text(value.displayName, style: Theme.of(context).textTheme.bodyLarge),
                        );
                      }).toList(),
                      onChanged: (Role? value) {
                        setState(() {
                          user = UserAddDto(
                            firstName: user?.firstName ?? '',
                            lastName: user?.lastName ?? '',
                            email: user?.email ?? '',
                            phoneNumber: user?.phoneNumber ?? '',
                            role: value ?? Role.trainee,
                            password: user?.password ?? '',
                          );
                        });
                      },
                    ),
                  ),
                  Button(label: "Créer", icon: Icons.check_circle, onPressed: ()=>
                  {
                    if (userForm.currentState?.validate() == true){
                      userForm.currentState?.save(),
                      context.read<UsersBloc>().add(
                          UserAddEvent(user: UserAddDto(
                            firstName: firstnameController.text,
                            lastName: lastnameController.text,
                            email: emailController.text,
                            phoneNumber: phoneController.text,
                            password: passwordController.text,
                            role: user?.role ?? Role.trainee,
                          ))),
                      showSnackBarSucces(context, "Utilisateur créé avec succès"),
                      context.read<UsersBloc>().add(UsersUnselectEvent())
                    }else{
                      showSnackBarError(context, "Veuillez corriger les erreurs dans le formulaire")
                    }
                  } )
              ],
            ),
          ),
        ],
      ),
    );
  }
}