// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class L10n {
  L10n();

  static L10n? _current;

  static L10n get current {
    assert(
      _current != null,
      'No instance of L10n was loaded. Try to initialize the L10n delegate before accessing L10n.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<L10n> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = L10n();
      L10n._current = instance;

      return instance;
    });
  }

  static L10n of(BuildContext context) {
    final instance = L10n.maybeOf(context);
    assert(
      instance != null,
      'No instance of L10n present in the widget tree. Did you add L10n.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static L10n? maybeOf(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  /// `Sight Mate`
  String get appName {
    return Intl.message('Sight Mate', name: 'appName', desc: '', args: []);
  }

  /// `Theme settings`
  String get themeSettings {
    return Intl.message(
      'Theme settings',
      name: 'themeSettings',
      desc: '',
      args: [],
    );
  }

  /// `Language settings`
  String get languageSettings {
    return Intl.message(
      'Language settings',
      name: 'languageSettings',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get lightMode {
    return Intl.message('Light', name: 'lightMode', desc: '', args: []);
  }

  /// `Dark`
  String get darkMode {
    return Intl.message('Dark', name: 'darkMode', desc: '', args: []);
  }

  /// `System`
  String get systemThemeMode {
    return Intl.message('System', name: 'systemThemeMode', desc: '', args: []);
  }

  /// `App menu`
  String get appMenu {
    return Intl.message('App menu', name: 'appMenu', desc: '', args: []);
  }

  /// `Hello, world!`
  String get helloWorld {
    return Intl.message(
      'Hello, world!',
      name: 'helloWorld',
      desc: '',
      args: [],
    );
  }

  /// `Preview`
  String get preview {
    return Intl.message('Preview', name: 'preview', desc: '', args: []);
  }

  /// `READ`
  String get read {
    return Intl.message('READ', name: 'read', desc: '', args: []);
  }

  /// `Incorrect selection!\nPlease try again`
  String get incorrectSelection {
    return Intl.message(
      'Incorrect selection!\nPlease try again',
      name: 'incorrectSelection',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred!\nPlease try again`
  String get errorOccurred {
    return Intl.message(
      'An error occurred!\nPlease try again',
      name: 'errorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `No text detected in selection`
  String get noTextDetected {
    return Intl.message(
      'No text detected in selection',
      name: 'noTextDetected',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Replay`
  String get replay {
    return Intl.message('Replay', name: 'replay', desc: '', args: []);
  }

  /// `Text Mode`
  String get textMode {
    return Intl.message('Text Mode', name: 'textMode', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<L10n> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<L10n> load(Locale locale) => L10n.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
