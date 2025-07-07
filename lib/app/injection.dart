import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sight_mate/modules/ocr/data/ocr_data.dart';
import 'package:sight_mate/modules/ocr/domain/ocr_domain.dart';
import 'package:sight_mate/modules/shared/asr/data/asr_data.dart';
import 'package:sight_mate/modules/shared/asr/domain/asr_domin.dart';
import 'package:sight_mate/modules/shared/authentication/data/authentication_data.dart';
import 'package:sight_mate/modules/shared/authentication/domain/interfaces/authentication_provider.dart';
import 'package:sight_mate/modules/shared/authentication/domain/interfaces/profile_repository.dart';
import 'package:sight_mate/modules/shared/authentication/presentation/authentication_presentation.dart';
import 'package:sight_mate/modules/shared/theme/theme.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';
import 'package:sight_mate/modules/shared/tts/data/tts_data.dart';
import 'package:sight_mate/modules/vqa/domain/vqa_domain.dart';
import 'package:sight_mate/modules/vqa/data/vqa_data.dart';

final GetIt DI = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  DI.registerSingleton<SharedPreferences>(prefs);

  // I18nRepository: concrete implementation
  DI.registerLazySingleton<I18nRepository>(() => I18nRepositoryImpl());

  // I18nNotifier: depends on I18nRepository
  DI.registerSingletonAsync<I18nNotifier>(() async {
    final notifier = I18nNotifier(DI<I18nRepository>());
    await notifier.initialize();
    return notifier;
  });
  await DI.isReady<I18nNotifier>();

  // ThemeRepository: concrete implementation
  DI.registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImpl());

  // ThemeNotifier: depends on ThemeRepository
  DI.registerSingletonAsync<ThemeNotifier>(() async {
    final notifier = ThemeNotifier(DI<ThemeRepository>());
    await notifier.initialize();
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

  // Online
  DI.registerLazySingleton<OcrProvider>(
    () => OcrProviderOnlineImpl(),
    instanceName: OcrProviderModes.ONLINE,
    dispose: disposeOcrProvider,
  );

  // Online connectivity provider
  DI.registerLazySingleton<OcrConnectivityProvider>(
    () => OcrConnectivityProviderImpl(),
  );

  // Mode repository
  DI.registerLazySingleton<OcrModeRepository>(() => OcrModeRepositoryImpl());

  // TTS
  DI.registerSingletonAsync<TtsProvider>(() async {
    final provider = TtsProviderImpl();
    await provider.initilize();
    return provider;
  }, dispose: (provider) => provider.dispose());
  await DI.isReady<TtsProvider>();

  // ASR
  DI.registerSingletonAsync<AsrProvider>(() async {
    final provider = AsrProviderImpl();
    await provider.initilize();
    return provider;
  });
  await DI.isReady<AsrProvider>();

  // VQA
  DI.registerLazySingleton<VqaProvider>(() => VqaProviderImpl());
  DI.registerLazySingleton<VqaConnectivityProvider>(
    () => VqaConnectivityProviderImpl(),
  );

  // Authentication
  DI.registerLazySingleton<AuthenticationProvider>(
    () => AuthenticationProviderImpl(),
  );
  DI.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl());
  DI.registerSingletonAsync<AuthenticationNotifier>(() async {
    final notifier = AuthenticationNotifier(
      DI<AuthenticationProvider>(),
      DI<ProfileRepository>(),
    );
    await notifier.initialize();
    return notifier;
  });
  await DI.isReady<AuthenticationNotifier>();
}
