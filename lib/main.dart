import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sight_mate/app/routes.dart';
import 'package:sight_mate/modules/home/presentation/home_page.dart';
import 'app/injection.dart';
import 'modules/shared/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sight_mate/generated/l10n.dart';

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

    return ChangeNotifierProvider<ThemeNotifier>.value(
      value: themeNotifier,
      child: Consumer<ThemeNotifier>(
        builder: (_, notifier, __) {
          // Ensure we don't render before initial load completes
          if (!notifier.initialized) {
            return const SizedBox.shrink();
          }
          return MaterialApp(
            // Hide debug banner
            debugShowCheckedModeBanner: false,
            // Router settings
            onGenerateRoute: onGenerateRoute,
            // Theme management
            theme: notifier.lightTheme,
            darkTheme: notifier.darkTheme,
            themeMode: notifier.mode,
            // i18n config
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            // Root
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
