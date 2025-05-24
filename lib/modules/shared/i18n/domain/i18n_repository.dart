import 'package:flutter/material.dart';

/// An abstract contract for reading and writing the user's locale preference
abstract class I18nRepository {
  /// Returns the saved [Locale], or null if not yet set
  Future<Locale?> loadLocale();

  /// Persists the user's [Locale] selection
  Future<void> saveLocale(Locale locale);

  /// Returns the list of supported locales in the application
  List<Locale> get supportedLocales;
}
