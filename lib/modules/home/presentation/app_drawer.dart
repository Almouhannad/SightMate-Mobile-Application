import 'package:flutter/material.dart';
import 'package:sight_mate/modules/shared/theme/presentation/theme_settings_route.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            alignment: Alignment.centerLeft,
            child: Text(
              'App Menu',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Theme Settings'),
            onTap: () {
              Navigator.of(context).pushNamed(ThemeSettingsRoute.name);
            },
          ),
        ],
      ),
    );
  }
}
