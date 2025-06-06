import 'dart:math';
import 'package:flutter/material.dart';

class ImageRectangleMapper {
  final GlobalKey imageKey;
  final Size imageSize;
  Offset? _start;
  Offset? _current;

  ImageRectangleMapper({required this.imageKey, required this.imageSize});

  void onPanStart(DragStartDetails details) {
    final box = imageKey.currentContext!.findRenderObject() as RenderBox;
    final local = box.globalToLocal(details.globalPosition);
    _start = local;
    _current = local;
  }

  void onPanUpdate(DragUpdateDetails details) {
    final box = imageKey.currentContext!.findRenderObject() as RenderBox;
    final local = box.globalToLocal(details.globalPosition);
    _current = local;
  }

  /// Maps the user drag rectangle (in widget coordinates) into the underlying
  /// image's pixel coordinates (accounting for a BoxFit.cover transform)
  Rect? mapToImageRect() {
    if (_start == null || _current == null) return null;

    final box = imageKey.currentContext!.findRenderObject() as RenderBox;
    final dispSize = box.size;
    final imgW = imageSize.width;
    final imgH = imageSize.height;

    // Because the Image is drawn with BoxFit.cover =>
    //   scale = max(dispW / imgW, dispH / imgH)
    final scale = max(dispSize.width / imgW, dispSize.height / imgH);
    final fittedW = imgW * scale;
    final fittedH = imgH * scale;

    final dx = (dispSize.width - fittedW) / 2;
    final dy = (dispSize.height - fittedH) / 2;

    // Convert both the start and current drag points into image-space
    final x1 = ((_start!.dx - dx) / scale).clamp(0.0, imgW);
    final y1 = ((_start!.dy - dy) / scale).clamp(0.0, imgH);
    final x2 = ((_current!.dx - dx) / scale).clamp(0.0, imgW);
    final y2 = ((_current!.dy - dy) / scale).clamp(0.0, imgH);

    return Rect.fromLTRB(min(x1, x2), min(y1, y2), max(x1, x2), max(y1, y2));
  }

  /// Returns the original screen coordinates for drawing the selection rectangle
  Rect? getScreenRect() {
    if (_start == null || _current == null) return null;
    return Rect.fromPoints(_start!, _current!);
  }
}
