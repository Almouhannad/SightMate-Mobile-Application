import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sight_mate/modules/home/presentation/app_drawer.dart';
import 'package:sight_mate/modules/ocr/presentation/ocr_presentation.dart';
import 'package:sight_mate/modules/shared/i18n/data/l10n/l10n.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: Text(L10n.of(context).appName),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              TabBarItem(text: L10n.current.home),
              TabBarItem(text: L10n.current.textMode),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            DisposablePage(child: HelloWorldWidget()),
            DisposablePage(child: CropTextDetectScreen()),
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
    final textStyle = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.bold,
    );
    return Tab(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Text(text, style: textStyle, semanticsLabel: text),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class DisposablePage extends StatefulWidget {
  final Widget child;
  const DisposablePage({super.key, required this.child});

  @override
  State<DisposablePage> createState() => _DisposablePageState();
}

class _DisposablePageState extends State<DisposablePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class HelloWorldWidget extends StatefulWidget {
  const HelloWorldWidget({super.key});

  @override
  State<HelloWorldWidget> createState() => _HelloWorldWidgetState();
}

class _HelloWorldWidgetState extends State<HelloWorldWidget> {
  final _ttsProvider = GetIt.I.get<TtsProvider>();

  @override
  void initState() {
    super.initState();
    _announcePage();
  }

  Future<void> _announcePage() async {
    await _ttsProvider.speak(L10n.current.home);
  }

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
