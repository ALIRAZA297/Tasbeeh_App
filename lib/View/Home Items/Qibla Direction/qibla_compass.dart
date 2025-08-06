import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Utils/app_colors.dart';

class QiblaCompassPainter extends CustomPainter {
  final double direction; // Device heading (0-360°)
  final double qibla; // Qibla direction (degrees from North)

  QiblaCompassPainter({required this.direction, required this.qibla});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Hour markers (12 main directions)
    final markerPaint = Paint()
      ..color = Get.isDarkMode ? white.withOpacity(0.7) : black54
      ..strokeWidth = 2;

    for (int i = 0; i < 12; i++) {
      final angle = i * 30 * pi / 180 - pi / 2; // Start from top (North)
      final start = center +
          Offset(cos(angle) * radius * 0.85, sin(angle) * radius * 0.85);
      final end = center +
          Offset(cos(angle) * radius * 0.95, sin(angle) * radius * 0.95);
      canvas.drawLine(start, end, markerPaint);
    }

    // Cardinal direction markers (N, E, S, W)
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final directions = ['N', 'E', 'S', 'W'];
    for (int i = 0; i < 4; i++) {
      final angle = i * 90 * pi / 180 - pi / 2;
      textPainter.text = TextSpan(
        text: directions[i],
        style: GoogleFonts.poppins(
          color: Get.isDarkMode ? white : black87,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();

      final offset = center +
          Offset(
            cos(angle) * radius * 0.75 - textPainter.width / 2,
            sin(angle) * radius * 0.75 - textPainter.height / 2,
          );
      textPainter.paint(canvas, offset);
    }

    // North indicator (red)
    final northAngle = -direction * pi / 180 - pi / 2;
    final northPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final northStart =
        center + Offset(cos(northAngle) * 15, sin(northAngle) * 15);
    final northEnd = center +
        Offset(cos(northAngle) * radius * 0.6, sin(northAngle) * radius * 0.6);
    canvas.drawLine(northStart, northEnd, northPaint);

    // Draw North arrow head
    final arrowAngle1 = northAngle - pi / 6;
    final arrowAngle2 = northAngle + pi / 6;
    final arrowEnd1 =
        northEnd + Offset(cos(arrowAngle1) * -15, sin(arrowAngle1) * -15);
    final arrowEnd2 =
        northEnd + Offset(cos(arrowAngle2) * -15, sin(arrowAngle2) * -15);

    canvas.drawLine(northEnd, arrowEnd1, northPaint);
    canvas.drawLine(northEnd, arrowEnd2, northPaint);

    // Qibla indicator (gold)
    final qiblaAngle = (qibla - direction) * pi / 180 - pi / 2;
    final qiblaPaint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final qiblaStart =
        center + Offset(cos(qiblaAngle) * 20, sin(qiblaAngle) * 20);
    final qiblaEnd = center +
        Offset(cos(qiblaAngle) * radius * 0.8, sin(qiblaAngle) * radius * 0.8);
    canvas.drawLine(qiblaStart, qiblaEnd, qiblaPaint);

    // Draw Qibla arrow head
    final qiblaArrowAngle1 = qiblaAngle - pi / 6;
    final qiblaArrowAngle2 = qiblaAngle + pi / 6;
    final qiblaArrowEnd1 = qiblaEnd +
        Offset(cos(qiblaArrowAngle1) * -20, sin(qiblaArrowAngle1) * -20);
    final qiblaArrowEnd2 = qiblaEnd +
        Offset(cos(qiblaArrowAngle2) * -20, sin(qiblaArrowAngle2) * -20);

    canvas.drawLine(qiblaEnd, qiblaArrowEnd1, qiblaPaint);
    canvas.drawLine(qiblaEnd, qiblaArrowEnd2, qiblaPaint);

    // Center dot
    final centerDot = Paint()..color = primary700;
    canvas.drawCircle(center, 8, centerDot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
