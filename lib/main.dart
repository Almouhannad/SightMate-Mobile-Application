import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sight_mate/app/routes.dart';
import 'package:sight_mate/modules/home/presentation/app_drawer.dart';
import 'package:sight_mate/modules/home/presentation/home_page.dart';
import 'app/injection.dart';
import 'modules/shared/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'modules/shared/i18n/i18n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(); // Initialize GetIt registrations
  runApp(const SightMateApp());
}

class SightMateApp extends StatelessWidget {
  const SightMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = getIt<ThemeNotifier>();
    final i18nNotifier = getIt<I18nNotifier>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>.value(value: themeNotifier),
        ChangeNotifierProvider<I18nNotifier>.value(value: i18nNotifier),
      ],
      child: Consumer2<ThemeNotifier, I18nNotifier>(
        builder: (_, theme, i18n, __) {
          // Ensure we don't render before initial load completes
          if (!theme.initialized || !i18n.initialized) {
            return const SizedBox.shrink();
          }
          return MaterialApp(
            // Hide debug banner
            debugShowCheckedModeBanner: false,
            // Router settings
            onGenerateRoute: onGenerateRoute,
            // Theme management
            theme: theme.lightTheme,
            darkTheme: theme.darkTheme,
            themeMode: theme.mode,
            // i18n config
            localizationsDelegates: [
              L10n.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: i18n.supportedLocales,
            locale:
                i18n.locale ??
                L10n.delegate.supportedLocales.first, // 'en' default locale
            // Root
            home: Scaffold(
              drawer: AppDrawer(),
              body: HelloWorldWidget(),
              appBar: AppBar(title: Text('Sight Mate')),
            ),
          );
        },
      ),
    );
  }
}
