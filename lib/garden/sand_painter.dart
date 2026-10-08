import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/zen_colors.dart';

class SandPainter extends CustomPainter {
  const SandPainter({
    required this.rakePaths,
  });

  final List<List<Offset>> rakePaths;

  @override
  void paint(Canvas canvas, Size size) {
    // Sand background
    final sandPaint = Paint()
      ..color = ZenColors.sand
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Offset.zero & size,
      sandPaint,
    );

    // Decorative sand texture
    _drawTexture(canvas, size);

    // User-created rake marks
    _drawRakes(canvas);
  }

  void _drawTexture(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ZenColors.sandDark.withValues(alpha: 0.12)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 22.0;

    for (double y = 0; y < size.height; y += spacing) {
      final path = Path();

      for (double x = 0; x <= size.width; x += 8) {
        final wave = math.sin(x / 30) * 1.5;

        if (x == 0) {
          path.moveTo(x, y + wave);
        } else {
          path.lineTo(x, y + wave);
        }
      }

      canvas.drawPath(path, paint);
    }
  }

  void _drawRakes(Canvas canvas) {
    final shadowPaint = Paint()
      ..color = ZenColors.sandDark.withValues(alpha: 0.55)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final highlightPaint = Paint()
      ..color = ZenColors.sandLight.withValues(alpha: 0.7)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final points in rakePaths) {
      if (points.length < 2) {
        continue;
      }

      final path = Path();

      path.moveTo(
        points.first.dx,
        points.first.dy,
      );

      for (final point in points.skip(1)) {
        path.lineTo(
          point.dx,
          point.dy,
        );
      }

      // Dark groove
      canvas.drawPath(
        path,
        shadowPaint,
      );

      // Small highlight alongside the groove
      final highlight = Path();

      highlight.moveTo(
        points.first.dx,
        points.first.dy - 2,
      );

      for (final point in points.skip(1)) {
        highlight.lineTo(
          point.dx,
          point.dy - 2,
        );
      }

      canvas.drawPath(
        highlight,
        highlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SandPainter oldDelegate) {
    // Our rake list is mutated in place, so always repaint.
    return true;
  }
}