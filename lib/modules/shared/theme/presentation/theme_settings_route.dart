import 'package:sight_mate/core/page_route_settings.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';

class ThemeSettingsRoute extends PageRouteSettings {
  @override
  String get link => '/settings/theme';

  @override
  String get name => L10n.current.themeSettings;
}
