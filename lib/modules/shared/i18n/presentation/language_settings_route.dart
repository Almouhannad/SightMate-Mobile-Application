import 'package:sight_mate/core/page_route_settings.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';

class LanguageSettingsRoute extends PageRouteSettings {
  @override
  String get link => '/settings/language';

  @override
  String get name => L10n.current.languageSettings;
}
