import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sight_mate/modules/shared/i18n/domain/i18n_repository.dart';
import 'package:sight_mate/modules/shared/i18n/data/l10n/l10n.dart';

/// Key used for persisting locale selection
const _kLocaleKey = 'user_locale';

/// Concrete implementation of [I18nRepository] using SharedPreferences
class I18nRepositoryImpl implements I18nRepository {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Future<Locale?> loadLocale() async {
    final prefs = await _prefs;
    final stored = prefs.getString(_kLocaleKey);
    if (stored == null) return null;

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
