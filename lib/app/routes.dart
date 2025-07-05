import 'package:flutter/material.dart';
import 'package:sight_mate/modules/ocr/presentation/ocr_presentation.dart';
import 'package:sight_mate/modules/shared/authentication/presentation/authentication_presentation.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/shared/theme/theme.dart';
import 'package:sight_mate/modules/vqa/presentation/vqa_presentation.dart';
import 'package:sight_mate/modules/yolo_object_recognition/yolo_object_recognition.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  Map<String, Widget> routes = {};
  routes[ThemeSettingsRoute().link] = ThemeSettings();
  routes[LanguageSettingsRoute().link] = LanguageSettings();
  routes[OcrHomeScreenRoute().link] = OcrHomeScreen();
  routes[ObjectRecognitionHomeScreenRoute().link] =
      ObjectRecognitionHomeScreen();
  routes[VqaHomeScreenRoute().link] = VqaHomeScreen();
  routes[LoginPageRoute().link] = LoginPage();
  routes[RegisterPageRoute().link] = RegisterPage();

  if (routes.keys.contains(settings.name)) {
    return MaterialPageRoute(
      builder: (_) => routes[settings.name]!,
      settings: settings,
    );
  }
  return null;
}
