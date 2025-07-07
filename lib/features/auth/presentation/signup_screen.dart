import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/auth_provider.dart';
import '../../../core/widgets/loader.dart';
import '../../../core/utils/snackbar_utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? signupError;

  void _resetInputs() {
    emailController.clear();
    passwordController.clear();
    setState(() {
      emailError = null;
      passwordError = null;
      signupError = null;
    });
  }

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
    } else if (password.length < 6) {
      showSnackBar(context, 'Password must be at least 6 characters',
          isError: true);
      return false;
    }

    return true;
  }

  String _firebaseErrorToMessage(String error) {
    if (error.contains('email-already-in-use')) {
      return 'This email is already in use.';
    } else if (error.contains('invalid-email')) {
      return 'The email address is invalid.';
    } else if (error.contains('weak-password')) {
      return 'The password is too weak.';
    }
    return error;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: auth.isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: emailError,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: passwordError,
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  if (signupError != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        signupError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_validateInputs()) return;
                      final error = await auth.signUp(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                      if (!mounted) return;
                      if (error != null) {
                        showSnackBar(context, _firebaseErrorToMessage(error),
                            isError: true);
                      } else {
                        showSnackBar(
                            context, "Signup successful! Please log in.");
                        _resetInputs();
                        await auth.signOut();
                        await Future.delayed(const Duration(milliseconds: 500));
                        if (mounted) Navigator.pop(context);
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to login
                    },
                    child: const Text('Already have an account? Log in'),
                  ),
                ],
              ),
            ),
    );
  }
}
