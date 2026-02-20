import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/auth.dart';
import 'package:garden_ui/ui/components.dart';

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
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthAuthenticated && !state.isAutoLogin) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Connexion réussie !"),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading || state is AuthInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                      "Connexion",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  GardenCard(
                    hasBorder: true,
                    hasShadow: true ,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
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
                                  onPressed: ()=>
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    }),
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),),
                            obscureText: !_passwordVisible,
                            onFieldSubmitted: (value) => context.read<AuthBloc>().add(
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
          );
        },
      ),
    );
  }
}
