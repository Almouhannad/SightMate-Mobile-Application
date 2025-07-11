// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(action) => "${action} done successfully";

  static String m1(mode) => "${mode} activated";

  static String m2(action) => "Are you sure you want to ${action}";

  static String m3(action) => "Confirm ${action}";

  static String m4(user) => "Hello ${user} !";

  static String m5(length) => "Password must be at least ${length} characters";

  static String m6(item) => "Please Enter your ${item}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "acceptTerms": MessageLookupByLibrary.simpleMessage(
      "I accept that my data will be stored and used for research",
    ),
    "actionDoneSuccessfully": m0,
    "activated": m1,
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account ? Login now",
    ),
    "answer": MessageLookupByLibrary.simpleMessage("Answer"),
    "appMenu": MessageLookupByLibrary.simpleMessage("App menu"),
    "appName": MessageLookupByLibrary.simpleMessage("Sight Mate"),
    "areYouSure": m2,
    "askQuestion": MessageLookupByLibrary.simpleMessage("Ask a question"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "captureMode": MessageLookupByLibrary.simpleMessage("Capture Mode"),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "confirmAction": m3,
    "darkMode": MessageLookupByLibrary.simpleMessage("Dark"),
    "describe": MessageLookupByLibrary.simpleMessage("Describe"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "errorOccurred": MessageLookupByLibrary.simpleMessage(
      "An error occurred!\nPlease try again",
    ),
    "firstName": MessageLookupByLibrary.simpleMessage("First Name"),
    "helloUser": m4,
    "helloWorld": MessageLookupByLibrary.simpleMessage("Welcome to Sight Mate"),
    "history": MessageLookupByLibrary.simpleMessage("History"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "imageCaption": MessageLookupByLibrary.simpleMessage("Image Caption"),
    "imageMode": MessageLookupByLibrary.simpleMessage("Image Mode"),
    "incorrectSelection": MessageLookupByLibrary.simpleMessage(
      "Incorrect selection!\nPlease try again",
    ),
    "languageSettings": MessageLookupByLibrary.simpleMessage(
      "Language settings",
    ),
    "lastName": MessageLookupByLibrary.simpleMessage("Last Name"),
    "lightMode": MessageLookupByLibrary.simpleMessage("Light"),
    "liveMode": MessageLookupByLibrary.simpleMessage("Live Mode"),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "loginMessage": MessageLookupByLibrary.simpleMessage(
      "Login to access all features!",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "noTextDetected": MessageLookupByLibrary.simpleMessage(
      "No text detected in selection",
    ),
    "objectMode": MessageLookupByLibrary.simpleMessage("Object Mode"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordLengthValidationMessage": m5,
    "pleaseEnterYour": m6,
    "pleaseWait": MessageLookupByLibrary.simpleMessage(
      "Processing, please wait",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("Preview"),
    "question": MessageLookupByLibrary.simpleMessage("Question"),
    "read": MessageLookupByLibrary.simpleMessage("READ"),
    "record": MessageLookupByLibrary.simpleMessage("Record"),
    "register": MessageLookupByLibrary.simpleMessage("Register"),
    "registerMessage": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account ? Register now",
    ),
    "replay": MessageLookupByLibrary.simpleMessage("Replay"),
    "selectMode": MessageLookupByLibrary.simpleMessage(
      "Select a mode from app menu or speak to select mode",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "submit": MessageLookupByLibrary.simpleMessage("Submit"),
    "systemThemeMode": MessageLookupByLibrary.simpleMessage("System"),
    "textMode": MessageLookupByLibrary.simpleMessage("Text Mode"),
    "themeSettings": MessageLookupByLibrary.simpleMessage("Theme settings"),
    "typeOrSpeak": MessageLookupByLibrary.simpleMessage("Type or speak"),
    "unavailableMode": MessageLookupByLibrary.simpleMessage(
      "Selected mode is not available now. Please try again later",
    ),
    "unrecognizedMode": MessageLookupByLibrary.simpleMessage(
      "Unrecognized mode. Plaese try again",
    ),
    "validEmailValidationMessage": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email",
    ),
  };
}
