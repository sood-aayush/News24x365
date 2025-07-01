// lib/theme/theme_provider.dart or lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For persisting theme preference

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system; // Default to system theme

  ThemeMode get themeMode => _themeMode;

  // Constructor to load theme preference when app starts
  ThemeProvider() {
    _loadThemeMode();
  }

  // Sets the new theme mode and saves it
  void setThemeMode(ThemeMode mode) {
    if (mode != _themeMode) {
      _themeMode = mode;
      _saveThemeMode(mode); // Save the preference
      notifyListeners(); // Notify widgets that depend on this provider
    }
  }

  // Loads theme preference from SharedPreferences
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final String? theme = prefs.getString('themeMode');
    if (theme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (theme == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode =
          ThemeMode.system; // Fallback to system if not found or invalid
    }
    notifyListeners(); // Notify after loading
  }

  // Saves theme preference to SharedPreferences
  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'themeMode',
      mode.toString().split('.').last,
    ); // 'ThemeMode.dark' -> 'dark'
  }
}
