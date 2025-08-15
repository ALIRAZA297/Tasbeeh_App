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
    final radius = size.width / 2 - 20;

    // Draw outer ring shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center + const Offset(4, 4), radius + 15, shadowPaint);

    // Draw outer metallic ring
    final outerRingPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF8E8E93),
          const Color(0xFF48484A),
          const Color(0xFF8E8E93),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius + 15));
    canvas.drawCircle(center, radius + 15, outerRingPaint);

    // Draw inner bezel
    final bezelPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF2C2C2E),
          const Color(0xFF1C1C1E),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius + 5));
    canvas.drawCircle(center, radius + 5, bezelPaint);

    // Draw compass face background
    final facePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: [
          Get.isDarkMode ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
          Get.isDarkMode ? const Color(0xFF1C1C1E) : const Color(0xFFE5E5EA),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, facePaint);

    // Draw degree markings (every 10 degrees)
    final degreeMarkPaint = Paint()
      ..color = Get.isDarkMode ? Colors.white.withOpacity(0.6) : Colors.black54
      ..strokeWidth = 1;

    for (int i = 0; i < 36; i++) {
      final angle = i * 10 * pi / 180 - pi / 2;
      final isMainDirection = i % 9 == 0; // Every 90 degrees
      final isMajorMark = i % 3 == 0; // Every 30 degrees

      final startRadius = isMainDirection ? 0.75 : (isMajorMark ? 0.85 : 0.9);
      final endRadius = 0.95;

      final start = center +
          Offset(cos(angle) * radius * startRadius,
              sin(angle) * radius * startRadius);
      final end = center +
          Offset(
              cos(angle) * radius * endRadius, sin(angle) * radius * endRadius);

      final markPaint = Paint()
        ..color =
            Get.isDarkMode ? Colors.white.withOpacity(0.6) : Colors.black54
        ..strokeWidth = isMainDirection ? 3 : (isMajorMark ? 2 : 1);

      canvas.drawLine(start, end, markPaint);

      // Draw degree numbers for major marks
      if (isMajorMark) {
        final textPainter = TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );

        textPainter.text = TextSpan(
          text: '${i * 10}',
          style: GoogleFonts.roboto(
            color:
                Get.isDarkMode ? Colors.white.withOpacity(0.8) : Colors.black87,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        );
        textPainter.layout();

        final textOffset = center +
            Offset(
              cos(angle) * radius * 0.68 - textPainter.width / 2,
              sin(angle) * radius * 0.68 - textPainter.height / 2,
            );
        textPainter.paint(canvas, textOffset);
      }
    }

    // Draw cardinal direction labels with enhanced styling
    final cardinalDirections = [
      {'label': 'N', 'angle': 0, 'color': Colors.red},
      {'label': 'E', 'angle': 90, 'color': Colors.blue},
      {'label': 'S', 'angle': 180, 'color': Colors.green},
      {'label': 'W', 'angle': 270, 'color': Colors.orange},
    ];

    for (var dir in cardinalDirections) {
      final angle = (dir['angle'] as int) * pi / 180 - pi / 2;
      final textPainter = TextPainter(
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      // Create text with shadow effect
      textPainter.text = TextSpan(
        text: dir['label'] as String,
        style: GoogleFonts.roboto(
          color: dir['color'] as Color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: const Offset(1, 1),
              blurRadius: 2,
              color: Colors.black.withOpacity(0.5),
            ),
          ],
        ),
      );
      textPainter.layout();

      final offset = center +
          Offset(
            cos(angle) * radius * 0.55 - textPainter.width / 2,
            sin(angle) * radius * 0.55 - textPainter.height / 2,
          );
      textPainter.paint(canvas, offset);
    }

    // Draw compass needle (North pointer)
    final needleAngle = -direction * pi / 180 - pi / 2;

    // North needle (red with white outline)
    final northNeedlePath = Path();
    final needleLength = radius * 0.4;
    final needleWidth = 8;

    // Create north needle shape
    northNeedlePath.moveTo(
      center.dx + cos(needleAngle) * needleLength,
      center.dy + sin(needleAngle) * needleLength,
    );
    northNeedlePath.lineTo(
      center.dx + cos(needleAngle + pi / 2) * needleWidth,
      center.dy + sin(needleAngle + pi / 2) * needleWidth,
    );
    northNeedlePath.lineTo(
      center.dx - cos(needleAngle) * needleLength * 0.3,
      center.dy - sin(needleAngle) * needleLength * 0.3,
    );
    northNeedlePath.lineTo(
      center.dx + cos(needleAngle - pi / 2) * needleWidth,
      center.dy + sin(needleAngle - pi / 2) * needleWidth,
    );
    northNeedlePath.close();

    // Draw needle shadow
    canvas.save();
    canvas.translate(2, 2);
    final shadowNeedlePaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(northNeedlePath, shadowNeedlePaint);
    canvas.restore();

    // Draw north needle with gradient
    final northNeedlePaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.red.shade300, Colors.red.shade700],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(northNeedlePath.getBounds());
    canvas.drawPath(northNeedlePath, northNeedlePaint);

    // Draw needle outline
    final needleOutlinePaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawPath(northNeedlePath, needleOutlinePaint);

    // South needle (white/gray)
    final southNeedlePath = Path();
    southNeedlePath.moveTo(
      center.dx - cos(needleAngle) * needleLength,
      center.dy - sin(needleAngle) * needleLength,
    );
    southNeedlePath.lineTo(
      center.dx + cos(needleAngle + pi / 2) * (needleWidth * 0.7),
      center.dy + sin(needleAngle + pi / 2) * (needleWidth * 0.7),
    );
    southNeedlePath.lineTo(
      center.dx + cos(needleAngle) * needleLength * 0.3,
      center.dy + sin(needleAngle) * needleLength * 0.3,
    );
    southNeedlePath.lineTo(
      center.dx + cos(needleAngle - pi / 2) * (needleWidth * 0.7),
      center.dy + sin(needleAngle - pi / 2) * (needleWidth * 0.7),
    );
    southNeedlePath.close();

    final southNeedlePaint = Paint()
      ..color = Get.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    canvas.drawPath(southNeedlePath, southNeedlePaint);
    canvas.drawPath(southNeedlePath, needleOutlinePaint);

    // Qibla direction indicator (golden arrow) - Always points to absolute Qibla direction
    canvas.save();

    final qiblaIndicatorRadius = radius * 0.8;

    // Translate to center and rotate to absolute Qibla direction (not relative to device)
    canvas.translate(center.dx, center.dy);
    canvas.rotate(
        qibla * pi / 180); // Use absolute qibla angle, not relative to device

    // Draw Qibla arrow with Islamic styling (relative to rotated canvas)
    final qiblaPath = Path();
    final arrowLength = 25;
    final arrowWidth = 12;

    final qiblaPoint =
        Offset(0, -qiblaIndicatorRadius); // Point upward in rotated space

    // Create arrow shape
    qiblaPath.moveTo(qiblaPoint.dx, qiblaPoint.dy);
    qiblaPath.lineTo(
      qiblaPoint.dx + arrowWidth,
      qiblaPoint.dy + arrowLength,
    );
    qiblaPath.lineTo(
      qiblaPoint.dx,
      qiblaPoint.dy + (arrowLength * 0.6),
    );
    qiblaPath.lineTo(
      qiblaPoint.dx - arrowWidth,
      qiblaPoint.dy + arrowLength,
    );
    qiblaPath.close();

    // Draw Qibla arrow shadow
    canvas.save();
    canvas.translate(2, 2);
    final qiblaShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawPath(qiblaPath, qiblaShadowPaint);
    canvas.restore();

    // Draw Qibla arrow with golden gradient
    final qiblaPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.amber.shade300, Colors.amber.shade700],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(qiblaPath.getBounds());
    canvas.drawPath(qiblaPath, qiblaPaint);

    // Draw Qibla arrow outline
    final qiblaOutlinePaint = Paint()
      ..color = Colors.amber.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(qiblaPath, qiblaOutlinePaint);

    // Add "QIBLA" text near the arrow (in the same rotated space)
    final qiblaTextPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    qiblaTextPainter.text = TextSpan(
      text: 'QIBLA',
      style: GoogleFonts.roboto(
        color: Colors.amber.shade700,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
    qiblaTextPainter.layout();

    // Position text above the arrow in rotated space
    final textDistance = qiblaIndicatorRadius - 40;
    qiblaTextPainter.paint(
        canvas,
        Offset(-qiblaTextPainter.width / 2,
            -textDistance - qiblaTextPainter.height / 2));

    // Restore canvas state (this restores the rotation and translation)
    canvas.restore();

    // Center pivot with metallic finish
    final centerShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(center + const Offset(2, 2), 12, centerShadowPaint);

    final centerPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF8E8E93),
          const Color(0xFF48484A),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 12));
    canvas.drawCircle(center, 12, centerPaint);

    // Inner center dot
    final centerDotPaint = Paint()
      ..color = Get.isDarkMode ? Colors.white : Colors.black87;
    canvas.drawCircle(center, 4, centerDotPaint);

    // Add compass rose decoration
    _drawCompassRose(canvas, center, radius * 0.25);
  }

  void _drawCompassRose(Canvas canvas, Offset center, double size) {
    final rosePaint = Paint()
      ..color =
          (Get.isDarkMode ? Colors.white : Colors.black87).withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw star pattern
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      final x = center.dx + cos(angle) * size;
      final y = center.dy + sin(angle) * size;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(center.dx, center.dy);
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, rosePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
