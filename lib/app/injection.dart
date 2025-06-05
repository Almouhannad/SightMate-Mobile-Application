import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sight_mate/modules/ocr/data/ocr_data.dart';
import 'package:sight_mate/modules/ocr/domain/providers/ocr_provider.dart';
import 'package:sight_mate/modules/shared/theme/theme.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';
import 'package:sight_mate/modules/shared/tts/data/tts_data.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // I18nRepository: concrete implementation
  getIt.registerLazySingleton<I18nRepository>(() => I18nRepositoryImpl());

  // I18nNotifier: depends on I18nRepository
  getIt.registerSingletonAsync<I18nNotifier>(() async {
    final notifier = I18nNotifier(getIt<I18nRepository>());
    await notifier.initilize();
    return notifier;
  });
  await getIt.isReady<I18nNotifier>();

  // ThemeRepository: concrete implementation
  getIt.registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImpl());

  // ThemeNotifier: depends on ThemeRepository
  getIt.registerSingletonAsync<ThemeNotifier>(() async {
    final notifier = ThemeNotifier(getIt<ThemeRepository>());
    await notifier.initilize();
    return notifier;
  });
  await getIt.isReady<ThemeNotifier>();

  // OCR ((LAZY))
  void disposeOcrProvider(OcrProvider provider) {
    provider.dispose();
  }

  // Offline
  getIt.registerLazySingleton<OcrProvider>(
    () => OcrProviderOfflineImpl(),
    instanceName: 'offline',
    dispose: disposeOcrProvider,
  );

  // TTS
  getIt.registerSingletonAsync<TtsProvider>(() async {
    final provider = TtsProviderImpl();
    await provider.initilize();
    return provider;
  }, dispose: (provider) => provider.dispose());
  await getIt.isReady<TtsProvider>();
}
