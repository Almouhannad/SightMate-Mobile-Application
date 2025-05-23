import 'package:flutter/material.dart';

/// An abstract contract for reading and writing the user's theme preference
abstract class ThemeRepository {
  /// Returns the saved [ThemeMode], or null if not yet set
  Future<ThemeMode?> loadThemeMode();

  /// Persists the user's [ThemeMode] selection
  Future<void> saveThemeMode(ThemeMode mode);

  /// Provides the light theme configuration
  ThemeData get lightTheme;

  /// Provides the dark theme configuration
  ThemeData get darkTheme;
}
