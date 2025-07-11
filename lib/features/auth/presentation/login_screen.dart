import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/auth_provider.dart';
import '../../../core/widgets/loader.dart';
import '../../../core/utils/snackbar_utils.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _validateInputs() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) {
      showSnackBar(context, 'Email is required', isError: true);
      return false;
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      showSnackBar(context, 'Enter a valid email', isError: true);
      return false;
    }

    if (password.isEmpty) {
      showSnackBar(context, 'Password is required', isError: true);
      return false;
    }
    return true;
  }

  String _firebaseErrorToMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'No user found for that email.';
    } else if (error.contains('wrong-password')) {
      return 'Incorrect password.';
    } else if (error.contains('invalid-email')) {
      return 'The email address is invalid.';
    }
    return error;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
                  ElevatedButton(
                    onPressed: () async {
                      if (!_validateInputs()) return;
                      final error = await auth.signIn(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                      if (!mounted) return;
                      if (error != null) {
                        showSnackBar(context, _firebaseErrorToMessage(error),
                            isError: true);
                      } else {
                        showSnackBar(context, "Login successful!");
                      }
                    },
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()),
                      );
                    },
                    child: const Text("Don't have an account? Sign up"),
                  ),
                ],
              ),
            ),
    );
  }
}
