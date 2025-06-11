import 'package:flutter/material.dart';
import 'package:sight_mate/modules/shared/widgets/shared_widgets.dart';

class WidgetScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final bool withDrawer;
  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? appBarBottom;

  const WidgetScaffold({
    super.key,
    required this.body,
    required this.title,
    this.withDrawer = true,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.appBarBottom,
  });

  @override
  Widget build(BuildContext context) {
    final appBarBottomHeight = Size.fromHeight(kToolbarHeight - 20);

    final theme = Theme.of(context);
    final textStyle = theme.textTheme.titleLarge!.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onPrimary,
    );

    return Scaffold(
      body: body,
      drawer: withDrawer ? AppDrawer() : null,
      appBar: AppBar(
        title: Text(title, style: textStyle),
        bottom: appBarBottom != null
            ? PreferredSize(
                preferredSize: appBarBottomHeight,
                child: appBarBottom!,
              )
            : null,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
