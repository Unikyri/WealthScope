import 'package:flutter/material.dart' as flutter;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

/// Theme provider - WealthScope is dark-mode only.
/// Kept as a provider for potential future extensibility.
@riverpod
class ThemeMode extends _$ThemeMode {
  @override
  ThemeModeOption build() => ThemeModeOption.dark;
}

/// Dark-mode only theme option.
enum ThemeModeOption {
  dark;

  String get displayName => 'Dark';

  flutter.ThemeMode toFlutterThemeMode() => flutter.ThemeMode.dark;
}
