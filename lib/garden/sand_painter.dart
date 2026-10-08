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
    _drawRakes(canvas);
  }

  void _drawRakes(Canvas canvas) {
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

    for (final points in rakePaths) {
      if (points.length < 2) {
        continue;
      }

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

        final directionX = dx / distance;
        final directionY = dy / distance;

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

          final start = Offset(
            center.dx -
                directionX * grooveLength / 2,
            center.dy -
                directionY * grooveLength / 2,
          );

          final end = Offset(
            center.dx +
                directionX * grooveLength / 2,
            center.dy +
                directionY * grooveLength / 2,
          );

          canvas.drawLine(
            start,
            end,
            groovePaint,
          );

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
  }

  @override
  bool shouldRepaint(
    covariant SandPainter oldDelegate,
  ) {
    return true;
  }
}