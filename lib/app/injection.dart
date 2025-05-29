import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sight_mate/modules/ocr/data/ocr_data.dart';
import 'package:sight_mate/modules/ocr/domain/providers/ocr_provider.dart';
import 'package:sight_mate/modules/shared/theme/theme.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';

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

  // I18nRepository: concrete implementation
  getIt.registerLazySingleton<I18nRepository>(() => I18nRepositoryImpl());

  // I18nNotifier: depends on I18nRepository
  getIt.registerLazySingleton<I18nNotifier>(
    () => I18nNotifier(getIt<I18nRepository>()),
  );

  // OCR
  void disposeOcrProvider(OcrProvider provider) {
    provider.dispose();
  }

  // Offline
  getIt.registerLazySingleton<OcrProvider>(
    () => OcrProviderOfflineImpl(),
    instanceName: 'offline',
    dispose: disposeOcrProvider,
  );
}
