import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class AppCircularProgressIndicator extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double progressStroke;
  final double backgroundStroke;
  final Color progressStrokeColor;
  final Color backgroundPaintColor;
  final bool showPercentage;
  final double sizePercentageText;
  final Color colorPercentageText;

  const AppCircularProgressIndicator({
    super.key,
    required this.progress,
    this.size = 120,
    this.progressStroke = 16.0,
    this.backgroundStroke = 6.0,
    this.progressStrokeColor = AppColors.blue700,
    this.backgroundPaintColor = AppColors.gray200,
    this.showPercentage = true,
    this.sizePercentageText = 24,
    this.colorPercentageText = AppColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _LimitPainter(
        progress: progress,
        progressStroke: progressStroke,
        backgroundStroke: backgroundStroke,
        progressStrokeColor: progressStrokeColor,
        backgroundPaintColor: backgroundPaintColor,
        showPercentage: showPercentage,
        sizePercentageText: sizePercentageText,
        colorPercentageText: colorPercentageText,
      ),
    );
  }
}

class _LimitPainter extends CustomPainter {
  final double progress;
  final double progressStroke;
  final double backgroundStroke;
  final Color progressStrokeColor;
  final Color backgroundPaintColor;
  final bool showPercentage;
  final double sizePercentageText;
  final Color colorPercentageText;

  _LimitPainter({
    required this.progress,
    required this.progressStroke,
    required this.backgroundStroke,
    required this.progressStrokeColor,
    required this.backgroundPaintColor,
    required this.showPercentage,
    required this.sizePercentageText,
    required this.colorPercentageText,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    final radius = size.width / 2 - progressStroke / 2;
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    final backgroundPaint =
        Paint()
          ..color = backgroundPaintColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = backgroundStroke;

    final progressPaint =
        Paint()
          ..color = progressStrokeColor
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = progressStroke;

    final backgroundRadius = radius + (progressStroke - backgroundStroke) / 2;
    canvas.drawCircle(center, backgroundRadius, backgroundPaint);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );

    if (showPercentage) {
      final percent = '${(progress * 100).round()}%';
      final textSpan = TextSpan(
        text: percent,
        style: TextStyle(
          color: colorPercentageText,
          fontSize: sizePercentageText,
          fontWeight: FontWeight.bold,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout();

      final textOffset = Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      );

      textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(covariant _LimitPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
