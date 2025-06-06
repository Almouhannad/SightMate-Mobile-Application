import 'package:flutter/material.dart';

class SelectionPainter extends CustomPainter {
  final Offset start;
  final Offset end;

  const SelectionPainter(this.start, this.end);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.yellow;
    canvas.drawRect(Rect.fromPoints(start, end), paint);
  }

  @override
  bool shouldRepaint(covariant SelectionPainter old) {
    return old.start != start || old.end != end;
  }
}
