import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class TimerArcPainter extends CustomPainter {
  final double progress; 

  TimerArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center     = Offset(size.width / 2, size.height / 2);
    final radius     = size.width / 2 - 10;
    const strokeW    = 8.0;
    const startAngle = -pi / 2; 
    final sweepAngle = 2 * pi * progress;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color      = AppColors.greenDim
        ..style      = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap  = StrokeCap.round,
    );

    if (progress <= 0) return;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color       = AppColors.green.withOpacity(0.3)
        ..style       = PaintingStyle.stroke
        ..strokeWidth = strokeW + 6
        ..strokeCap   = StrokeCap.round
        ..maskFilter  = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color      = AppColors.green
        ..style      = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap  = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(TimerArcPainter old) => old.progress != progress;
}
