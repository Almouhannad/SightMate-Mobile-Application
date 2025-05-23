import 'package:flutter/material.dart';
import 'package:sight_mate/modules/theme/presentation/theme_settings.dart';
import 'package:sight_mate/modules/theme/presentation/theme_settings_route.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case ThemeSettingsRoute.name:
      return MaterialPageRoute(
        builder: (_) => const ThemeSettings(),
        settings: settings,
      );
    default:
      return null;
  }
}
