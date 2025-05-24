import 'package:flutter/material.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';

/// A ChangeNotifier that holds the current Locale and notifies listeners on changes
class I18nNotifier extends ChangeNotifier {
  final I18nRepository _repository;

  Locale? _locale;
  bool _initialized = false;

  I18nNotifier(this._repository) {
    _loadInitialLocale();
  }

  /// The current locale exposed to the UI
  Locale? get locale => _locale;

  /// Whether the notifier has finished loading the initial locale
  bool get initialized => _initialized;

  /// List of supported locales in the application
  List<Locale> get supportedLocales => _repository.supportedLocales;

  /// Load the saved locale from the repository
  Future<void> _loadInitialLocale() async {
    final savedLocale = await _repository.loadLocale();
    if (savedLocale != null) {
      _locale = savedLocale;
    }
    _initialized = true;
    notifyListeners();
  }

  /// Updates the locale, persists it and notifies the listeners
  Future<void> updateLocale(Locale newLocale) async {
    if (newLocale == _locale) return;
    _locale = newLocale;
    notifyListeners();
    await _repository.saveLocale(newLocale);
  }
}
