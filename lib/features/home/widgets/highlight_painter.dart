import 'package:flutter/material.dart';

class HighlightPainter extends CustomPainter {
  final Size highlightSize;
  final Size screenSize;
  final Offset highlightPosition;
  final double highlightRadius;

  HighlightPainter({
    required this.highlightSize,
    required this.highlightPosition,
    required this.highlightRadius,
    required this.screenSize,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;

    canvas.drawPath(
        Path.combine(
          PathOperation.difference,
          Path()
            ..addRRect(
              RRect.fromLTRBR(
                0,
                0,
                screenSize.width,
                screenSize.height,
                Radius.zero,
              ),
            ),
          Path()
            ..addRRect(
              RRect.fromLTRBR(
                highlightPosition.dx,
                highlightPosition.dy,
                highlightPosition.dx + highlightSize.width,
                highlightPosition.dy + highlightSize.height,
                Radius.circular(highlightRadius),
              ),
            ),
        ),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  @override
  bool? hitTest(Offset position) {
    return false;
  }
}
