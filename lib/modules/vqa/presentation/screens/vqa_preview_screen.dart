import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';
import 'package:sight_mate/modules/shared/widgets/shared_widgets.dart';
import 'package:sight_mate/modules/vqa/domain/vqa_domain.dart';

class VqaPreviewScreen extends StatefulWidget {
  final List<int> imageBytes;
  final ui.Image image;

  const VqaPreviewScreen({
    super.key,
    required this.imageBytes,
    required this.image,
  });

  @override
  State<VqaPreviewScreen> createState() => _VqaPreviewScreenState();
}

class _VqaPreviewScreenState extends State<VqaPreviewScreen> {
  final _vqaUsecase = VqaUsecase();
  final _ttsProvider = DI.get<TtsProvider>();
  late String _caption;
  bool _isCaptionReady = false;

  @override
  void initState() {
    super.initState();
    _vqaUsecase.captionImageBytes(widget.imageBytes).then((value) {
      setState(() {
        _caption = value;
        _isCaptionReady = true;
        _ttsProvider.speak(_caption);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
      title: L10n.current.preview,
      withDrawer: false,
      body: GestureDetector(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: RawImage(image: widget.image, fit: BoxFit.cover),
            ),
            if (!_isCaptionReady)
              Positioned.fill(
                child: Container(
                  color: Colors.black45,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
