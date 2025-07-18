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

  /// `Welcome to Sight Mate`
  String get helloWorld {
    return Intl.message(
      'Welcome to Sight Mate',
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

  /// `Live Mode`
  String get liveMode {
    return Intl.message('Live Mode', name: 'liveMode', desc: '', args: []);
  }

  /// `Capture Mode`
  String get captureMode {
    return Intl.message(
      'Capture Mode',
      name: 'captureMode',
      desc: '',
      args: [],
    );
  }

  /// `{mode} activated`
  String activated(String mode) {
    return Intl.message(
      '$mode activated',
      name: 'activated',
      desc: '',
      args: [mode],
    );
  }

  /// `Processing, please wait`
  String get pleaseWait {
    return Intl.message(
      'Processing, please wait',
      name: 'pleaseWait',
      desc: '',
      args: [],
    );
  }

  /// `Describe`
  String get describe {
    return Intl.message('Describe', name: 'describe', desc: '', args: []);
  }

  /// `Object Mode`
  String get objectMode {
    return Intl.message('Object Mode', name: 'objectMode', desc: '', args: []);
  }

  /// `Image Mode`
  String get imageMode {
    return Intl.message('Image Mode', name: 'imageMode', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `Image Caption`
  String get imageCaption {
    return Intl.message(
      'Image Caption',
      name: 'imageCaption',
      desc: '',
      args: [],
    );
  }

  /// `Question`
  String get question {
    return Intl.message('Question', name: 'question', desc: '', args: []);
  }

  /// `Answer`
  String get answer {
    return Intl.message('Answer', name: 'answer', desc: '', args: []);
  }

  /// `Ask a question`
  String get askQuestion {
    return Intl.message(
      'Ask a question',
      name: 'askQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Type or speak`
  String get typeOrSpeak {
    return Intl.message(
      'Type or speak',
      name: 'typeOrSpeak',
      desc: '',
      args: [],
    );
  }

  /// `Record`
  String get record {
    return Intl.message('Record', name: 'record', desc: '', args: []);
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Select a mode from app menu or speak to select mode`
  String get selectMode {
    return Intl.message(
      'Select a mode from app menu or speak to select mode',
      name: 'selectMode',
      desc: '',
      args: [],
    );
  }

  /// `Unrecognized mode. Plaese try again`
  String get unrecognizedMode {
    return Intl.message(
      'Unrecognized mode. Plaese try again',
      name: 'unrecognizedMode',
      desc: '',
      args: [],
    );
  }

  /// `Selected mode is not available now. Please try again later`
  String get unavailableMode {
    return Intl.message(
      'Selected mode is not available now. Please try again later',
      name: 'unavailableMode',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Confirm {action}`
  String confirmAction(String action) {
    return Intl.message(
      'Confirm $action',
      name: 'confirmAction',
      desc: '',
      args: [action],
    );
  }

  /// `Are you sure you want to {action}`
  String areYouSure(String action) {
    return Intl.message(
      'Are you sure you want to $action',
      name: 'areYouSure',
      desc: '',
      args: [action],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Hello {user} !`
  String helloUser(String user) {
    return Intl.message(
      'Hello $user !',
      name: 'helloUser',
      desc: '',
      args: [user],
    );
  }

  /// `Login to access all features!`
  String get loginMessage {
    return Intl.message(
      'Login to access all features!',
      name: 'loginMessage',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Last Name`
  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Please Enter your {item}`
  String pleaseEnterYour(String item) {
    return Intl.message(
      'Please Enter your $item',
      name: 'pleaseEnterYour',
      desc: '',
      args: [item],
    );
  }

  /// `Please enter a valid email`
  String get validEmailValidationMessage {
    return Intl.message(
      'Please enter a valid email',
      name: 'validEmailValidationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least {length} characters`
  String passwordLengthValidationMessage(int length) {
    return Intl.message(
      'Password must be at least $length characters',
      name: 'passwordLengthValidationMessage',
      desc: '',
      args: [length],
    );
  }

  /// `Don't have an account ? Register now`
  String get registerMessage {
    return Intl.message(
      'Don\'t have an account ? Register now',
      name: 'registerMessage',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account ? Login now`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account ? Login now',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `I accept that my data will be stored and used for research`
  String get acceptTerms {
    return Intl.message(
      'I accept that my data will be stored and used for research',
      name: 'acceptTerms',
      desc: '',
      args: [],
    );
  }

  /// `{action} done successfully`
  String actionDoneSuccessfully(String action) {
    return Intl.message(
      '$action done successfully',
      name: 'actionDoneSuccessfully',
      desc: '',
      args: [action],
    );
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
