// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';

class ThemeProvider with ChangeNotifier {
  // Default value is light
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadFromPrefs(); // App start hote hi saved theme load karo
  }

  // Theme change karne aur save karne ka function
  void setTheme(ThemeMode mode) async {
    NavigationService.pop(); // Bottom sheet band karne ke liye
    // 2. Wait for the animation to complete (glitch preventer)
    await Future.delayed(const Duration(milliseconds: 300));
    _themeMode = mode;
    notifyListeners(); // UI update karne ke liye
    SharedPrefsHelper.setPreference(
      ESharedPreferences.theme_mode,
      mode.toString(),
    ); // Save to shared preferences
  }

  // Local storage se data nikalne ka logic
  void _loadFromPrefs() async {
    String themeStr = SharedPrefsHelper.getString(
      ESharedPreferences.theme_mode,
    );
    if (themeStr != null && themeStr != '') {
      // String ko wapas ThemeMode enum mein convert karna
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == themeStr,
        orElse: () => ThemeMode.light,
      );
    } else {
      _themeMode = ThemeMode.light; // Agar kuch nahi mila toh default light
    }
    notifyListeners();
  }
}
