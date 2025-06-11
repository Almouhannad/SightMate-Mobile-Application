import 'package:sight_mate/core/page_route_settings.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';

class VqaHomeScreenRoute extends PageRouteSettings {
  @override
  String get name => L10n.current.imageMode;

  @override
  String get link => '/mode/vqa';
}
