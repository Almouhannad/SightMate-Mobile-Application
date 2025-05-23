import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modules/shared/theme/data/theme_repository_impl.dart';
import '../modules/shared/theme/domain/theme_repository.dart';
import '../modules/shared/theme/presentation/theme_notifier.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // ThemeRepository: concrete implementation
  getIt.registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImpl());

  // ThemeNotifier: depends on ThemeRepository
  getIt.registerLazySingleton<ThemeNotifier>(
    () => ThemeNotifier(getIt<ThemeRepository>()),
  );
}
