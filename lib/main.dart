import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Only initialize if not already initialized
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}
