import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sight_mate/app/pop_observer.dart';
import 'package:sight_mate/app/routes.dart';
import 'package:sight_mate/modules/shared/authentication/presentation/authentication_presentation.dart';
import 'app/injection.dart';
import 'modules/shared/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'modules/shared/i18n/i18n.dart';
import 'modules/shared/widgets/shared_widgets.dart';
import 'modules/shared/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await configureDependencies(); // Initialize GetIt registrations
  runApp(const SightMateApp());
}

class SightMateApp extends StatelessWidget {
  const SightMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = DI<ThemeNotifier>();
    final i18nNotifier = DI<I18nNotifier>();
    final authenticationNotifier = DI<AuthenticationNotifier>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>.value(value: themeNotifier),
        ChangeNotifierProvider<I18nNotifier>.value(value: i18nNotifier),
        ChangeNotifierProvider<AuthenticationNotifier>.value(
          value: authenticationNotifier,
        ),
      ],
      child: Consumer3<ThemeNotifier, I18nNotifier, AuthenticationNotifier>(
        builder: (_, theme, i18n, authentication, __) {
          // Ensure we don't render before initial load completes
          if (!theme.initialized ||
              !i18n.initialized ||
              !authentication.isInitialized) {
            return const SizedBox.shrink();
          }
          return MaterialApp(
            // Hide debug banner
            debugShowCheckedModeBanner: false,
            // Router settings
            onGenerateRoute: onGenerateRoute,
            navigatorObservers: [PopObserver()],
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
            home: WidgetScaffold(body: HelloWorldWidget(), title: 'Sight Mate'),
          );
        },
      ),
    );
  }
}
