import 'dart:math' as math;

import 'package:flutter/material.dart';

class PolygonPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    int sides = 7; // Number of sides for the polygon
    int radius = 100; // Radius of the polygon
    Offset center = Offset(size.width /2, size.height / 2);

    var path = Path();
    var angle =  (2 * math.pi) / sides; // 5 sides for pentagon

    Offset startPoint = Offset(radius * math.cos(0.0), radius* math.sin(0.0));
    path.moveTo(startPoint.dx+ center.dx, startPoint.dy + center.dy);

    for (int i = 1; i <= sides; i++) {
      double x = radius * math.cos(angle * i) + center.dx;
      double y = radius * math.sin(angle * i) + center.dy;
      path.lineTo(x , y );
    }

    path.close(); // Close the path to form a polygon
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}