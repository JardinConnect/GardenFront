import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/alerts/widgets/common/snackbar.dart';
import 'package:garden_ui/ui/components.dart';

import '../../../auth/models/user.dart';
import '../../../auth/utils/auth_extension.dart';
import '../bloc/users_bloc.dart';

class UserFormWidget extends StatefulWidget {
  const UserFormWidget({super.key, this.user});

  final User? user;
  @override
  State<UserFormWidget> createState() => _UserFormWidget();
}
class _UserFormWidget extends State<UserFormWidget> {

  late User? user =  widget.user;
  bool inEditionMode = false;
  bool inUserCreation = false;
  bool changePassword = false;
  final userForm = GlobalKey<FormState>();
  final passwordForm = GlobalKey<FormState>();
  late TextEditingController passwordController;
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    if(user == null) {
      user = User(
        id: '',
        firstName: '',
        lastName: '',
        email: '',
        phoneNumber: '',
        role: Role.employee,
      );
      inUserCreation = true;
    }
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

    final currentUser = context.currentUser;

    final isEditable = currentUser != null && ( currentUser.id == user?.id); //currentUser.role == 'admin' ||

    final doesUserOwnProfile = currentUser != null && (currentUser.id == user?.id);

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
                      doesUserOwnProfile ? "Mon Profil" : "Profil Utilisateur",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                if(!inUserCreation && (currentUser == user || currentUser?.role == Role.admin))
                  IconButton(
                    icon: Icon(
                      inEditionMode ? Icons.close : Icons.edit,
                      color: inEditionMode ? Colors.grey : Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        inEditionMode = !inEditionMode;
                      });
                    },
                  )
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
                          readOnly: !inEditionMode && !inUserCreation,
                          decoration: inEditionMode || inUserCreation
                              ? const InputDecoration(labelText: 'Prénom')
                              : const InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              labelText: 'Prénom'
                          ),
                        ),
                      )
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: lastnameController,
                          readOnly: !inEditionMode && !inUserCreation,
                          decoration: inEditionMode || inUserCreation
                              ? const InputDecoration(labelText: 'Nom')
                              : const InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              labelText: 'Nom'
                          ),
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
                    readOnly: !inEditionMode && !inUserCreation,
                    decoration: inEditionMode || inUserCreation
                        ? const InputDecoration(labelText: 'Email')
                        : const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        labelText: 'Email'
                    ),
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
                    readOnly: !inEditionMode && !inUserCreation,
                    decoration: inEditionMode || inUserCreation
                        ? const InputDecoration(labelText: 'Téléphone', hintText: 'Ex: 0612345678')
                        : const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        labelText: 'Téléphone'
                    ),
                  ),
                ),
                if(inEditionMode || inUserCreation)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                    DropdownButtonFormField<Role>(
                      initialValue: user?.role ?? Role.trainee,
                      decoration: inEditionMode || inUserCreation
                          ? const InputDecoration(labelText: 'Rôle')
                          : const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          labelText: 'Rôle'
                      ),
                      items: <Role>[Role.admin, Role.employee,Role.trainee].map((Role value) {
                        return DropdownMenuItem<Role>(
                          value: value,
                          child: Text(value.displayName, style: Theme.of(context).textTheme.bodyLarge),
                        );
                      }).toList(),
                      onChanged: (Role? value) {
                        setState(() {
                          user = User(
                              id: user?.id ?? '',
                              firstName: user?.firstName ?? '',
                              lastName: user?.lastName ?? '',
                              email: user?.email ?? '',
                              phoneNumber: user?.phoneNumber ?? '',
                              role: value ?? Role.trainee
                          );
                        });
                      },
                    ),
                  ),
                if(!inEditionMode && !inUserCreation)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: user?.role.displayName,
                      readOnly: true,
                      decoration:const InputDecoration(labelText: 'Téléphone', hintText: 'Ex: 0612345678',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,)
                    ),
                  ),
                if(inEditionMode || inUserCreation)
                  Button(label: "Valider", icon: Icons.check_circle, onPressed: ()=>
                  {
                    if (userForm.currentState?.validate() == true){
                    userForm.currentState?.save(),
                    context.read<UsersBloc>().add(UserUpdateEvent(user: User(
                      id: user!.id,
                      firstName: firstnameController.text,
                      lastName: lastnameController.text,
                      email: emailController.text,
                      phoneNumber: phoneController.text,
                      role: user?.role ?? Role.employee,
                    ))),
                    setState(() {
                      inEditionMode = !inEditionMode;
                    }),
                      showSnackBarSucces(context, doesUserOwnProfile ? "Profil mis à jour avec succès" : "Utilisateur mis à jour avec succès")
                    }else{
                      showSnackBarError(context, "Veuillez corriger les erreurs dans le formulaire")
                    }
                  } )
              ],
            ),
          ),
          if(doesUserOwnProfile && inEditionMode)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Checkbox(
                    value: changePassword,
                    onChanged: (bool? value) {
                      setState(() {
                        changePassword = value ?? false;
                      });
                    },
                  ),
                  const Text('Changer le mot de passe'),
                ],
              ),
            ),
          if(doesUserOwnProfile && changePassword && inEditionMode)
            Form(
              key: passwordForm,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: 'ceciestunexemple',
                      decoration: const InputDecoration(labelText: 'Ancien mot de passe'),
                      obscureText: true,
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
                      decoration: const InputDecoration(labelText: 'Nouveau mot de passe'),
                      obscureText: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: 'ceciestunexemple',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez confirmer le mot de passe';
                        }
                        if (value != passwordController.text) {
                          return 'Les mots de passe ne correspondent pas';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Confirmer le mot de passe'),
                      enabled: isEditable && inEditionMode,
                      obscureText: true,
                    ),
                  ),
                  Button(label: "Confirmer", onPressed: ()=>{} )
                ],
              ),
            )

        ],
      ),
    );
  }
}