import 'package:flutter/material.dart';
import 'package:sight_mate/modules/home/presentation/app_drawer.dart';
import 'package:sight_mate/modules/shared/i18n/data/l10n/l10n.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: Text(L10n.of(context).appName),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              const TabBarItem(text: 'Home'),
              const TabBarItem(text: 'Live Text Recognition'),
              const TabBarItem(text: 'Crop and Recognize Text'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HelloWorldWidget(),
            HelloWorldWidget(),
            HelloWorldWidget(),
          ],
        ),
      ),
    );
  }
}

class TabBarItem extends StatelessWidget {
  final String text;
  const TabBarItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.labelLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Tab(
      child: Row(
        children: [Text(text, style: textStyle), const SizedBox(width: 6)],
      ),
    );
  }
}

class HelloWorldWidget extends StatelessWidget {
  const HelloWorldWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displayLarge;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(L10n.of(context).helloWorld, style: textStyle)],
      ),
    );
  }
}
