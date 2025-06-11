import 'package:flutter/material.dart';
import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/core/page_route_settings.dart';
import 'package:sight_mate/modules/ocr/presentation/ocr_presentation.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/shared/theme/theme.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';
import 'package:sight_mate/modules/vqa/domain/vqa_domain.dart';
import 'package:sight_mate/modules/vqa/presentation/vqa_presentation.dart';
import 'package:sight_mate/modules/yolo_object_recognition/yolo_object_recognition.dart';

class AppDrawer extends StatefulWidget {
  AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final _ttsProvider = DI.get<TtsProvider>();
  final _vqaConnectivityProvider = DI.get<VqaConnectivityProvider>();
  late Future<bool> _vqaConnectivityFuture;
  @override
  void initState() {
    super.initState();
    _vqaConnectivityFuture = _vqaConnectivityProvider.isConnected;
  }

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
          Navigator.of(context).pop(); // close drawer
          final currentRoute = ModalRoute.of(context)?.settings.name;
          if (currentRoute == pageRouteSettings.link) {
            _ttsProvider.speak(pageRouteSettings.name);
            return;
          }
          Navigator.of(context).popUntil(ModalRoute.withName('/'));
          Navigator.of(context).pushNamed(pageRouteSettings.link);
          _ttsProvider.speak(pageRouteSettings.name);
        },
      );
    }

    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Expanded(
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
                  buildRouteListTile(
                    ObjectRecognitionHomeScreenRoute(),
                    Icons.chair_rounded,
                  ),
                  FutureBuilder<bool>(
                    future: _vqaConnectivityFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data == true) {
                        return buildRouteListTile(
                          // only shows when connected
                          VqaHomeScreenRoute(),
                          Icons.image,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(L10n.current.settings, style: textStyle),
              ),
            ),
            buildRouteListTile(ThemeSettingsRoute(), Icons.color_lens),
            buildRouteListTile(LanguageSettingsRoute(), Icons.language),
          ],
        ),
      ),
    );
  }
}
