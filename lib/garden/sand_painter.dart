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
    _drawSand(canvas, size);
    _drawTexture(canvas, size);
    _drawRakes(canvas);
  }

  void _drawSand(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ZenColors.sand
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Offset.zero & size,
      paint,
    );
  }

  void _drawTexture(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ZenColors.sandDark.withValues(alpha: 0.10)
      ..strokeWidth = 1;

    const spacing = 24.0;

    for (double y = 0; y < size.height; y += spacing) {
      final path = Path();

      for (double x = 0; x <= size.width; x += 8) {
        final wave = math.sin(x / 32) * 1.5;

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
    for (final points in rakePaths) {
      if (points.length < 2) {
        continue;
      }

      _drawSingleRake(
        canvas,
        points,
      );
    }
  }

  void _drawSingleRake(
    Canvas canvas,
    List<Offset> points,
  ) {
    final groovePaint = Paint()
      ..color = ZenColors.sandDark.withValues(
        alpha: 0.55,
      )
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final highlightPaint = Paint()
      ..color = ZenColors.sandLight.withValues(
        alpha: 0.55,
      )
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.round;

    const rakeTeeth = 5;
    const toothSpacing = 5.0;
    const grooveLength = 8.0;

    for (int i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];

      final dx = current.dx - previous.dx;
      final dy = current.dy - previous.dy;

      final distance = math.sqrt(
        dx * dx + dy * dy,
      );

      if (distance < 2) {
        continue;
      }

      // Direction of finger movement.
      final directionX = dx / distance;
      final directionY = dy / distance;

      // Direction perpendicular to finger movement.
      final normalX = -directionY;
      final normalY = directionX;

      for (int tooth = 0;
          tooth < rakeTeeth;
          tooth++) {
        final toothOffset =
            (tooth - (rakeTeeth - 1) / 2) *
                toothSpacing;

        final center = Offset(
          current.dx + normalX * toothOffset,
          current.dy + normalY * toothOffset,
        );

        // Each tooth creates a very short groove
        // rather than one continuous filled region.
        final start = Offset(
          center.dx - directionX * grooveLength / 2,
          center.dy - directionY * grooveLength / 2,
        );

        final end = Offset(
          center.dx + directionX * grooveLength / 2,
          center.dy + directionY * grooveLength / 2,
        );

        canvas.drawLine(
          start,
          end,
          groovePaint,
        );

        // Tiny highlight above the groove.
        final highlightStart = Offset(
          start.dx - normalX * 1.5,
          start.dy - normalY * 1.5,
        );

        final highlightEnd = Offset(
          end.dx - normalX * 1.5,
          end.dy - normalY * 1.5,
        );

        canvas.drawLine(
          highlightStart,
          highlightEnd,
          highlightPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(
    covariant SandPainter oldDelegate,
  ) {
    return true;
  }
}