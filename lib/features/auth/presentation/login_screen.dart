import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/auth_provider.dart';
import '../../../core/widgets/loader.dart';
import '../../../core/utils/snackbar_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Signup')),
      body: auth.isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final error = await auth.signIn(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                          if (error != null) {
                            showSnackBar(context, error, isError: true);
                          } else {
                            showSnackBar(context, "Login successful!");
                          }
                        },
                        child: const Text('Login'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final error = await auth.signUp(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                          if (error != null) {
                            showSnackBar(context, error, isError: true);
                          } else {
                            showSnackBar(context, "Signup successful!");
                          }
                        },
                        child: const Text('Signup'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
