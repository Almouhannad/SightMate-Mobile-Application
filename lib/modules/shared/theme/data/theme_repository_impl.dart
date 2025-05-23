import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sight_mate/modules/shared/theme/domain/theme_repository.dart';

/// Key used for peristing theme select
const _kThemeModeKey = 'user_theme_mode';

/// Concrete implementation of [ThemeRepository] using SharedPreferences (On-device)
class ThemeRepositoryImpl implements ThemeRepository {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Future<ThemeMode?> loadThemeMode() async {
    final prefs = await _prefs;
    final stored = prefs.getString(_kThemeModeKey);
    switch (stored) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return null;
    }
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await _prefs;
    final value =
        mode == ThemeMode.light
            ? 'light'
            : mode == ThemeMode.dark
            ? 'dark'
            : 'system';
    await prefs.setString(_kThemeModeKey, value);
  }

  @override
  ThemeData get lightTheme {
    final base = ThemeData.light();
    // TODO: Define theme data
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.light,
      ),
      textTheme: base.textTheme.apply(fontFamily: 'Times New Roman'),
    );
  }

  @override
  ThemeData get darkTheme {
    final base = ThemeData.dark();
    // TODO: Define theme data
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey,
        brightness: Brightness.dark,
      ),
      textTheme: base.textTheme.apply(fontFamily: 'Times New Roman'),
    );
  }
}
