import 'package:flutter/material.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/shared/theme/theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
              alignment: Alignment.center,
              child: Text(
                L10n.current.appMenu,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: Text(L10n.current.themeSettings),
              onTap: () {
                Navigator.of(context).popAndPushNamed(ThemeSettingsRoute.name);
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(L10n.current.languageSettings),
              onTap: () {
                Navigator.of(
                  context,
                ).popAndPushNamed(LanguageSettingsRoute.name);
              },
            ),
          ],
        ),
      ),
    );
  }
}
