import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sight_mate/core/page_route_settings.dart';
import 'package:sight_mate/modules/ocr/presentation/ocr_presentation.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/shared/theme/theme.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});
  final _ttsProvider = GetIt.I.get<TtsProvider>();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold);

    Widget buildRouteListTile(
      PageRouteSettings pageRouteSettings,
      IconData iconData,
    ) {
      return ListTile(
        leading: Icon(iconData),
        title: Text(pageRouteSettings.name, style: textStyle),
        onTap: () async {
          //close the drawer
          Navigator.of(context).pop();

          // check the current route name
          final currentRoute = ModalRoute.of(context)?.settings.name;
          if (currentRoute == pageRouteSettings.link) {
            // We’re already on that route—do nothing else.
            _ttsProvider.speak(pageRouteSettings.name);
            return;
          }

          // push the new page
          Navigator.of(context).popUntil(ModalRoute.withName('/'));
          Navigator.of(context).pushNamed(pageRouteSettings.link);
          _ttsProvider.speak(pageRouteSettings.name);
        },
      );
    }

    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
              alignment: Alignment.center,
              child: Text(L10n.current.appMenu, style: textStyle),
            ),

            const Divider(),

            buildRouteListTile(OcrHomeScreenRoute(), Icons.translate),
            buildRouteListTile(ThemeSettingsRoute(), Icons.color_lens),
            buildRouteListTile(LanguageSettingsRoute(), Icons.language),
          ],
        ),
      ),
    );
  }
}
