import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/zen_colors.dart';

class SandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sandPaint = Paint()
      ..color = ZenColors.sand
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Offset.zero & size,
      sandPaint,
    );

    _drawSandTexture(canvas, size);
  }

  void _drawSandTexture(Canvas canvas, Size size) {
    final texturePaint = Paint()
      ..color = ZenColors.sandDark.withValues(alpha: 0.12)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 20.0;

    for (double y = 0; y < size.height; y += spacing) {
      final path = Path();

      for (double x = 0; x <= size.width; x += 10) {
        final wave = math.sin(x / 35) * 2;

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
  bool shouldRepaint(covariant SandPainter oldDelegate) {
    return false;
  }
}