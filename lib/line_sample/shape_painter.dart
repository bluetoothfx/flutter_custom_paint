import 'package:flutter/material.dart';

class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    Offset startingPoint = Offset(0, size.height / 2); // (x,y)
    Offset endingPoint = Offset(size.width, size.height / 2); // (x,y)

    canvas.drawLine(startingPoint, endingPoint, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
