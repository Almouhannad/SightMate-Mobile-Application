import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class VqaPreviewWidget extends StatelessWidget {
  const VqaPreviewWidget({
    super.key,
    required image,
    required bool isCaptionReady,
  }) : _isCaptionReady = isCaptionReady,
       _image = image;

  final ui.Image _image;
  final bool _isCaptionReady;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: RawImage(image: _image, fit: BoxFit.cover),
        ),
        if (!_isCaptionReady)
          Positioned.fill(
            child: Container(
              color: Colors.black45,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
