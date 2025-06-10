import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';
import 'package:sight_mate/modules/shared/widgets/shared_widgets.dart';
import 'package:sight_mate/modules/vqa/domain/vqa_domain.dart';
import 'package:sight_mate/modules/vqa/presentation/vqa_presentation.dart';

class VqaCaptureScreen extends StatefulWidget {
  final List<int> imageBytes;
  final ui.Image image;

  const VqaCaptureScreen({
    super.key,
    required this.imageBytes,
    required this.image,
  });

  @override
  State<VqaCaptureScreen> createState() => _VqaCaptureScreenState();
}

class _VqaCaptureScreenState extends State<VqaCaptureScreen>
    with SingleTickerProviderStateMixin {
  final _vqaUsecase = VqaUsecase();
  final _ttsProvider = DI.get<TtsProvider>();
  late String _caption;
  bool _isCaptionReady = false;
  late TabController _tabController;
  final _numberOfTabs = 2;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _numberOfTabs, vsync: this);
    _vqaUsecase.captionImageBytes(widget.imageBytes).then((value) {
      if (mounted) {
        setState(() {
          _caption = value;
          _isCaptionReady = true;
          _ttsProvider.speak(_caption);
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
      title: L10n.current.imageMode,
      withDrawer: false,
      appBarBottom: VqaCaptureScreenTabBar(tabController: _tabController),
      body: TabBarView(
        controller: _tabController,
        children: [
          VqaPreviewWidget(
            key: widget.key,
            image: widget.image,
            isCaptionReady: _isCaptionReady,
          ),
          const VqaHistoryWidget(),
        ],
      ),
    );
  }
}
