import 'package:flutter/material.dart';
import 'package:sight_mate/modules/shared/theme/theme.dart';

/// A ChangeNotifier that holds the current ThemeMode and notifies listeners on changes
class ThemeNotifier extends ChangeNotifier {
  final ThemeRepository _repository;

  ThemeMode _mode = ThemeMode.system;
  bool _initialized = false;

  ThemeNotifier(this._repository) {
    _loadInitialMode();
  }

  /// The current theme mode exposed to the UI
  ThemeMode get mode => _mode;

  /// Whether the notifier has finished loading the initial mode.
  bool get initialized => _initialized;

  /// load the saved theme mode from the repository
  Future<void> _loadInitialMode() async {
    final savedMode = await _repository.loadThemeMode();
    if (savedMode != null) {
      _mode = savedMode;
    }
    _initialized = true;
    notifyListeners();
  }

  /// Updates the theme mode, persists it and notifies the litseners
  Future<void> updateMode(ThemeMode newMode) async {
    if (newMode == _mode) return;
    _mode = newMode;
    notifyListeners();
    await _repository.saveThemeMode(newMode);
  }

  /// Convenience getters for ThemeData.
  ThemeData get lightTheme => _repository.lightTheme;
  ThemeData get darkTheme => _repository.darkTheme;
}
