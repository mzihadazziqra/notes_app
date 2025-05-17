import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../models/user.dart';

class UserDatabase extends ChangeNotifier {
  final Isar isar;

  UserDatabase(this.isar);

  User? _currentUser;
  User? get currentUser => _currentUser;

  // Save current login user (overwrite)
  Future<void> saveUser(User user) async {
    await isar.writeTxn(() async {
      await isar.users.put(user);
    });
    _currentUser = user;
    notifyListeners();
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    _currentUser = await isar.users.get(0);
    return _currentUser;
  }

  // Delete user when logout
  Future<void> clearUser() async {
    await isar.writeTxn(() async {
      await isar.users.delete(0);
    });
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> isUserLoggedIn() async {
    return await getCurrentUser() != null;
  }
}
