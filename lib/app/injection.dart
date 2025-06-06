import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sight_mate/modules/ocr/data/ocr_data.dart';
import 'package:sight_mate/modules/ocr/domain/ocr_domain.dart';
import 'package:sight_mate/modules/shared/theme/theme.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';
import 'package:sight_mate/modules/shared/tts/data/tts_data.dart';

final GetIt DI = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  DI.registerSingleton<SharedPreferences>(prefs);

  // I18nRepository: concrete implementation
  DI.registerLazySingleton<I18nRepository>(() => I18nRepositoryImpl());

  // I18nNotifier: depends on I18nRepository
  DI.registerSingletonAsync<I18nNotifier>(() async {
    final notifier = I18nNotifier(DI<I18nRepository>());
    await notifier.initilize();
    return notifier;
  });
  await DI.isReady<I18nNotifier>();

  // ThemeRepository: concrete implementation
  DI.registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImpl());

  // ThemeNotifier: depends on ThemeRepository
  DI.registerSingletonAsync<ThemeNotifier>(() async {
    final notifier = ThemeNotifier(DI<ThemeRepository>());
    await notifier.initilize();
    return notifier;
  });
  await DI.isReady<ThemeNotifier>();

  // OCR ((LAZY))
  void disposeOcrProvider(OcrProvider provider) {
    provider.dispose();
  }

  // Offline
  DI.registerLazySingleton<OcrProvider>(
    () => OcrProviderOfflineImpl(),
    instanceName: OcrProviderModes.OFFLINE,
    dispose: disposeOcrProvider,
  );

  // TTS
  DI.registerSingletonAsync<TtsProvider>(() async {
    final provider = TtsProviderImpl();
    await provider.initilize();
    return provider;
  }, dispose: (provider) => provider.dispose());
  await DI.isReady<TtsProvider>();
}
