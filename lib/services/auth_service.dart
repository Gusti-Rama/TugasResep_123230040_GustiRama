import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/models/user.dart';


class AuthService {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';

  // Register a new user
  static Future<bool> register(String username, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList(_usersKey) ?? [];

      // Check if user already exists
      for (var userJson in usersJson) {
        final user = User.fromJson(jsonDecode(userJson));
        if (user.username == username) {
          return false; // User already exists
        }
      }

      // Add new user
      final newUser = User(username: username, password: password);
      usersJson.add(jsonEncode(newUser.toJson()));
      await prefs.setStringList(_usersKey, usersJson);
      return true;
    } catch (e) {
      throw Exception('Error registering user: $e');
    }
  }

  // Login user
  static Future<bool> login(String username, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList(_usersKey) ?? [];

      for (var userJson in usersJson) {
        final user = User.fromJson(jsonDecode(userJson));
        if (user.username == username && user.password == password) {
          // Save current user
          await prefs.setString(_currentUserKey, username);
          return true;
        }
      }
      return false; // User not found or password incorrect
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  // Get current logged-in user
  static Future<String?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_currentUserKey);
    } catch (e) {
      throw Exception('Error getting current user: $e');
    }
  }

  // Logout user
  static Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentUserKey);
      return true;
    } catch (e) {
      throw Exception('Error logging out: $e');
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_currentUserKey) != null;
    } catch (e) {
      throw Exception('Error checking login status: $e');
    }
  }
}

