import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  // Simula un login exitoso
  void login() {
    _isAuthenticated = true;
    notifyListeners(); // Actualiza la UI
  }

  // Simula un logout
  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}