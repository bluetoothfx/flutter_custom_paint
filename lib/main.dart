import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_custom_paint/line_sample/shape_painter.dart'
    show ShapePainter;
import 'package:flutter_custom_paint/line_sample/stroke_painter.dart';

import 'animated_shape_painter/animated_painter.dart';
import 'circle_sample/circle_sample.dart';
import 'image_editor/image_editor_screen.dart';
import 'polygon_sample/polygon_painter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Custom Painter',
      theme: ThemeData(primarySwatch: Colors.pink),
      //home: MyAnimatedPainter(),
      home: DrawingScreen(),
    );
  }
}

class MyPainter extends StatelessWidget {
  const MyPainter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lines')),
      body: CustomPaint(painter: PolygonPainter(), child: Container()),
    );
  }
}

