import 'package:sight_mate/core/page_route_settings.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';

class ObjectRecognitionHomeScreenRoute extends PageRouteSettings {
  @override
  String get name => L10n.current.objectMode;

  @override
  String get link => '/mode/object_recognition';
}
