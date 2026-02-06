import 'package:flutter/material.dart' as flutter;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

const String _themeModeKey = 'theme_mode';

@riverpod
class ThemeMode extends _$ThemeMode {
  @override
  ThemeModeOption build() {
    // Load saved preference
    _loadThemePreference();
    return ThemeModeOption.system;
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_themeModeKey);
    
    if (savedMode != null) {
      state = ThemeModeOption.fromString(savedMode);
    }
  }

  Future<void> setThemeMode(ThemeModeOption mode) async {
    state = mode;
    
    // Persist to storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
  }
}

enum ThemeModeOption {
  light,
  dark,
  system;

  String get displayName {
    switch (this) {
      case ThemeModeOption.light:
        return 'Light';
      case ThemeModeOption.dark:
        return 'Dark';
      case ThemeModeOption.system:
        return 'System Default';
    }
  }

  flutter.IconData get icon {
    switch (this) {
      case ThemeModeOption.light:
        return flutter.Icons.light_mode;
      case ThemeModeOption.dark:
        return flutter.Icons.dark_mode;
      case ThemeModeOption.system:
        return flutter.Icons.brightness_auto;
    }
  }

  flutter.ThemeMode toFlutterThemeMode() {
    switch (this) {
      case ThemeModeOption.light:
        return flutter.ThemeMode.light;
      case ThemeModeOption.dark:
        return flutter.ThemeMode.dark;
      case ThemeModeOption.system:
        return flutter.ThemeMode.system;
    }
  }

  static ThemeModeOption fromString(String value) {
    switch (value) {
      case 'light':
        return ThemeModeOption.light;
      case 'dark':
        return ThemeModeOption.dark;
      case 'system':
      default:
        return ThemeModeOption.system;
    }
  }
}
