import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String username, String password) async {
    try {
      final user = await DatabaseHelper.instance.authenticateUser(
        username,
        password,
      );

      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      // Mode développement web : permettre la connexion avec admin/admin même sans DB
      if (username == 'admin' && password == 'admin') {
        _currentUser = User(id: 1, username: username, password: password);
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      return false;
    }
  }

  Future<bool> register(String username, String password) async {
    try {
      final user = await DatabaseHelper.instance.createUser(
        username,
        password,
      );

      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      // Mode développement web : permettre l'inscription en mémoire
      if (username.isNotEmpty && password.length >= 4) {
        _currentUser = User(id: DateTime.now().millisecondsSinceEpoch, username: username, password: password);
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
