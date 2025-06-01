import 'package:flutter/material.dart';
import 'package:sight_mate/modules/shared/widgets/shared_widgets.dart';

class WidgetScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final bool withDrawer;
  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  const WidgetScaffold({
    super.key,
    required this.body,
    required this.title,
    this.withDrawer = true,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.titleLarge!.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onPrimary,
    );

    return Scaffold(
      body: body,
      drawer: withDrawer ? AppDrawer() : null,
      appBar: AppBar(title: Text(title, style: textStyle)),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
