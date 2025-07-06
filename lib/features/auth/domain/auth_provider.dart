import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _repo;
  User? user;
  bool isLoading = false;

  AuthProvider(this._repo) {
    _repo.user.listen((u) {
      user = u;
      notifyListeners();
    });
  }

  Future<String?> signUp(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      await _repo.signUp(email, password);
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> signIn(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      await _repo.signIn(email, password);
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
  }
}
