import 'package:flutter/widgets.dart';
import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';

class PopObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    getIt.get<TtsProvider>().stop();
  }
}
