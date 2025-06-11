import 'package:flutter/material.dart';
import 'package:sight_mate/modules/shared/i18n/data/l10n/l10n.dart';

class HelloWorldWidget extends StatelessWidget {
  const HelloWorldWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displaySmall;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text(L10n.current.helloWorld, style: textStyle)),
        ],
      ),
    );
  }
}
