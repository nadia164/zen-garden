import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/zen_colors.dart';

class SandBackgroundPainter extends CustomPainter {
  const SandBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final sandPaint = Paint()
      ..color = ZenColors.sand
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Offset.zero & size,
      sandPaint,
    );

    final texturePaint = Paint()
      ..color = ZenColors.sandDark.withValues(
        alpha: 0.10,
      )
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

      canvas.drawPath(path, texturePaint);
    }
  }

  @override
  bool shouldRepaint(
    covariant SandBackgroundPainter oldDelegate,
  ) {
    return false;
  }
}