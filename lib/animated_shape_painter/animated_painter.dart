import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../polygon_sample/animated_polygon_painter.dart';

class MyAnimatedPainter extends StatefulWidget {
  const MyAnimatedPainter({super.key});

  @override
  _MyAnimatedPainterState createState() => _MyAnimatedPainterState();
}

class _MyAnimatedPainterState extends State<MyAnimatedPainter> with TickerProviderStateMixin {
  var _sides = 3.0;

  late Animation<double> animation;
  late AnimationController controller;

  late Animation<double> animation2;
  late AnimationController controller2;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    controller2 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    Tween<double> _radiusTween = Tween(begin: 0.0, end: 200);
    Tween<double> _rotationTween = Tween(begin: -math.pi, end: math.pi);

    animation = _rotationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    animation2 = _radiusTween.animate(controller2)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller2.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller2.forward();
        }
      });

    controller.forward();
    controller2.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polygons'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, snapshot) {
                  return CustomPaint(
                    painter: AnimatedShapePainter(_sides, animation2.value, animation.value),
                    child: Container(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text('Sides'),
            ),
            Slider(
              value: _sides,
              min: 3.0,
              max: 10.0,
              label: _sides.toInt().toString(),
              divisions: 7,
              onChanged: (value) {
                setState(() {
                  _sides = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}