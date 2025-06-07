import 'package:flutter/material.dart';
import 'package:sight_mate/modules/ocr/presentation/ocr_presentation.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/shared/theme/theme.dart';
import 'package:sight_mate/modules/yolo_object_recognition/yolo_object_recognition.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  Map<String, Widget> routes = {};
  routes[ThemeSettingsRoute().link] = ThemeSettings();
  routes[LanguageSettingsRoute().link] = LanguageSettings();
  routes[OcrHomeScreenRoute().link] = OcrHomeScreen();
  routes[ObjectRecognitionHomeScreenRoute().link] =
      ObjectRecognitionHomeScreen();

  if (routes.keys.contains(settings.name)) {
    return MaterialPageRoute(
      builder: (_) => routes[settings.name]!,
      settings: settings,
    );
  }
  return null;
}
