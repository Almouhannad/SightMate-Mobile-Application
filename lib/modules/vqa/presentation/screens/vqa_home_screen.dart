import 'package:flutter/widgets.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/shared/widgets/widget_scaffold.dart';

class VqaHomeScreen extends StatelessWidget {
  const VqaHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(body: Placeholder(), title: L10n.current.imageMode);
  }
}
