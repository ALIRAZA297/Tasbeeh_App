import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:tasbeeh_app/Utils/app_colors.dart';

class AnalogClock extends StatelessWidget {
  final DateTime time;

  const AnalogClock({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ClockPainter(time: time),
      size: const Size(60, 60),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime time;

  ClockPainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Clock face
    final facePaint = Paint()
      ..color = primary700.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, facePaint);

    // Clock border
    final borderPaint = Paint()
      ..color = primary700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, borderPaint);

    // Hour markers
    final markerPaint = Paint()
      ..color = white
      ..strokeWidth = 2;
    for (int i = 0; i < 12; i++) {
      final angle = i * 30 * pi / 180;
      final start = center +
          Offset(cos(angle) * radius * 0.85, sin(angle) * radius * 0.85);
      final end = center +
          Offset(cos(angle) * radius * 0.95, sin(angle) * radius * 0.95);
      canvas.drawLine(start, end, markerPaint);
    }

    // Hour hand
    final hourAngle = (time.hour % 12 + time.minute / 60) * 30 * pi / 180;
    final hourHand = Paint()
      ..color = white
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      center,
      center +
          Offset(cos(hourAngle - pi / 2) * radius * 0.5,
              sin(hourAngle - pi / 2) * radius * 0.5),
      hourHand,
    );

    // Minute hand
    final minuteAngle = (time.minute + time.second / 60) * 6 * pi / 180;
    final minuteHand = Paint()
      ..color = white
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      center,
      center +
          Offset(cos(minuteAngle - pi / 2) * radius * 0.7,
              sin(minuteAngle - pi / 2) * radius * 0.7),
      minuteHand,
    );

    // Second hand
    final secondAngle = time.second * 6 * pi / 180;
    final secondHand = Paint()
      ..color = primary300
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      center,
      center +
          Offset(cos(secondAngle - pi / 2) * radius * 0.8,
              sin(secondAngle - pi / 2) * radius * 0.8),
      secondHand,
    );

    // Center dot
    final centerDot = Paint()..color = primary700;
    canvas.drawCircle(center, 3, centerDot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
