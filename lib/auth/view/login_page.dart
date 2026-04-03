import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garden_connect/auth/auth.dart';
import 'package:garden_connect/core/app_assets.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

import '../../alerts/widgets/common/snackbar.dart' as snackbar;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              AppAssets.loginBackground,
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.5,
            child: SvgPicture.asset(
              AppAssets.loginCharacters,
              alignment: Alignment.bottomCenter,
              fit: BoxFit.contain,
            ),
          ),
          SafeArea(
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthUnauthenticated && state.error != null) {
                  snackbar.showSnackBarError(context, state.error!);
                } else if (state is AuthAuthenticated && !state.isAutoLogin) {
                  snackbar.showSnackBarSucces(context, 'Connexion réussie !');
                }
              },
              builder: (context, state) {
                if (state is AuthLoading || state is AuthInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: GardenSpace.paddingMd),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(GardenSpace.paddingXl),
                            child: Text(
                              "Connexion",
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ),
                          GardenCard(
                            hasBorder: true,
                            hasShadow: true,
                            child: Padding(
                              padding: EdgeInsets.all(GardenSpace.paddingMd),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      labelText: "Nom d'utilisateur",
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      labelText: "Mot de passe",
                                      suffixIcon: IconButton(
                                        onPressed:
                                            () => setState(() {
                                              _passwordVisible =
                                                  !_passwordVisible;
                                            }),
                                        icon: Icon(
                                          _passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                    obscureText: !_passwordVisible,
                                    onFieldSubmitted:
                                        (value) => context.read<AuthBloc>().add(
                                          AuthLoginRequested(
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                          ),
                                        ),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      context.read<AuthBloc>().add(
                                        AuthLoginRequested(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ),
                                      );
                                    },
                                    child: const Text("Connexion"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
