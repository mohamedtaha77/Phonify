import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user.dart';
import 'package:uuid/uuid.dart';

class AuthProvider with ChangeNotifier {
  static const String usersBoxName = 'usersBox';
  static const String currentUserKey = 'currentUser';

  User? _user;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  User? get user => _user;

  AuthProvider() {
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final box = await Hive.openBox(usersBoxName);
    final data = box.get(currentUserKey);
    if (data != null) {
      _user = User.fromJson(Map<String, dynamic>.from(data));
      _isAuthenticated = true;
    }
    notifyListeners();
  }

  bool signIn(String email, String password) {
    final box = Hive.box(usersBoxName);
    final users = box.values.map((e) => Map<String, dynamic>.from(e)).toList();

    final user = users.firstWhere(
          (u) => u['email'] == email && u['password'] == password,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      _user = User.fromJson(user);
      _isAuthenticated = true;
      box.put(currentUserKey, user);
      notifyListeners();
      return true;
    }
    return false;
  }

  bool signUp(String name, String email, String password) {
    final box = Hive.box(usersBoxName);
    final users = box.values.map((e) => Map<String, dynamic>.from(e)).toList();

    if (users.any((u) => u['email'] == email)) return false;

    final user = User(
      id: const Uuid().v4(),
      name: name,
      email: email,
    );

    final data = user.toJson();
    data['password'] = password;

    box.add(data);
    box.put(currentUserKey, data);

    _user = user;
    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  void signOut() {
    final box = Hive.box(usersBoxName);
    box.delete(currentUserKey);
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}