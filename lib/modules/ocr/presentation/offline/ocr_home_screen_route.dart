import 'package:sight_mate/core/page_route_settings.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';

class OcrHomeScreenRoute extends PageRouteSettings {
  @override
  String get name => L10n.current.textMode;

  @override
  String get link => '/mode/ocr';
}
