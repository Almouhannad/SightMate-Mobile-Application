import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/shared/theme/theme.dart';

/// widget to select theme mode
class ThemeSettings extends StatelessWidget {
  const ThemeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ThemeNotifier>();
    return Scaffold(
      appBar: AppBar(title: Text(L10n.current.themeSettings)),
      body:
          notifier.initialized
              ? ListView(
                children:
                    ThemeMode.values.map((mode) {
                      return RadioListTile<ThemeMode>(
                        title: Text(_modeLabel(mode)),
                        value: mode,
                        groupValue: notifier.mode,
                        onChanged: (newMode) {
                          if (newMode != null) {
                            notifier.updateMode(newMode);
                          }
                        },
                      );
                    }).toList(),
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }

  String _modeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return L10n.current.lightMode;
      case ThemeMode.dark:
        return L10n.current.darkMode;
      case ThemeMode.system:
        return L10n.current.systemThemeMode;
    }
  }
}
