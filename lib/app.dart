import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/domain/auth_provider.dart';
import 'features/notes/data/notes_repository.dart';
import 'features/notes/domain/notes_provider.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/notes/presentation/notes_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthRepository())),
      ],
      child: MaterialApp(
        title: 'Note Taking App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const RootScreen(),
      ),
    );
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.user != null) {
          return ChangeNotifierProvider(
            create: (_) => NotesProvider(
              NotesRepository(),
              auth.user!.uid,
            )..fetchNotes(),
            child: const NotesScreen(),
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
