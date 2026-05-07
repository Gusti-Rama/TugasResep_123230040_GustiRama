import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/models/user.dart';

class AuthService {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';

  static Future<bool> register(String username, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList(_usersKey) ?? [];

      for (var userJson in usersJson) {
        final user = User.fromJson(jsonDecode(userJson));
        if (user.username == username) {
          return false;
        }
      }

      final newUser = User(username: username, password: password);
      usersJson.add(jsonEncode(newUser.toJson()));
      await prefs.setStringList(_usersKey, usersJson);
      return true;
    } catch (e) {
      throw Exception('Gagal mendaftar: $e');
    }
  }

  static Future<bool> login(String username, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList(_usersKey) ?? [];

      for (var userJson in usersJson) {
        final user = User.fromJson(jsonDecode(userJson));
        if (user.username == username && user.password == password) {
          await prefs.setString(_currentUserKey, username);
          return true;
        }
      }
      return false;
    } catch (e) {
      throw Exception('Gagal masuk: $e');
    }
  }

  static Future<String?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_currentUserKey);
    } catch (e) {
      throw Exception('Gagal mendapatkan pengguna saat ini: $e');
    }
  }

  static Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentUserKey);
      return true;
    } catch (e) {
      throw Exception('Gagal logout: $e');
    }
  }

  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_currentUserKey) != null;
    } catch (e) {
      throw Exception('Gagal memeriksa status login: $e');
    }
  }
}
