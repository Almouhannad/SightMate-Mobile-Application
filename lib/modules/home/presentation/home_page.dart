import 'package:flutter/material.dart';
import 'package:sight_mate/modules/home/presentation/app_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: Text('Sight Mate')),
      body: HelloWorldWidget(),
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
        children: [Text('Hello, world!', style: textStyle)],
      ),
    );
  }
}
