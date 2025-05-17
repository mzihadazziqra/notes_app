import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/utils/base_url.dart';
import '../db/app_database.dart';
import '../db/note_database.dart';
import '../db/user_database.dart';
import '../models/user.dart';

class AuthService with ChangeNotifier {
  static const String baseUrl = '${BaseUrl.baseUrl}/api';
  String? _token;

  String? get token => _token;
  bool get isLoggedIn => _token != null;

  // Auto login
  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    notifyListeners();
  }

  // Register
  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);

        final user =
            User()
              ..id = 0
              ..name = data['user']['name']
              ..email = data['user']['email'];

        await UserDatabase(AppDatabase.isar).saveUser(user);

        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Register error: $e');
    }
    return false;
  }

  // Login
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);

        final user =
            User()
              ..id = 0
              ..name = data['user']['name']
              ..email = data['user']['email'];

        await UserDatabase(AppDatabase.isar).saveUser(user);

        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Login error: $e');
    }
    return false;
  }

  // Logout
  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await NoteDatabase(AppDatabase.isar).clearAllData();
    await UserDatabase(AppDatabase.isar).clearUser();
    notifyListeners();
  }

  // Token getter
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
