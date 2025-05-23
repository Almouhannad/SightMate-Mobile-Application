import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sight_mate/app/routes.dart';
import 'package:sight_mate/modules/home/presentation/home_page.dart';
import 'app/injection.dart';
import 'modules/theme/presentation/theme_notifier.dart';

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
            onGenerateRoute: onGenerateRoute,
            debugShowCheckedModeBanner: false,
            theme: notifier.lightTheme,
            darkTheme: notifier.darkTheme,
            themeMode: notifier.mode,
            home: const HomePage(), // Root widget
          );
        },
      ),
    );
  }
}
