import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';

/// Key used for persisting locale selection
const _kLocaleKey = 'user_locale';

/// Concrete implementation of [I18nRepository] using SharedPreferences
class I18nRepositoryImpl implements I18nRepository {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Future<Locale?> loadLocale() async {
    final prefs = await _prefs;
    final stored = prefs.getString(_kLocaleKey);
    if (stored == null) return Locale("en");

    return Locale(stored);
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    final prefs = await _prefs;
    final value = locale.languageCode;
    await prefs.setString(_kLocaleKey, value);
  }

  @override
  List<Locale> get supportedLocales => L10n.delegate.supportedLocales;
}
